#!/bin/sh

export _ASDF_VERSION="v0.14.1"
export _POETRY_VERSION="1.8.3"

_SRC_DIR="$(pwd)"

poetry run jupyter lab stop 8888