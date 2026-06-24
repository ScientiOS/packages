## 1. Package Updates Configuration

- [x] 1.1 Create `srcpkgs/slack-desktop/update` script that extracts the latest
      version from Slack's release notes.
- [x] 1.2 Create `srcpkgs/zen-browser/update` script that extracts the latest
      tag from the GitHub releases API.
- [x] 1.3 Make the `update` scripts executable (`chmod +x`).

## 2. Core Implementation

- [x] 2.1 Create the `scripts/bump-pkg.sh` file and make it executable.
- [x] 2.2 Implement the package discovery logic in `scripts/bump-pkg.sh` to read
      `template` variables.
- [x] 2.3 Implement the version comparison logic using `sort -V`.
- [x] 2.4 Implement the template patching logic via `sed` to update `version=`
      and `revision=`.
- [x] 2.5 Implement the distfile download and SHA-256 calculation logic.
- [x] 2.6 Implement the final checksum replacement logic in the template.

## 3. GitHub Actions Workflow

- [x] 3.1 Create `.github/workflows/auto-bump.yml`.
- [x] 3.2 Add the `discover` job to find packages with `update` scripts and
      output them as JSON.
- [x] 3.3 Add the `bump` job using a `matrix` strategy targeting the JSON
      output.
- [x] 3.4 In the `bump` job, add the step to run `./scripts/bump-pkg.sh`.
- [x] 3.5 In the `bump` job, add the step using
      `peter-evans/create-pull-request@v6` to create the PR.
