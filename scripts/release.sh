#!/bin/bash
releases=$(jq -r 'keys[]' "$1")
for release in $releases; do
    echo "Creating release for $release"
    # Get the release id
    release_id=$(gh api \
        -H "Accept: application/vnd.github+json" \
        "/repos/$GITHUB_REPOSITORY_OWNER/$release/releases/tags/$GITHUB_REF_NAME" | jq .id)
    # Update the release to be a full release
    gh api \
        --method PATCH \
        -H "Accept: application/vnd.github+json" \
        "/repos/$GITHUB_REPOSITORY_OWNER/$release/releases/$release_id" \
        -F prerelease=false \
        --latest=true
done
