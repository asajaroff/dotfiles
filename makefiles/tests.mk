.PHONY: pre-commit all clean test

all:
clean:
test:

pre-commit: ## Execute the pre-commit hook
	pre-commit validate-config
	pre-commit validate-manifest
	pre-commit run --all-files --color auto
