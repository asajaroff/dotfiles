#!/usr/bin/env bash

# AI-powered Git commit message generator
# Usage: ai-commit [OPTIONS]
# Options:
#   -d, --dry-run     Print commit command to stdout without executing
#   -h, --help        Show this help message
#   -v, --verbose     Enable verbose output
function ai-commit() {
    local dry_run=false
    local verbose=false
    local extra_args=()

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--dry-run)
                dry_run=true
                shift
                ;;
            -h|--help)
                echo "Usage: ai-commit [OPTIONS]"
                echo ""
                echo "Generate AI-powered conventional commit messages for staged changes."
                echo ""
                echo "Options:"
                echo "  -d, --dry-run     Print commit command to stdout without executing"
                echo "  -h, --help        Show this help message"
                echo "  -v, --verbose     Enable verbose output"
                echo ""
                echo "Examples:"
                echo "  ai-commit                 # Generate and execute commit"
                echo "  ai-commit --dry-run       # Generate commit command only"
                return 0
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            *)
                extra_args+=("$1")
                shift
                ;;
        esac
    done

    # Check if there are staged changes
    if ! git diff --cached --quiet 2>/dev/null; then
        local agents_config='{
            "code-commiter": {
                "description": "Code committer",
                "prompt": "Your responsibility is to keep good git etiquette. Write all commits following the conventional commit standard. Never include CLAUDE authorship in commits. Write a commit message with the staged changes.",
                "tools": ["git status", "ls", "read", "Bash"],
                "model": "sonnet"
            }
        }'

        local prompt='Create a <git commit -m MESSAGE> and output it to stdout
   - Follow the Conventional Commit standard
   - Keep the message simple and commits as short as possible
   - The expected result of this execution is a command that I can copy paste
   - Do not include co-authorship of coding agents or AI'

        if [[ "$dry_run" == true ]]; then
            [[ "$verbose" == true ]] && echo "Running in dry-run mode..."
            command claude --agents "$agents_config" -p "$prompt" "${extra_args[@]}"
        else
            [[ "$verbose" == true ]] && echo "Generating commit message..."
            command claude --agents "$agents_config" -p "$prompt" "${extra_args[@]}"
        fi
    else
        echo "Error: No staged changes found. Use 'git add' to stage changes first."
        return 1
    fi
}

# AI-powered pull request description generator
# Usage: ai-pr [OPTIONS]
# Options:
#   -b, --base BRANCH    Base branch for PR (default: master)
#   -h, --help          Show this help message
#   -t, --title TITLE   Custom PR title
function ai-pr() {
    local base_branch="master"
    local pr_title=""
    local extra_args=()

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -b|--base)
                base_branch="$2"
                shift 2
                ;;
            -t|--title)
                pr_title="$2"
                shift 2
                ;;
            -h|--help)
                echo "Usage: ai-pr [OPTIONS]"
                echo ""
                echo "Generate AI-powered pull request descriptions."
                echo ""
                echo "Options:"
                echo "  -b, --base BRANCH    Base branch for PR (default: master)"
                echo "  -h, --help          Show this help message"
                echo "  -t, --title TITLE   Custom PR title"
                echo ""
                echo "Examples:"
                echo "  ai-pr                           # Generate PR description"
                echo "  ai-pr --base dev                # Compare against dev branch"
                echo "  ai-pr --title 'Add new feature' # Custom PR title"
                return 0
                ;;
            *)
                extra_args+=("$1")
                shift
                ;;
        esac
    done

    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Error: Not in a git repository"
        return 1
    fi

    local current_branch=$(git branch --show-current)
    if [[ "$current_branch" == "$base_branch" ]]; then
        echo "Error: Currently on base branch '$base_branch'. Switch to a feature branch first."
        return 1
    fi

    local agents_config='{
        "pr-writer": {
            "description": "Pull request description writer",
            "prompt": "Your responsibility is to analyze git changes and write clear, comprehensive pull request descriptions. Follow markdown formatting and include summary, changes, and testing notes.",
            "tools": ["git status", "git diff", "ls", "read", "Bash"],
            "model": "sonnet"
        }
    }'

    local prompt="Generate a pull request description for merging '$current_branch' into '$base_branch'
   - Include a summary of changes
   - List key modifications
   - Suggest testing steps if applicable
   - Use markdown formatting
   - Be concise but comprehensive"

    [[ -n "$pr_title" ]] && prompt="$prompt\n - Use this title: $pr_title"

    command claude --agents "$agents_config" -p "$prompt" "${extra_args[@]}"
}

