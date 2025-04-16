# Realm Paper Base

This repository contains the base files for constructing a paper server for the Realm game.

Our flow is like this:
- Push script in this repository (manual) zips and pushes these files to OCI registry
- `Realm-Paper` (via Jenkins) pulls the zipped file into a docker image, and pushes that image to the docker registry
- `Realm-deployment` is updated by `Realm-paper`, and then ArgoCD pulls and syncs these in the cluster

<b>Important</b>: Configuration of the `server` files should only happen in this repository <b>if the changes are environment-independent</b>. We can instead configure environment specific changes by modifying overlays in the `Realm-deployment` helm chart (which are then merged with these files using Palimpsest).

## `push.sh` script:
Zips and pushes the server directory to the OCI registry with a latest tag.

Make sure to [install the oras CLI tool](https://oras.land/docs/installation).

## Contributing:
Make sure you [install Git LFS](https://git-lfs.com/). This is required for any push to this repository.
