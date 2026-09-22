# Shattered Realms: Reborn — Development Pipeline

## Pipeline order

1. Design contract
2. Rendering proof
3. Reusable terrain/material/asset systems
4. Gameplay systems
5. Validation on desktop and Android

The rendering proof is the gate for production content.

## Android development loop

Edit -> Save -> One-click deploy -> Export -> Install/update -> Run -> Test

The Android export preset is intentionally marked Runnable. Godot supports one-click deployment when a runnable Android preset and configured device are available.

## Update-in-place rule

The development Android identity is fixed:

- Package ID: com.shatteredrealms.reborn
- Version name: 0.1.0
- Initial version code: 1
- Architecture: ARM64

Do not change the package ID during normal development.

Do not enable Godot's clear-previous-install option.

The existing development APK should be updated by the new build when the package identity and signing identity match.

## Signing rule

Keep one development signing identity on the development machine. A different signing key can cause Android to require removal of the old installation.

For release builds, use a dedicated release keystore and keep its passwords and private signing material outside Git.

## Versioning

Increase Android version/code for every installable build.

Example:

0.1.0 = code 1
0.1.1 = code 2
0.2.0 = code 3

## Branch strategy

main is the stable foundation branch.

Suggested feature branches:

- feature/rendering
- feature/terrain
- feature/units
- feature/world-map
- feature/combat
- feature/ui

## Asset pipeline

Reference -> asset creation -> Godot import -> material setup -> proof-scene validation -> production asset

Do not build large scenes from unvalidated assets.

## Foundation gates

- Clean Godot project
- Rendering proof
- Visual standard
- Android runnable preset
- Stable package identity
- Device deployment verification
- Reference-style rendering verification
- First production terrain module
