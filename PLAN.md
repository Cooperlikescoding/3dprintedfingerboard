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
| TPU | Bambu TPU for AMS (68D), TPU 90A/95A |
| Engineering | PAHT-CF, PC |
| Sheet | 3mm walnut ply, 3mm birch ply, 3mm acrylic, 2mm cork |

---

## 1. Deck: single color PAHT-CF

- **Model:** [Print-in-Place Finger Board Pro (MakerWorld 3030564)](https://makerworld.com/en/models/3030564), deck part only.
- **Shape:** 96 x 34mm, 45mm wheelbase, medium concave (~1.5mm), ~20° kicks.
- **Why PAHT-CF:** the stiffest material on hand gives the best pop, and it holds up to impacts.
- **Dry:** 80°C for 8h in the AMS HT, and print straight from it.
- **Nozzle:** 0.4 hardened.
- **Settings:** Bambu PAHT-CF profile, 0.12mm layers, 4 walls, 100% infill.
- **Plate:** textured PEI or engineering plate with glue stick.
- **Orientation:** grip side up, with tree supports under the kicks (0.2mm top Z distance).
- **Grip:** model a 0.3mm diamond texture into the top surface.
- **Mounting:** match the deck's hole pattern to the Tech Deck trucks and reuse their screws.

## 2. Trucks: dual-axle (pro style)

| Part | Material | Notes |
|---|---|---|
| Hanger | PAHT-CF | 100% infill; print the axles horizontal (along X/Y) |
| Baseplate | PAHT-CF | 100% infill |
| Bushings | TPU 90A | 40% infill for a softer ride; tune infill to adjust stiffness |
| Pivot cup | TPU 95A | |
| Kingpin | printed PAHT-CF pin + friction cap | or reuse a Tech Deck screw |

**Backup plan:** reprint the hanger in PC if PAHT-CF cracks.

**Still needed:** a dual-axle truck model. Candidates are [Magnetic Fingerboard (MyMiniFactory)](https://www.myminifactory.com/object/3d-print-magnetic-fingerboard-75119) and [Printables 690876](https://www.printables.com/model/690876-finger-board-skate-board-print-in-place), or a custom design.

## 3. Wheels: street, no bearings

- **Size:** 7mm diameter, narrow.
- **Core:** black PETG, 100% infill. Ream the bore so it spins freely on the axle.
- **Tire:** **TPU 68D**, 0.6mm thick, printed in the same multi-material job. It is hard, so it rolls fast, wears slowly and grips better than bare PETG.
- **Print:** flat, at 0.08–0.12mm layers so the wheels come out rounder. Use the 0.2 stainless nozzle if the 0.4 can't hold the detail.
- **Spares:** keep the Tech Deck wheels.

## 4. Park (~120 x 60cm, can grow), all printed

### Base
- No base board. Obstacles sit directly on the table.
- **Feet:** cut the 2mm cork into pads with scissors, or print TPU 95A feet. This stops sliding and deadens noise.

### Obstacles
| # | Piece | Build |
|---|---|---|
| 1 | Quarter pipe (~8cm tall, 15cm wide) | PETG body, printed in sections; PC coping. Model: [Modular QP (MW 2390503)](https://makerworld.com/models/2390503) |
| 2 | Funbox: ledge + 3 stairs + handrail | PLA Matte body; **PC ledge top** (slides well; wax it); PC handrail. From the [Euro Gap set (MW 2342170)](https://makerworld.com/models/2342170) |
| 3 | Hubba ledge | **Translucent pink PETG**, so it glows when lit from behind |
| 4 | Flat bar + kinked rail | PC on PETG stands |
| 5 | Manual pad (1cm tall) | PLA Matte body, PC top |
| 6 | Kicker + bank/hip | PLA Matte; TPU 95A lip at the edge |
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
3. Print the dual-axle trucks (PAHT-CF + TPU).
4. Print the funbox, rails and hubba, then the quarter pipe; add cork or TPU feet.
5. Print the display stand.

## Later upgrades (if parts are ever bought)
- 0.6mm maple veneer: laser-cut plies and press them in a printed mold ([MOLD F.O.R.G.E. 34mm](https://makerworld.com/models/2542743)).
- 2x6x3mm bearings for the wheels.
