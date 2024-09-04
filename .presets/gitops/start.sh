#!/bin/sh

. $_SRC_DIR/.presets/git/start.sh

. $_SRC_DIR/.presets/gitops/git-token.sh jx


export GITOPS_GITEA_REPO=http://${GITEA_ADMIN_USER}:${GITEA_ADMIN_PASSWORD}@${GIT_HOST}/${GITEA_ADMIN_USER}/jx-gitops.git
_GITOPS_TMP_CLONE=`mktemp -d`

pushd $_GITOPS_TMP_CLONE

git clone $GITOPS_REPO_URL gitops-repo
cd gitops-repo

export DOMAIN="$(minikube ip).nip.io"
jx gitops requirements edit --domain $DOMAIN
jx gitops repository resolve http://@${GIT_HOST}/${GITEA_ADMIN_USER}/jx-gitops.git
git add *
git commit -a -m "fix: configurations for local minikube"
git remote add gitea $GITOPS_GITEA_REPO || echo "Repo might already exists"
git push -u gitea main

popd

rm -Rf $_GITOPS_TMP_CLONE

export GIT_REPO=http://${GITEA_ADMIN_USER}:${GITEA_ADMIN_PASSWORD}@${GIT_HOST}/${GITEA_ADMIN_USER}/${MLOPS_REPO}.git

git remote add gitea ${GIT_REPO} || echo "Repo might already exists"

git push -u gitea main

jx ctx minikube

minikube service list

jx admin operator --username ${GITEA_ADMIN_USER} --token $GIT_TOKEN --url=http://@${GIT_HOST}/${GITEA_ADMIN_USER}/jx-gitops.git --setup 'git config --global http.sslverify false'


