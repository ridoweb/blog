# AGENTS.md

Guidance for AI coding agents working in this repository.

## Project overview

- This repository contains the source for **Rido Blog** at <https://blog.rido.dev>.
- It is a Jekyll static site intended for GitHub Pages / Azure Static Web Apps.
- The theme is based on Forever Jekyll.

## Repository layout

- `_config.yml` — main Jekyll site configuration, navigation, plugins, Sass settings, analytics.
- `_posts/` — blog posts. Use Jekyll post filenames: `YYYY-MM-DD-title.md`.
- `_layouts/` — Jekyll page and post layouts.
- `_includes/` — reusable Liquid partials.
- `_sass/` — Sass partials imported by `style.scss`.
- `assets/` — images, search data, icons, and other static assets.
- Root markdown/html files (`index.html`, `about.md`, `projects.md`, `archive.md`, `search.md`, `404.md`, `categories.html`) define top-level site pages.
- `.github/workflows/staging-dev.yml` — Azure Static Web Apps deployment workflow for the `dev` branch.

## Local development

This is a Ruby/Jekyll project. Use Bundler so gem versions come from `Gemfile.lock`.

```bash
bundle install
bundle exec jekyll serve --trace
```

There is also a convenience script:

```bash
./run.sh
```

The generated site is written to `_site/` and should not be committed.

## Validation before committing

Run a local build after content, layout, Sass, or config changes:

```bash
bundle exec jekyll build --trace
```

For local preview, run:

```bash
bundle exec jekyll serve --trace
```

## Content guidelines

- New posts belong in `_posts/` and must use the `YYYY-MM-DD-title.md` filename format.
- Include valid YAML front matter for posts and pages.
- Preserve existing excerpt behavior: `_config.yml` sets `excerpt_separator: <!--more-->`.
- Keep permalinks compatible with the existing `permalink: pretty` setting.
- Store images and other media under `assets/` and reference them with site-relative paths.
- Avoid committing generated files such as `_site/`, `.jekyll-cache/`, or `.sass-cache/`.

## Style and implementation notes

- Prefer small, focused changes that match the existing Jekyll/Liquid/Sass style.
- Reuse existing layouts and includes instead of duplicating markup.
- Keep Sass partials in `_sass/` and import them from `style.scss` when needed.
- Do not rename public URLs, posts, or assets unless the task explicitly requires it.
- Be careful when editing `_config.yml`; configuration changes can affect the entire site and deployment.

## Deployment notes

- The existing GitHub Actions workflow deploys from the `dev` branch using Azure Static Web Apps.
- Before changing workflow or deployment settings, inspect `.github/workflows/staging-dev.yml` and keep secret names intact unless instructed otherwise.
