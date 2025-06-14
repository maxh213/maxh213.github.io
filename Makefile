.PHONY: build serve clean deps help

build: ## Build the website
	gleam run

serve: build ## Build and serve locally (requires Python)
	cd dist && python3 -m http.server 8000

clean: ## Clean build artifacts
	rm -rf dist build

deps: ## Install dependencies
	gleam deps download

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'