# Shattered Realms: Reborn — Foundation 1.0

A clean Godot foundation for the Shattered Realms strategy game.

## Intent

Build the technical foundation first, then add content.

Primary visual target:
- Stylized dark-fantasy 2.5D
- Low-poly, hand-painted appearance
- Modular terrain and props
- Readable strategic-camera silhouettes
- Rich but controlled lighting
- Layered cliffs, grass, rock, forest, paths, and water
- Godot-ready modular assets

## Foundation rule

The renderer and proof scene are the contract for every future asset. New content should be built to the established camera, scale, lighting, material, and performance rules rather than forcing the renderer to adapt to individual assets.

## Current milestone

**Foundation 1.0 — Rendering Proof**

The first milestone is a procedural proof scene containing:
- ground
- elevation/cliff
- forest vegetation
- rocks
- water
- a simple test unit
- strategic camera
- directional lighting
- environment/fog

No gameplay systems are being added until the rendering foundation is stable.
