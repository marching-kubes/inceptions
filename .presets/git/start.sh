#!/bin/sh

export IP="$(minikube ip)"

export GIT_SCHEME="http"
export GIT_HOST="gitea.${IP}.nip.io"
export GIT_URL="${GIT_SCHEME}://${GIT_HOST}"
export GIT_KIND="gitea"

export INTERNAL_GIT_HOST="gitea.gitea"
export INTERNAL_GIT_URL="http://${INTERNAL_GIT_HOST}"

export GITEA_ADMIN_USER="devmaster"
export GITEA_ADMIN_PASSWORD="10admin100&^"

arkade install gitea \
    --namespace gitea \
    -p "${GITEA_ADMIN_PASSWORD}" \
    -u "${GITEA_ADMIN_USER}" \
    --persistence \
    --set "ingress.hosts[0].host=${GIT_HOST}" \
    --set ingress.enabled=true \
    --set gitea.config.webhook.ALLOWED_HOST_LIST="*" \
    --set gitea.config.repository.ENABLE_PUSH_CREATE_USER=true \
    --set gitea.config.repository.ENABLE_PUSH_CREATE_ORG=true \
    --wait

