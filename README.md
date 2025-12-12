# Minimal CV site in Haskell
![Haskell](https://img.shields.io/badge/Haskell-9.12.2-purple.svg)

Basic profile site made needlessly complicated by writing it with Haskell.

## Tech Stack

- **Haskell** - Static site generation
- **CSS** - Animations and styling
- **GitHub Actions** - CI/CD
- **GitHub Pages** - Hosting

## Development

### Prerequisites

- [GHC](https://www.haskell.org/ghc/) >= 9.12.2
- [Cabal](https://www.haskell.org/cabal/) >= 3.0

### Commands

```bash
# Update package index
cabal update

# Build the site generator
cabal build

# Generate the site
cabal run site-generator

# Just open dist/index.html in your browser to view the site

# Clean build files
rm -rf dist dist-newstyle
```

## Deployment

The site automatically deploys to GitHub Pages when pushing to the `main` branch via GitHub Actions.
