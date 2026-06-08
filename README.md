# Rido Blog

This is the source of Rido blog, using Jekyll on GitHub Pages, based on [Forever Jekyll - ](https://forever-jekyll.github.io)

> Note: Go to the forked repo for more details on this template.

# [https://blog.rido.dev](https://blog.rido.dev)

## Netlify staging

This repo now includes `netlify.toml` and `scripts/netlify-build.sh` so Netlify can build the site and generate correct preview URLs for branch deploys and PR deploy previews.

Recommended Netlify setup:

- Production branch: `main`
- Branch deploy: `dev`
- Deploy previews: enabled for pull requests

The Netlify build command is handled in-repo and publishes `_site`.

See `docs/netlify-staging.md` for the recommended Netlify UI settings.
