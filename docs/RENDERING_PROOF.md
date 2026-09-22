# Rendering Proof

The rendering proof is the first visual gate for Shattered Realms: Reborn.

## What this scene locks

- Orthographic strategic camera for consistent 2.5D scale.
- Warm directional sunlight with readable shadows.
- Cool ambient/fill light so shaded forest areas remain readable.
- Dark-fantasy forest palette.
- Modular hex-style terrain plates.
- Ground path readability.
- Three-level cliff/elevation transition.
- Shoreline and waterfall test.
- Conifer and broadleaf vegetation silhouettes.
- Rocks, fallen log, and boundary posts.
- A readable test unit with a base and banner.

## Production rule

These are procedural stand-ins. They are not the final art library.

A production terrain, tree, prop, water, or unit asset passes only when it can replace the corresponding proof element without requiring a special rendering exception.

## Validation order

1. Open the project in the target Godot version.
2. Run the RenderingProof scene.
3. Confirm the camera keeps terrain and the test unit readable at the same strategic scale.
4. Confirm the cliff reads as three distinct elevations.
5. Confirm water, shoreline, and waterfall remain visually separated from land.
6. Confirm tree silhouettes remain readable against the dark background.
7. Confirm shadows ground the trees, cliffs, props, and unit.
8. Repeat the proof on the target Android device before production asset work.

## Renderer note

The foundation currently uses Godot's Compatibility renderer to maximize hardware coverage while the visual contract is established. Renderer changes are a deliberate engineering decision and should be validated against this proof scene rather than made ad hoc.
