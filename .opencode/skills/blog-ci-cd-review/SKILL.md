---
name: blog-ci-cd-review
description: GitHub Actions, Azure Static Web Apps, Netlify, staging, deploy previews, CI/CD pipeline review for this Jekyll blog. Use when reviewing or improving repo automation, preview environments, branch deploys, or post-review publishing flow.
---

# Blog CI/CD Review

Use this skill when the task is to review, improve, or extend CI/CD for this repository.

This repository is a Jekyll static site for `https://blog.rido.dev`.

## Repo-Specific Context

- Primary site config lives in `_config.yml`.
- Ruby/Jekyll dependencies are in `Gemfile` and `Gemfile.lock`.
- The current deployment automation is `.github/workflows/staging-dev.yml`.
- The current workflow deploys to Azure Static Web Apps on pushes to `dev` and on pull requests targeting `dev`.
- There is no existing `netlify.toml` in the repo.

## Current Pipeline Baseline

Before proposing changes, inspect these files first:

- `.github/workflows/staging-dev.yml`
- `_config.yml`
- `Gemfile`
- `Gemfile.lock`
- `README.md` if deployment steps are documented there

At the time this skill was added, the Azure workflow:

- uses `Azure/static-web-apps-deploy@v1`
- deploys `_site`
- triggers on `push` to `dev`
- triggers on `pull_request` events against `dev`
- closes Azure preview environments when the PR closes

## What To Review

When asked to review CI/CD, check for:

- Build correctness: `bundle exec jekyll build --trace`
- Whether the workflow explicitly installs Ruby and dependencies or relies on action defaults
- Cache opportunities for Bundler dependencies
- Branch strategy alignment between `main`, `dev`, and preview environments
- Safe preview behavior for pull requests
- Secret usage and whether deploy tokens are scoped appropriately
- Whether the pipeline validates content changes before deployment
- Whether a staging URL exists for reviewing posts before production release

## Preferred Recommendation For Staging

If the user wants staging in Netlify to review posts, prefer this recommendation order unless they ask for something else:

1. Netlify Deploy Previews for pull requests
2. A dedicated Netlify branch deploy or separate staging site for `dev`
3. Keep production on the existing platform until Netlify staging is proven

Why this order:

- Deploy Previews fit editorial review well because each PR gets its own URL.
- A `dev` branch deploy gives a stable shared staging URL.
- This minimizes production risk while improving review flow.

## Netlify Guidance

If implementing Netlify support, prefer a minimal configuration:

- Add `netlify.toml` only if it is needed for build settings or redirect/header behavior.
- Use build command: `bundle exec jekyll build --trace`
- Publish directory: `_site`
- Pin a Ruby version in Netlify only if the build fails or the repo already standardizes one elsewhere.

Suggested Netlify setup for this repo:

- Production branch: `main` if production releases are cut from `main`
- Shared staging branch deploy: `dev`
- Deploy previews: enabled for pull requests

If branch ownership is unclear, inspect git history and current workflow assumptions before changing deployment targets.

## Change Strategy

Prefer small, reversible changes:

- First add build validation and preview deployment support
- Then add caching or workflow cleanup
- Only migrate production hosting after preview and staging flows are working

Avoid changing public URLs, post permalinks, or site base configuration unless the task explicitly requires it.

## Validation Steps

After CI/CD changes, verify with:

```bash
bundle exec jekyll build --trace
```

If a GitHub Actions workflow changed, also review:

- trigger conditions
- secret names
- branch filters
- artifact or publish directory paths

If Netlify config was added, confirm that it matches this repo:

- build command points at Jekyll through Bundler
- publish directory is `_site`
- any environment variables are documented or obviously required

## Output Expectations

When using this skill, return:

- the current pipeline behavior
- the main risks or gaps
- the smallest viable improvement plan
- any exact files that should be changed
- whether Netlify should be preview-only, staging-only, or become the primary deploy target

If no code change is needed yet, provide a concrete recommendation with branch and environment mapping for `main`, `dev`, and pull requests.
