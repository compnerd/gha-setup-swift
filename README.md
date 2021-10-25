# gha-setup-swift
Setup Swift (on Windows) on GitHub Actions Builders

Automates installation of the Swift toolchain for Windows hosts on GitHub Actions runners.

## Usage

> **NOTE:** Only Swift 5.4.2+ is supported

Sample Workflow

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

### Parameters

- `branch`: the Swift "version" to be installed. This may be either a pre-release branch (e.g. `swift-5.5-branch`), a release branch (e.g. `swift-5.5-release`) or the development branch (`swift-development`).
- `tag`: the actual build tag to install. This may be either a release snapshot tag (e.g. `5.5-DEVELOPMENT-SNAPSHOT-2021-09-18-a`), development snapshot tag  (e.g. `DEVELOPMENT-SNAPSHOT-2021-09-28-a`), or a release tag (e.g. `5.5-RELEASE`).
