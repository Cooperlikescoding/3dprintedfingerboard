# Fingerboard models (OpenSCAD)

All dimensions live in `params.scad`. Edit them there, then re-export:

```sh
openscad -o stl/deck.stl models/deck.scad
for p in baseplate hanger kingpin bushing pivot_cup axle_cap; do
  openscad -D "part=\"$p\"" -o stl/truck_$p.stl models/truck.scad; done
openscad -o stl/wheel.stl models/wheel.scad
```

The deck takes about 90s to export because of the grip texture. Set `grip = false` for quick tests.

## Parts per board

Four filaments: PAHT-CF, TPU 68D, TPU 40D and PETG (PETG for the park only).


| STL | Qty | Material | Nozzle | Notes |
|---|---|---|---|---|
| `deck.stl` | 1 | PAHT-CF | 0.4 hardened | 0.12mm layers, 4 walls, 100% infill, grip side up, tree supports under the kicks |
| `truck_baseplate.stl` | 2 | PAHT-CF | 0.4 hardened | Mounting face down, 100% infill, 0.08–0.12mm layers |
| `truck_hanger.stl` | 2 | PAHT-CF (PC as backup) | 0.4 hardened | Print as exported with tree supports. The axles lie horizontal, which keeps them strong. 100% infill |
| `truck_kingpin.stl` | 2 | PAHT-CF | 0.4 hardened | Lies on its flat side, so the layers run along the pin |
| `truck_bushing.stl` | 4 | TPU 40D | 0.4 | 30–60% infill: 40D is fairly firm, so lower infill makes the bushings softer |
| `truck_pivot_cup.stl` | 2 | TPU 40D | 0.4 | Press it into the baseplate's pivot hole (optional) |
| `truck_axle_cap.stl` | 4 | PAHT-CF | 0.2 stainless | Press onto the axle tips to hold the wheels on. Add a drop of superglue if they slip off |
| `wheel.stl` | 4 | TPU 68D | 0.4 | One piece, flat on the bed, 0.08–0.12mm layers, 100% infill |

## Assembly

1. Press the kingpin pin up through the bottom bushing, the hanger and the top bushing into the baseplate's angled hole. It's a press fit, so add a drop of superglue to make it permanent. To adjust how tight the truck turns, change `bushing_h` or the bushing infill.
2. Fit the hanger's pivot nub into the baseplate's pivot hole, with the TPU pivot cup in the hole if you're using one.
3. Slide the wheels onto the axles with the hub facing the hanger, then press the axle caps onto the tips.
4. Mount each truck with the pivot facing the nearest end of the deck, so the kingpins face each other. Use the Tech Deck screws: they thread straight into the baseplate's 1.4mm pilot holes.

## Before printing a full set
- Print one `wheel` and one `axle_cap` first, then adjust `spin_fit` and `press_fit` in `params.scad` until the wheel spins freely and the cap holds.
- Measure your Tech Deck truck's hole spacing and screw size, then set `hole_dx`, `hole_dy`, `deck_hole_d` and `plate_hole_d` to match.
- This truck is a first design and hasn't been printed yet, so expect to tune it.

Previews are in `../previews/`.

# Halloween begleri (`halloween_begleri.scad`)

Print everything in glow PLA with a **hardened nozzle**, because glow filament is abrasive. Use 0.12mm layers.

| STL | Qty | Notes |
|---|---|---|
| `begleri_core.stl` | 2 | 19mm weighted core for a 4-pass monkey's fist. Set `nut_af` and `nut_t` to match your nut (default is M6). Add a **pause at the Z height printed when you export the file** (11.15mm for the default M6 settings), drop in the nut, then resume. Use 100% infill. |
| `begleri_skull.stl` | 1 | Slider bead with a 4.6mm bore for 550 cord. Print with the face up and tree supports in the bore. |
| `begleri_pumpkin.stl` | 1 | Slider bead, set up the same way as the skull. |

To assemble, tie a monkey's fist around each core and thread the skull and pumpkin onto the cord between them. Charge the glow PLA under a light for a few minutes before using it in the dark.

# Pumpkin begleri end bead (`pumpkin_end_bead.scad`)

A weighted jack-o'-lantern end bead for 550 cord. It's about 24mm wide and 23mm tall, and an M6 nut sits inside.

Load all three STLs into Bambu Studio together and choose **"Load as a single object with multiple parts"**, then assign a filament to each part:

| STL | Filament | Nozzle |
|---|---|---|
| `pumpkin_end_shell.stl` | Bambu PLA Silk+ Orange/Gold | either |
| `pumpkin_end_core.stl` | eSun PLA Glow Rainbow | **hardened**, because glow filament is abrasive |
| `pumpkin_end_stem.stl` | brown PLA | either |

**Settings:** 0.12mm layers, 100% infill (for weight), and no supports. The stem's small overhang prints fine, but you can add tree supports if it droops.

**Nut:** add a pause at **Z = 11.85mm** and drop in an M6 nut when it stops (10mm across the flats, 5mm thick). The pause height prints in the console when you export, so check it there if you change any sizes.

**Assembly:** thread the cord in through the stem, out through the nut and the bottom, tie an overhand knot, then pull the knot up into the bottom recess. The cord passes through the nut's threaded hole: 550 cord is about 4mm and an M6 nut's hole is about 4.9mm, so it's a snug fit.

Charge the glow core under a light, and the face will glow in the dark.
