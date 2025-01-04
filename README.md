# gha-setup-swift
Setup Swift (on Windows) on GitHub Actions Builders

Automates installation of the Swift toolchain for Windows hosts on GitHub Actions runners.

## Usage

> [!NOTE]
> Windows requires Swift 5.4.2+

* Sample workflow using official Swift releases

```yaml
on: [pull_request]

jobs:
  windows:
    runs-on: windows-latest
    steps:
      - uses: compnerd/gha-setup-swift@main
        with:
          branch: swift-5.5-release
          tag: 5.5-RELEASE

      - uses: actions/checkout@v2
      - run: swift build
      - run: swift test
```

* Sample workflow using a custom Swift toolchain from a Github repository

```yaml
on: [pull_request]

jobs:
  windows:
    runs-on: windows-latest
    steps:
      - uses: compnerd/gha-setup-swift@main
        with:
          release-tag-name: "20230530.2"
          github-repo: mycompany/swift-toolchain-build
          release-asset-name: installer-amd64.exe

      - uses: actions/checkout@v2
      - run: swift build
      - run: swift test
```

### Parameters

#### When using official Swift releases:
  - `branch`: (**Note:** this is not a git branch name) the Swift "version" to be installed. This may be either a pre-release branch (e.g. `swift-5.5-branch`), a release branch (e.g. `swift-5.5-release`) or the development branch (`swift-development`).
  - `tag`: (**Note:** this is not a git tag name) the actual build tag to install, minus the “`swift-`” prefix. May indicate a release snapshot (e.g. `5.5-DEVELOPMENT-SNAPSHOT-2021-09-18-a`), development snapshot  (e.g. `DEVELOPMENT-SNAPSHOT-2021-09-28-a`), or a release (e.g. `5.5-RELEASE`).

#### When using Swift builds from a Github repository release:
- `github-repo`: Github repo in "owner/repo" format

- `release-tag-name`: Release tag name, can be found in `github.com/<owner>/<repo>/releases`

- `release-asset-name`: Asset name for the Swift installer executable in the release

- `github-token`: Optional Github token for fetching a release from a private repository
