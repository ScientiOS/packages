## ADDED Requirements

### Requirement: The CI workflow must check out the installer repository
The CI workflow SHALL check out the `ScientiOS/installer` repository next to the `packages` repository before building custom packages, so that local source dependencies can be resolved.

#### Scenario: Workflow builds the installer package
- **WHEN** the `build-repo.yml` workflow reaches the "Build custom packages" step
- **THEN** it SHALL find the installer source code in the `installer` directory at the same level as `scientios-repo`

### Requirement: The package template must fetch local installer source
The `scientios-install` package template SHALL use a custom fetch block to pull in the `installer` source code from the adjacent cloned directory.

#### Scenario: package is built
- **WHEN** the `xbps-src` builder calls the fetch phase for `scientios-install`
- **THEN** it SHALL copy the contents of `../../../installer` into the build workspace