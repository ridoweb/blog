# Netlify staging setup

This repo is configured so Netlify can be used for post review without changing the current Azure Static Web Apps deployment.

## In-repo configuration

- `netlify.toml` defines the Netlify build command and publish directory.
- `scripts/netlify-build.sh` runs the Jekyll build and, for preview deploys, overrides `site.url` with Netlify's deploy URL.

That override keeps preview canonical and share links pointed at the preview URL instead of `https://blog.rido.dev`.

## Recommended Netlify site settings

Create a Netlify site connected to this repository and set:

- Base directory: blank
- Build command: `./scripts/netlify-build.sh`
- Publish directory: `_site`
- Production branch: `main`

Then enable:

- Deploy previews for pull requests
- Branch deploys for `dev`

## Suggested environment mapping

- `main`: production on the primary site
- `dev`: shared staging URL for reviewing draft posts and layout changes
- Pull requests into `main` or `dev`: isolated deploy preview URLs

## Coexistence with Azure Static Web Apps

The existing GitHub Actions workflow in `.github/workflows/staging-dev.yml` is unchanged.

This means you can:

- keep Azure as the current deployed environment
- use Netlify immediately for preview and staging review
- migrate production later only if the Netlify flow works well

## Notes

- Netlify needs Bundler available in its build image; the repo already includes `Gemfile` and `Gemfile.lock`.
- If Netlify requires a specific Ruby version, add it in Netlify environment settings or via a repo-level Ruby version file.
