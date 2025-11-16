#!/usr/bin/env bash

# Claude wrapper function with custom agents
function ai() {
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

function aigc() {
  local agents_config='{
    "debugger": {
      "description": "Code committer",
      "prompt": "Your responsability is to keep good git etiquette. Write all commits following the conventional commit standard. Never include CLAUDE authorship in commits. Write a commit message with the staged changes.",
      "tools": ["git", "ls", "read", "Bash"],
      "model": "sonnet"
    }
  }'

  command claude --agents "$agents_config" "Create a git commit with the staged changes in the Conventional Commit Format"
}