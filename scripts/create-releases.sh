#!/bin/bash
releases=$(jq -r 'keys[]' "$1")
for release in $releases; do
    # Check if release exists
    release_id=$(gh api \
        -H "Accept: application/vnd.github+json" \
        "/repos/$GITHUB_REPOSITORY_OWNER/$release/releases/tags/$GITHUB_REF_NAME" | jq .id)
    if [ "$release_id" == "null" ]; then
        gitref=$(jq -r ."$release" "$1")
        gh release create "$GITHUB_REF_NAME" \
            --notes-file "$2" \
            --target "$gitref" \
            --prerelease \
            --repo "$GITHUB_REPOSITORY_OWNER/$release"
    fi
done
