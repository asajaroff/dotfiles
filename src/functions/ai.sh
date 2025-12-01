#!/usr/bin/env bash


function ai-commit() {

  # TODO add argparser
  # TODO add --dry-run flag for printing to stdout
  # TODO detect CHANGELOG file and update it
  local agents_config='{
    "code-commiter": {
      "description": "Code committer",
      "prompt": "Your responsibility is to keep good git etiquette. Write all commits following the conventional commit standard. Never include CLAUDE authorship in commits. Write a commit message with the staged changes.",
      "tools": ["git status", "ls", "read", "Bash"],
      "model": "sonnet"
    }
  }'
  command claude --agents "$agents_config" -p 'Create a <git commit -m MESSAGE> and output it to stdout
   - Follow the Conventional Commit standard
   - Keep the message simple and commits as short as possible
   - The expected result of this execution is a command that I can copy paste
   - Do not include co-authorship of coding agents or AI' "$@"
}