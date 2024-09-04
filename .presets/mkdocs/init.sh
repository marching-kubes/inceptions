#!/bin/sh

poetry add --dev mkdocs-material pymdown-extensions && poetry run mkdocs new .
poetry install --no-root --with dev
