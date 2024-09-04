#!/bin/sh

if ! [ -d ~/.asdf ]; then
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
fi

if ! [ -f ~/.asdf/bin/asdf ]; then
	echo "remoave and replace asdf"
	rm -Rf ~/.asdf
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
fi




