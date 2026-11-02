#!/usr/bin/env python3
"""
Asynchronously execute kubectl commands across multiple Kubernetes clusters.
"""

import argparse
import asyncio
import json
import sys
from typing import Dict, List, Optional
from dataclasses import dataclass
from pathlib import Path


@dataclass
class ClusterResult:
    """Result from a kubectl command execution on a cluster."""
    context: str
    success: bool
    stdout: str
    stderr: str
    returncode: int


async def get_contexts() -> List[str]:
    """Get list of all available Kubernetes contexts."""
    proc = await asyncio.create_subprocess_exec(
        'kubectl', 'config', 'get-contexts', '-o', 'name',
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE
    )
    stdout, stderr = await proc.communicate()

    if proc.returncode != 0:
        print(f"Error getting contexts: {stderr.decode()}", file=sys.stderr)
        return []

    contexts = stdout.decode().strip().split('\n')
    return [ctx for ctx in contexts if ctx]


async def run_kubectl_command(context: str, command: List[str], timeout: int = 30) -> ClusterResult:
    """
    Run a kubectl command against a specific context.

    Args:
        context: Kubernetes context name
        command: kubectl command arguments (without 'kubectl' prefix)
        timeout: Command timeout in seconds

    Returns:
        ClusterResult with command output and status
    """
    full_command = ['kubectl', '--context', context] + command

    try:
        proc = await asyncio.create_subprocess_exec(
            *full_command,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE
        )

        stdout, stderr = await asyncio.wait_for(
            proc.communicate(),
            timeout=timeout
        )

        return ClusterResult(
            context=context,
            success=proc.returncode == 0,
            stdout=stdout.decode(),
            stderr=stderr.decode(),
            returncode=proc.returncode
        )

    except asyncio.TimeoutError:
        return ClusterResult(
            context=context,
            success=False,
            stdout="",
            stderr=f"Command timed out after {timeout} seconds",
            returncode=-1
        )
    except Exception as e:
        return ClusterResult(
            context=context,
            success=False,
            stdout="",
            stderr=f"Error executing command: {str(e)}",
            returncode=-1
        )


async def query_all_clusters(
    command: List[str],
    contexts: Optional[List[str]] = None,
    timeout: int = 30
) -> List[ClusterResult]:
    """
    Run a kubectl command across all or specified clusters concurrently.

    Args:
        command: kubectl command arguments (e.g., ['get', 'pods', '-A'])
        contexts: Optional list of specific contexts to query. If None, queries all.
        timeout: Command timeout in seconds

    Returns:
        List of ClusterResult objects
    """
    if contexts is None:
        contexts = await get_contexts()

    if not contexts:
        print("No contexts found", file=sys.stderr)
        return []

    tasks = [run_kubectl_command(ctx, command, timeout) for ctx in contexts]
    results = await asyncio.gather(*tasks)
    return results


def print_results(results: List[ClusterResult], show_errors: bool = True, only_success: bool = False):
    """
    Pretty print the results from multiple clusters.

    Args:
        results: List of ClusterResult objects
        show_errors: Whether to display error output
        only_success: If True, only show successful results
    """
    for result in results:
        # Skip failed results if only_success is True
        if only_success and not result.success:
            continue

        print(f"Context: {result.context}")

        if result.stdout:
            print(result.stdout)

        if show_errors and result.stderr:
            print(f"Errors:\n{result.stderr}", file=sys.stderr)


async def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description='Asynchronously execute kubectl commands across multiple Kubernetes clusters.',
        usage='%(prog)s [options] <kubectl-command> [args...]'
    )
    parser.add_argument(
        '--only-success',
        action='store_true',
        help='Only show output from successful clusters (hide failures)'
    )
    parser.add_argument(
        'command',
        nargs='+',
        help='kubectl command and arguments to execute'
    )

    args = parser.parse_args()

    print(f"Querying all clusters with command: kubectl {' '.join(args.command)}\n")

    results = await query_all_clusters(args.command)
    print_results(results, only_success=args.only_success)

    # Print summary
    successful = sum(1 for r in results if r.success)
    total = len(results)
    print(f"Summary: {successful}/{total} clusters succeeded")


if __name__ == "__main__":
    asyncio.run(main())
