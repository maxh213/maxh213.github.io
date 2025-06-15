# Max Harris - Personal CV Site

Basic profile site made needlessly complicated by writing it with Gleam.

Completely stole the set up from https://github.com/gleam-lang/website, kind of just made this as a mini way to learn Gleam.

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
gleam deps download

# Build the site
gleam run

# Just open dist/index.html in your browser to view the site

# Clean build files
rm -rf dist build
```

## Deployment

The site automatically deploys to GitHub Pages when pushing to the `main` branch via GitHub Actions.