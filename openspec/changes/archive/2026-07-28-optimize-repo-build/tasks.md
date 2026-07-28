## 1. Preparation

- [x] 1.1 Add `wget` tool to the container preparation step in `build-repo.yml`
      if not already present.

## 2. Implement Smart Build Loop

- [x] 2.1 Before the build loop, add a step to download the existing repository
      from `https://scientios.github.io/packages/` into
      `void-packages/hostdir/binpkgs` using `wget`, allowing failure gracefully
      if the remote doesn't exist yet (404).
- [x] 2.2 Register the downloaded packages with `xbps-rindex -a` so `xbps-query`
      can read them, or just use file existence checks.
- [x] 2.3 Refactor the build loop to parse the `version` and `revision` from
      `srcpkgs/<pkg>/template`.
- [x] 2.4 Formulate the target `.xbps` filename based on the package name,
      version, and revision, and check if it exists in the downloaded
      repository.
- [x] 2.5 Conditionally execute
      `sudo -Eu builder ./xbps-src -A x86_64 pkg "$pkgname"` only if the target
      `.xbps` file is missing.

## 3. Post-Build and Deployment

- [x] 3.1 Verify that the repo signing step processes all `.xbps` files in
      `void-packages/hostdir/binpkgs` (including downloaded and newly built
      ones).
- [x] 3.2 Ensure `xbps-rindex` metadata generation updates the index correctly
      with all packages.
- [x] 3.3 Verify the `upload-pages-artifact` step includes the merged `binpkgs`
      directory.
