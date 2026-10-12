# 3D Printed Fingerboard Plan

**Printer:** Bambu Lab H2C (AMS 2 Pro, AMS HT, 40W laser)
**Nozzles:** 0.4 hardened (Vortek + left), 0.6 hardened (Vortek), 0.2 stainless
**Dryers:** AMS 2 Pro, AMS HT, Sunlu dryer
**Rule:** use only materials on hand. Tech Deck screws are reused for mounting.

### Materials on hand
| Type | What |
|---|---|
| PLA | Bambu PLA Basic/Matte, Silk/Glow/Marble, PLA-CF |
| PETG | Bambu PETG (black, translucent pink) |
| TPU | TPU 40D (softer), Bambu TPU for AMS 68D (harder) |
| Engineering | PAHT-CF, PC |
| Sheet | 3mm walnut ply, 3mm birch ply, 3mm acrylic, 2mm cork |

---

## 1–3. Deck, trucks and wheels: custom design

These are custom OpenSCAD models in `models/`, with ready-to-print STLs in `stl/`. See `models/README.md` for per-part settings and assembly.

- **Deck (`deck.stl`):** 96 x 34mm, 45mm wheelbase, 1.5mm concave, 20° kicks, 0.25mm diamond grip, Tech Deck hole pattern. Print in PAHT-CF (dry 80°C for 8h), grip side up, with tree supports under the kicks.
- **Trucks (`truck_*.stl`):** a 34mm truck with a 40° kingpin angle.
  - Baseplate, hanger, kingpin and axle caps are PAHT-CF.
  - Bushings and pivot cup are TPU 40D (the softer one).
  - The kingpin is a printed press-fit pin, because printed M2 threads strip. It's held with a drop of superglue.
  - The deck mounts with the Tech Deck screws.
- **Single-axle:** the axle is built into the hanger and printed horizontally for strength.
- **Wheels (`wheel_core.stl` + `wheel_tire.stl`):** 7 x 4mm street wheels with a PETG core and a TPU 68D tire, printed as one multi-material object.

**Other models (backups):**
- [Grippy Fingerboard (MakerWorld 1237823)](https://makerworld.com/en/models/1237823-grippy-fingerboard-compatible-w-tech-deck-trucks) fits Tech Deck trucks.
- [34mm Classic High Concave (Cults3D)](https://cults3d.com/en/3d-model/game/fingerboard-deck-34mm-classic-high-concave)
- [50mm hybrid trucks (MakerWorld 2184532)](https://makerworld.com/en/models/2184532-50mm-fingerboard-trucks) use parts from Tech Deck trucks.

## 4. Park (~120 x 60cm, can grow), all printed

### Base
- No base board. Obstacles sit directly on the table.
- **Feet:** cut the 2mm cork into pads with scissors, or print TPU 40D feet. This stops sliding and deadens noise.

### Obstacles
| # | Piece | Build |
|---|---|---|
| 1 | Quarter pipe (~8cm tall, 15cm wide) | PETG body, printed in sections; PC coping. Model: [Modular QP (MW 2390503)](https://makerworld.com/models/2390503) |
| 2 | Funbox: ledge + 3 stairs + handrail | PLA Matte body; **PC ledge top** (slides well; wax it); PC handrail. From the [Euro Gap set (MW 2342170)](https://makerworld.com/models/2342170) |
| 3 | Hubba ledge | **Translucent pink PETG**, so it glows when lit from behind |
| 4 | Flat bar + kinked rail | PC on PETG stands |
| 5 | Manual pad (1cm tall) | PLA Matte body, PC top |
| 6 | Kicker + bank/hip | PLA Matte; TPU 40D lip at the edge |
| 7 | Slappy curb | [Slappy (MW 2031463)](https://makerworld.com/models/2031463) in black PETG |

**Rough layout:** quarter pipe at the left end, funbox and manual pad in the center, rails and hubba on the right, kicker/bank next to the funbox.

## 5. Display stand
- Print it in Silk or Marble PLA.
- **Optional (the only laser job):** one walnut ply stand with your name engraved.

## 6. Spare sheet stock
Acrylic, birch ply and walnut aren't needed. Later uses if wanted:
- acrylic ledge tops
- a single acrylic sheet as a smooth base

## 7. Build order
1. Dry the PAHT-CF, then print the deck and test it with the Tech Deck trucks and wheels.
2. Print the street wheels (PETG + TPU 68D).
3. Print the single-axle trucks (PAHT-CF + TPU).
4. Print the funbox, rails and hubba, then the quarter pipe; add cork or TPU feet.
5. Print the display stand.

## Later upgrades (if parts are ever bought)
- 0.6mm maple veneer: laser-cut plies and press them in a printed mold ([MOLD F.O.R.G.E. 34mm](https://makerworld.com/models/2542743)).
- 2x6x3mm bearings for the wheels.
