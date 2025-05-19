# Realm Paper Base

This repository contains the base files for constructing a paper server for the Realm game.

Our flow is like this:
- Push script in this repository (manual) copies the `server` files to a PV mounted at `/mnt/realm-paper-base`
- This PV is mounted by all images running the `Realm-Paper` image, and is copied to their own file system by the entrypoint.

<b>Important</b>: Configuration of the `server` files should only happen in this repository <b>if the changes are environment-independent</b>. We can instead configure environment specific changes by modifying overlays in the `Realm-deployment` helm chart (which are then merged with these files using Palimpsest).

## Contributing:
Make sure you [install Git LFS](https://git-lfs.com/). This is required for any push to this repository.
