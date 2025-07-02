#!/bin/bash
set -euo pipefail

REGISTRY_NAME="$1"
REPO_NAME="$2"

az acr repository show-manifests \
  --name "$REGISTRY_NAME" \
  --repository "$REPO_NAME" \
  --query "[?tags==null || length(tags)==\`0\`].digest" \
  --output tsv | while read -r digest; do
    echo "Deleting untagged manifest: sha256:$digest"
    az acr repository delete \
      --name "$REGISTRY_NAME" \
      --image "$REPO_NAME@$digest" \
      --yes
done
