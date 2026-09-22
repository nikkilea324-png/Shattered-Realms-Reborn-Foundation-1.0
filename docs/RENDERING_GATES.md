# Rendering Gates

Every major change passes these gates in order.

## Gate 1 — Project

- Godot opens the project.
- Main scene loads.
- No parser errors.
- No missing resources.

## Gate 2 — Camera

- Strategic perspective is consistent.
- Terrain height is readable.
- Unit silhouettes remain readable.

## Gate 3 — Lighting

- Directional shadows are readable.
- Ambient fill prevents crushed dark areas.
- Materials remain distinguishable.

## Gate 4 — Terrain

- Ground modules align.
- Cliff modules stack.
- Shoreline modules do not expose obvious gaps.

## Gate 5 — Content

- Trees, rocks and props follow the established visual language.
- New assets do not require special rendering exceptions.

## Gate 6 — Device

- Android export succeeds.
- One-click deploy works.
- Existing development installation updates in place.
- Game launches into the proof scene.

No major gameplay expansion should bypass these gates.
