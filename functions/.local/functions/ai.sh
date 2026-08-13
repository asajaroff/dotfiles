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
                "tools": ["Read", "Bash"],
                "model": "sonnet"
            }
        }'

        # shellcheck disable=SC1112  # unicode apostrophes are intentional (RFC 2119 quotes contain literal apostrophes that would break a single-quoted bash string)
        local prompt='Create a <git commit -m MESSAGE> and output it to stdout
   - Follow the Conventional Commit standard:
```markdown
The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in RFC 2119.

    Commits MUST be prefixed with a type, which consists of a noun, feat, fix, etc., followed by the OPTIONAL scope, OPTIONAL !, and REQUIRED terminal colon and space.
    The type feat MUST be used when a commit adds a new feature to your application or library.
    The type fix MUST be used when a commit represents a bug fix for your application.
    A scope MAY be provided after a type. A scope MUST consist of a noun describing a section of the codebase surrounded by parenthesis, e.g., fix(parser):
    A description MUST immediately follow the colon and space after the type/scope prefix. The description is a short summary of the code changes, e.g., fix: array parsing issue when multiple spaces were contained in string.
    A longer commit body MAY be provided after the short description, providing additional contextual information about the code changes. The body MUST begin one blank line after the description.
    A commit body is free-form and MAY consist of any number of newline separated paragraphs.
    One or more footers MAY be provided one blank line after the body. Each footer MUST consist of a word token, followed by either a :<space> or <space># separator, followed by a string value (this is inspired by the git trailer convention).
    A footer’s token MUST use - in place of whitespace characters, e.g., Acked-by (this helps differentiate the footer section from a multi-paragraph body). An exception is made for BREAKING CHANGE, which MAY also be used as a token.
    A footer’s value MAY contain spaces and newlines, and parsing MUST terminate when the next valid footer token/separator pair is observed.
    Breaking changes MUST be indicated in the type/scope prefix of a commit, or as an entry in the footer.
    If included as a footer, a breaking change MUST consist of the uppercase text BREAKING CHANGE, followed by a colon, space, and description, e.g., BREAKING CHANGE: environment variables now take precedence over config files.
    If included in the type/scope prefix, breaking changes MUST be indicated by a ! immediately before the :. If ! is used, BREAKING CHANGE: MAY be omitted from the footer section, and the commit description SHALL be used to describe the breaking change.
    Types other than feat and fix MAY be used in your commit messages, e.g., docs: update ref docs.
    The units of information that make up Conventional Commits MUST NOT be treated as case sensitive by implementors, with the exception of BREAKING CHANGE which MUST be uppercase.
    BREAKING-CHANGE MUST be synonymous with BREAKING CHANGE, when used as a token in a footer.

```
   - Keep the message simple and commits as short as possible
   - The expected result of this execution is a command that I can copy paste
   - Do not include co-authorship of coding agents or AI'

        if [[ "$dry_run" == true ]]; then
            [[ "$verbose" == true ]] && echo "Running in dry-run mode..."
            command claude --agents "$agents_config" --allowedTools "Bash(git *)" -p "$prompt" "${extra_args[@]}"
        else
            [[ "$verbose" == true ]] && echo "Generating commit message..."
            command claude --agents "$agents_config" --allowedTools "Bash(git *)" -p "$prompt" "${extra_args[@]}"
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

    local current_branch
    current_branch=$(git branch --show-current)
    if [[ "$current_branch" == "$base_branch" ]]; then
        echo "Error: Currently on base branch '$base_branch'. Switch to a feature branch first."
        return 1
    fi

    local agents_config='{
        "pr-writer": {
            "description": "Pull request description writer",
            "prompt": "Your responsibility is to analyze git changes and write clear, comprehensive pull request descriptions. Follow markdown formatting and include summary, changes, and testing notes.",
            "tools": ["Read", "Bash"],
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

    command claude --agents "$agents_config" --allowedTools "Bash(git *)" -p "$prompt" "${extra_args[@]}"
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
            "tools": ["Read", "Bash", "Grep"],
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

    command claude --agents "$agents_config" --allowedTools "Bash(git *)" -p "$prompt" "${files[@]}"
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
            "tools": ["Read", "Bash"],
            "model": "sonnet"
        }
    }'

    local prompt="Explain the changes in commit '$commit_hash' in plain language
   - Summarize what was changed
   - Explain the purpose of the changes
   - Note any important implications
   - Keep it concise and clear"

    command claude --agents "$agents_config" --allowedTools "Bash(git *)" -p "$prompt"
}
