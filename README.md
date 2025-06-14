# Max Harris - Personal CV Site

Basic profile site made needlessly complicated by writing it with Gleam.

## Tech Stack

- **Gleam** - Static site generation
- **CSS** - Animations and styling
- **GitHub Actions** - CI/CD
- **GitHub Pages** - Hosting

## Development

### Prerequisites

- [Gleam](https://gleam.run/getting-started/installing/) >= 1.0.0
- [Erlang/OTP](https://www.erlang.org/downloads) >= 26.0

### Commands

```bash
# Install dependencies
make deps

# Build the site
make build

# Serve locally at http://localhost:8000
make serve

# Clean build files
make clean
```

## Deployment

The site automatically deploys to GitHub Pages when pushing to the `main` branch via GitHub Actions.