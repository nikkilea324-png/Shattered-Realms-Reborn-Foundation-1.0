# Engine Version Lock

Shattered Realms: Reborn Foundation 1.0 is locked to **Godot 4.7.2 stable**.

## Why this is locked

The rendering proof and project configuration must be validated against one known engine version before production systems are added.

Do not change the Godot version as part of unrelated feature work.

## Validation rule

A foundation change is accepted only when the project opens and the rendering proof parses successfully under Godot 4.7.2 stable.

## Android rule

Android export automation is a separate gate. It must use the same Godot 4.7.2 stable version and matching export templates.

The current CI workflow intentionally does not export an APK yet. This prevents Android tooling failures from being mixed with game-code or rendering failures.

## Upgrade rule

A Godot version upgrade is its own controlled change:

1. Update this document.
2. Validate the project.
3. Validate the rendering proof.
4. Validate Android export.
5. Perform the device update test.
6. Only then make the new version the foundation baseline.
