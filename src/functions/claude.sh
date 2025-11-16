#!/usr/bin/env bash

# Claude wrapper function with custom agents
function ai() {
  local agents_config='{
    "code-reviewer": {
      "description": "Expert code reviewer. Use proactively after code changes.",
      "prompt": "You are a senior code reviewer. Focus on code quality, security, and best practices.",
      "tools": ["Read", "Grep", "Glob", "Bash", "kubectl get", "kubectl describe"],
      "model": "sonnet"
    }
  }'

  command claude --agents "$agents_config" "$@"
}

function aigc() {
  local agents_config='{
    "debugger": {
      "description": "Code committer",
      "prompt": "Your responsibility is to keep good git etiquette. Write all commits following the conventional commit standard. Never include CLAUDE authorship in commits. Write a commit message with the staged changes.",
      "tools": ["git commit", "ls", "read", "Bash"],
      "model": "sonnet"
    }
  }'

  command claude --agents "$agents_config" -p 'Create a <git commit -m MESSAGE> and output it to stdout
  - Follow the Conventional Commit standard
  - Keep the message simple and commits as short as possible
  - The expected result of this execution is a command that I can copy paste
  - Do not include co-authorship of coding agents or AI' "$@"
}
