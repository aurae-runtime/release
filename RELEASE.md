# Releases
Releases will be created in this repository for all official builds of `aurae` and associated projects.

## Versioning
Stable versions will follow a `vX.Y.Z` format. Versions will be consistent across everything being released.

- `X`: A major version - This represents a significant change in the project. It can include breaking changes and new features.
- `Y`: Minor version - This represents new features and improvements to the project. It can also include non-breaking changes.
- `Z`: Patch version - This represents bug fixes and other small changes to the project.

Code that has not reached stability will have an additional segment on the version.

- `alpha` - Alpha releases will be built from the `main` branch of each project when the release is created. They are intended for testing and development purposes.

- `beta` - Beta releases will be built from the `beta` branch of each project when the release is created. They can be used as a staging ground for releases and intended for testing and feedback from the community.
## Cutting a release
- A PR to the `release` (this one) repository is prepped with any appropriate changes to the release json `release/RELEASETYPE.json` if needed.
    - Add any projects to be included in the upcoming release to this document.
- Create a new pre-release from the main branch of this project. 
    - The new version is chosen at this point.
- When this pre-release is created in the `release` project, it will kick off a build in each project listed in the `release.json`, at the branch or commit hash defined in that document.
    - Each project we want to build will catch this event (using `ae` as an example here) .
    - `Ae` will create a new github pre-release in its own project. It will share the tag sent from the `release` project. Changelogs will be generated in the `ae` project from commit messages.
    - The `ae` pre-release will trigger building the artifacts required for the release in `ae`.
    - The `ae` project will load the version from the tag `release` project tag. It will then inspect the file in the `release` repo that best maps back to the release type.
        - `v.0.2.1` would use the `stable` json file
        - `v.0.2.1-beta` would use the `beta` file
        - `v.0.2.1-alpha` would use the `alpha` file
- Once all of the projects have completed their artifact builds, and the maintainers are happy with the builds, the release in this repository is "released".
    - Maintainers can change notes on any of the pre-releases
    - Projects then use this as a trigger to set their own releases as "released". 
    - Done


### Version JSON
These documents describe the release. It includes each binary being released. The name here would map to the repository under the `aurae-runtime` Github organization. Any architecture being built is included here too.



```json
{
    "aurae":{
        "x86_64-unknown-linux": "24aeca4"
    },
    "ae":{        
        # This is the git tag or branch to use
        "x86_64-unknown-linux": "a4a3ra4" 
    }
}
```