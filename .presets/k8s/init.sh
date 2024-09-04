#!/bin/sh

asdf plugin add minikube
_MINIK8S_LATEST=`asdf list all minikube | grep -v -E 'alpha|beta' | tail -n 2 | head -n 1 | sed -Ee 's/\*//g'`
asdf install minikube latest
asdf set minikube $_MINIK8S_LATEST

asdf plugin add kubectl
_K8SCTL_LATEST=`asdf list all kubectl | grep -v -E 'alpha|beta' | tail -n 2 | head -n 1 | sed -Ee 's/\*//g'`
asdf install kubectl latest
asdf set kubectl $_K8SCTL_LATEST

asdf plugin add jx
_JX_LATEST=`asdf list all jx | grep -v -E 'alpha|beta' | tail -n 2 | head -n 1 | sed -Ee 's/\*//g'`
asdf install jx latest
asdf set jx $_JX_LATEST

if ! command -v arkade &> /dev/null; then
    mkdir .temp
    pushd .temp
    curl -sLS https://get.arkade.dev | sh
    mkdir -p ~/.local/bin
    cp arkade ~/.local/bin
    popd
else
    arkade update
fi
. <(arkade completion zsh) 2&>/dev/null

