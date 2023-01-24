# Releases

Releases will be created in this repository for all official builds of `aurae` and associated projects.

## Versioning

### Stable Release

Stable versions will follow a `vX.Y.Z` format. Versions will be consistent across everything being released. [SemVer](https://doc.rust-lang.org/cargo/reference/resolver.html?highlight=alpha#semver-compatibility) versioning is used.

-   `X`: A major version - This represents a significant change in the project. It can include breaking changes and new features.
-   `Y`: Minor version - This represents new features and improvements to the project. It can also include non-breaking changes.
-   `Z`: Patch version - This represents bug fixes and other small changes to the project.

### Development Releases

Code that has not reached stability will be versioned with an additional segment to indicate it is not release. Rust will sort [lexicographically](https://doc.rust-lang.org/cargo/reference/resolver.html?highlight=alpha#pre-releases) for development releases.

-   `aa.X` - **Experimental** releases. These are intended for development purposes. There is no compatibility guarantee with these releases.

-   `alpha.X` - **Alpha** releases will be built from the `HEAD` of each project. They are intended for testing and development purposes. An `alpha.1` will indicate it is the first alpha release of this new version. As additional are built the digit after `alpha` will increment.

-   `beta.X` - **Beta** releases will be built from the `commits` referenced in the release.yaml file. They can be used as a staging ground for release and are intended for testing and feedback from the community.

## Release schedule

| Release      | Schedule  |
| ------------ | --------- |
| experimental | as needed |
| alpha        | as needed |
| beta         | as needed |

## Cutting a versioned release

-   A PR to the `release` (this one) repository is prepped with any appropriate changes to the release json `release.json` if needed.
    -   Add any projects to be included in the upcoming release to this document.
-   Create a new pre-release from the main branch of this project. Please copy and paste the contents of `RELEASE_TEMPLATE.md` into this release, and use that as your starting point.
    -   The new version is chosen at this point.
-   When this pre-release is created in the `release` project, it will kick off a build in each project listed in the `release.json`, at the branch or commit hash defined in that document.
    -   Each project we want to build will catch this event (using `ae` as an example here) .
    -   `Ae` will create a new github pre-release in its own project. It will share the tag sent from the `release` project. The `RELEASE_TEMPLATE.md` will be used to generate a template in the `ae` release.
    -   The `ae` pre-release will trigger building the artifacts required for the release in `ae`.
    -   The `ae` project will load the version from the tag `release` project tag. It will then inspect the `release.json` file to build the correct commit references.
-   Once all of the projects have completed their artifact builds, and the maintainers are happy with the builds, the release in this repository is "released".
    -   Maintainers can change notes on any of the pre-releases
    -   This will set all of the subprojects in the `release.json` file as "released"

```mermaid
graph TD
    ReleaseCoordinater-PreRelease([Create the main pre-release in this project])-->Aurae-PreRelease;
    ReleaseCoordinater-PreRelease-->Ae-PreRelease;
    Aurae-PreRelease[Aurae pre-release made]-->Auraed-Build;
    Ae-PreRelease[Ae pre-release made]-->Ae-Build;
    Ae-Build[Ae build triggered]-->ReleaseCoordinater-Notify
    Auraed-Build[Aure builds triggered]-->ReleaseCoordinater-Notify;
    ReleaseCoordinater-Notify[Update main pre-release changelog]-->ReleaseCoordinater-Release;
    ReleaseCoordinater-Release(Maintainer releases in this project)-->ReleaseCoordinate-Live[Main release made live]
    ReleaseCoordinate-Live-->Aurae-Live[Aurae release made live]
    ReleaseCoordinate-Live-->Ae-Live[Ae release made live]
```

### Troubleshooting

#### A subproject GHA artifact release fails

If the sub project (`aurae` for example) artifact GHA run fails, it will leave a pre-release that has a tag pointed to the broken version. If a new git push to `aurae` is required to fix the GHA run, you will need to:

1. Get `aurae` to a working state
2. Delete the tag associated with the wrong version in the `aurae` project
3. Delete the pre-release associated with the wrong version in the `aurae` project.
4. Re-run the `030-ubuntu-latest-make-create-releases` job in the `release` project to re-setup any missing sub-project pre-releases. This will use the correct git sha for the tag and release then.

### Version JSON

This document describes the release. It includes each binary being released. The name here would map to the repository under the `aurae-runtime` Github organization.

```json
{
    "aurae": "main",
    "auraescript": "main",
    "aer": "main",
    "ae": "main"
}
```
