#!/usr/bin/env bash

set -euo pipefail

config_file="_config.yml"
temp_config=""

cleanup() {
  if [ -n "$temp_config" ] && [ -f "$temp_config" ]; then
    rm -f "$temp_config"
  fi
}

trap cleanup EXIT

# Netlify sets deploy-specific URLs for previews and branch deploys. Override
# Jekyll's production site.url so canonical and share links match the preview.
if [ "${CONTEXT:-production}" != "production" ]; then
  preview_url="${DEPLOY_PRIME_URL:-${URL:-}}"

  if [ -n "$preview_url" ]; then
    temp_config="$(mktemp)"
    printf 'url: "%s"\n' "$preview_url" > "$temp_config"
    config_file="${config_file},${temp_config}"
  fi
fi

bundle exec jekyll build --trace --config "$config_file"
