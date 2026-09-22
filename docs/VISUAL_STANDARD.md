# Shattered Realms: Reborn — Visual Standard

## Reference

The project uses the supplied **Shattered Realms Modular 2.5D Forest Terrain Pack** image as the visual reference.

The reference establishes the target language, not a requirement to reproduce one giant scene.

## Art direction

- Stylized dark-fantasy
- Low-poly forms
- Hand-painted/stylized surface treatment
- Chunky readable silhouettes
- Strong separation between grass, soil, rock, wood, and water
- Dense environmental detail at strategic-camera scale
- Deliberately exaggerated shapes rather than photorealism

## Terrain

Terrain is modular. Pieces should be reusable and combinable.

Required families:
- flat ground
- forest floor
- paths
- water
- shoreline
- cliff faces
- cliff tops
- elevation transitions

Cliffs should visually read as layered stone with vegetation on top.

## Vegetation

Trees use multiple silhouettes and sizes. Forests should feel dense without creating a wall of identical objects.

Minimum future tree families:
- tall conifer
- medium conifer
- broadleaf
- dead tree
- small shrub

## Materials

Prefer a small, consistent material library over unique materials on every object.

Future PBR texture sets may include:
- albedo
- normal
- roughness
- ambient occlusion

Textures must preserve the painted/stylized appearance of the reference.

## Camera

The strategic camera should maintain:
- readable terrain height
- readable unit silhouettes
- enough surrounding context for tactical movement
- consistent scale between terrain and units

## Lighting

Lighting should provide:
- readable form
- soft environmental fill
- directional shadows
- enough contrast to separate terrain layers

Avoid highly realistic cinematic lighting that makes gameplay readability worse.

## Rendering contract

Before adding major gameplay systems, the project must keep a stable proof scene demonstrating the intended:
camera + terrain + elevation + vegetation + props + water + unit + lighting.

Every future asset should be validated against that contract.
