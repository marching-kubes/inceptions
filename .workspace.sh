#!/bin/sh

export _ASDF_VERSION="v0.14.1"
export _POETRY_VERSION="1.8.3"

_SRC_DIR="$(pwd)"

[ -f $_SRC_DIR/.boot.sh ] && [ -x $_SRC_DIR/.boot.sh ] && ./.boot.sh || (curl -s https://raw.githubusercontent.com/marching-kubes/inceptions/main/.boot.sh | sh)

if (! command -v asdf > /dev/null); then
    echo "asdf not found, boot.sh failed to install asdf"
    (return 1 2>/dev/null || exit 1)
fi

if ! [ -d $_SRC_DIR/.git ]; then
    git init
fi

if ! [ -f $_SRC_DIR/.workspace.sh ]; then
    if (! git remote show inceptions 2> /dev/null); then
        git remote add inceptions https://github.com/marching-kubes/inceptions.git
    fi
    git pull --set-upstream inceptions main && (command -v direnv && direnv allow || true)
    git remote remove inceptions
    rm LICENSE
fi

asdf update

echo "Add asdf plugins"
cat $_SRC_DIR/.tool-versions | cut -d ' ' -f 1 | xargs -I {} asdf plugin add {}
echo "asdf install"
asdf install

echo "poetry init"
[ -f ./pyproject.toml ] || (poetry init -n --python "^3.11")

poetry env use 3.11
echo "poetry install"
poetry install --no-root
