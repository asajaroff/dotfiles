#!/usr/bin/env bash

# Claude wrapper function with custom agents
ai() {
  local agents_config='{
    "code-reviewer": {
      "description": "Expert code reviewer. Use proactively after code changes.",
      "prompt": "You are a senior code reviewer. Focus on code quality, security, and best practices.",
      "tools": ["Read", "Grep", "Glob", "Bash"],
      "model": "sonnet"
    },
    "debugger": {
      "description": "Debugging specialist for errors and test failures.",
      "prompt": "You are an expert debugger. Analyze errors, identify root causes, and provide fixes.",
      "tools": ["Read", "Grep", "Glob", "Bash"],
      "model": "sonnet"
    }
  }'

  command claude --agents "$agents_config" "$@"
}