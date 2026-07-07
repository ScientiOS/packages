## 1. Update CI Workflow

- [x] 1.1 Modify `.github/workflows/build-repo.yml` in the `packages` repo to checkout the `ScientiOS/installer` repo using `actions/checkout@v4`.
- [x] 1.2 Ensure the checkout step clones into an `installer` directory alongside the `scientios-repo` directory.
- [x] 1.3 Add comments in the workflow explaining why the installer is checked out.

## 2. Update Package Template

- [x] 2.1 Edit `srcpkgs/scientios-install/template` in the `packages` repo to uncomment the `do_fetch()` block.
- [x] 2.2 Verify that the `do_fetch()` path (`../../../installer`) correctly matches the expected directory structure created by the CI workflow.