# AI-powered code review assistant
# Usage: ai-review [OPTIONS] [FILES...]
# Options:
#   -h, --help          Show this help message
#   -a, --all           Review all modified files
#   -s, --staged        Review only staged files
function ai-review() {
    local review_all=false
    local staged_only=false
    local files=()

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                echo "Usage: ai-review [OPTIONS] [FILES...]"
                echo ""
                echo "AI-powered code review for changed files."
                echo ""
                echo "Options:"
                echo "  -h, --help          Show this help message"
                echo "  -a, --all           Review all modified files"
                echo "  -s, --staged        Review only staged files"
                echo ""
                echo "Examples:"
                echo "  ai-review file.sh              # Review specific file"
                echo "  ai-review --all                # Review all modified files"
                echo "  ai-review --staged             # Review staged changes"
                return 0
                ;;
            -a|--all)
                review_all=true
                shift
                ;;
            -s|--staged)
                staged_only=true
                shift
                ;;
            *)
                files+=("$1")
                shift
                ;;
        esac
    done

    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Error: Not in a git repository"
        return 1
    fi

    local agents_config='{
        "code-reviewer": {
            "description": "Code reviewer",
            "prompt": "Your responsibility is to review code changes and provide constructive feedback. Focus on best practices, potential bugs, security issues, and improvements. Be helpful and educational.",
            "tools": ["git status", "git diff", "ls", "read", "Bash", "Grep"],
            "model": "sonnet"
        }
    }'

    local target=""
    if [[ "$review_all" == true ]]; then
        target="all modified files"
    elif [[ "$staged_only" == true ]]; then
        target="staged changes"
    elif [[ ${#files[@]} -gt 0 ]]; then
        target="files: ${files[*]}"
    else
        echo "Error: Specify files to review or use --all/--staged"
        return 1
    fi

    local prompt="Review the code changes in $target
   - Identify potential bugs or issues
   - Suggest improvements following best practices
   - Check for security vulnerabilities
   - Note any code style inconsistencies
   - Be constructive and educational"

    command claude --agents "$agents_config" -p "$prompt" "${files[@]}"
}

# AI-powered commit message explainer
# Usage: ai-explain [COMMIT_HASH]
function ai-explain() {
    local commit_hash="${1:-HEAD}"

    if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
        echo "Usage: ai-explain [COMMIT_HASH]"
        echo ""
        echo "Explain what a commit does in plain language."
        echo ""
        echo "Arguments:"
        echo "  COMMIT_HASH    Git commit hash (default: HEAD)"
        echo ""
        echo "Examples:"
        echo "  ai-explain              # Explain latest commit"
        echo "  ai-explain abc123       # Explain specific commit"
        return 0
    fi

    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Error: Not in a git repository"
        return 1
    fi

    # Verify commit exists
    if ! git cat-file -e "$commit_hash^{commit}" 2>/dev/null; then
        echo "Error: Invalid commit hash '$commit_hash'"
        return 1
    fi

    local agents_config='{
        "commit-explainer": {
            "description": "Commit explainer",
            "prompt": "Your responsibility is to analyze git commits and explain them in plain, understandable language. Focus on what changed and why it matters.",
            "tools": ["git show", "git diff", "read", "Bash"],
            "model": "sonnet"
        }
    }'

    local prompt="Explain the changes in commit '$commit_hash' in plain language
   - Summarize what was changed
   - Explain the purpose of the changes
   - Note any important implications
   - Keep it concise and clear"

    command claude --agents "$agents_config" -p "$prompt"
}