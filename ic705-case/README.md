# IC-705 field case

An operate-in-case frame for the Icom IC-705, with a clip-on front lid.

- **AH-705 bay:** the tuner lies flat under the radio.
- **HM-243 cradle:** on top, with a slot for the coiled cord.
- **Handle:** on top.
- **Kickstand legs:** fold down to tilt the screen up.
- **Tripod mount:** a 1/4-20 nut pocket underneath.
- **Strap bars:** for 25mm webbing.
- **MOLLE slots:** on the back of the tuner bay.
- **Cable clips:** C-clips for coax.

Both sides of the radio stay open, because the IC-705 has jacks on both: BNC, SP/MIC and SD on the left; DC, USB, TUNER and KEY on the right. The back is open too, so you can reach the BP-272.

The geometry is built with [manifold-3d](https://github.com/elalish/manifold), so every export is a watertight solid. It's displayed with three.js. `case.js` is shared by the browser designer and the STL exporter.

## Measure with calipers first

The defaults are published sizes, and the HM-243 size is a guess. Measure your own gear:

| What | Measure |
|---|---|
| IC-705 | width (side to side), height (bottom to top), depth (back of the BP-272 to the front panel, not counting the knobs) |
| Main dial and knobs | how far they stick out past the front panel; set **Lid knob space** to that plus 5mm |
| AH-705 | width, thickness and depth, not counting the connectors |
| HM-243 | width, length and thickness at the widest points |

## Use

- **Designer:** run `python3 -m http.server` in this folder, then open http://localhost:8000. Type your sizes in to see the case rebuild, then use **Download STLs (.zip)** to get all three parts, already laid flat for printing.
- **Command line:** run `npm install`, then `node export-stl.js sizes.json`. That writes `../stl/ic705_frame.stl`, `ic705_lid.stl` and `ic705_leg.stl`. Get `sizes.json` from the designer's **Copy sizes** button. Run it without a file to use the defaults.

## Printing

| Part | Qty | Orientation | Notes |
|---|---|---|---|
| `ic705_frame.stl` | 1 | on its back (the export is already set up this way) | about 228 x 185mm footprint, 115mm tall. No supports needed. PETG or PAHT-CF, 4 walls, 15–20% gyroid infill |
| `ic705_lid.stl` | 1 | face down | PETG |
| `ic705_leg.stl` | 2 | flat | PAHT-CF or PETG, 100% infill |

## Hardware

- **Tripod mount:** a 1/4-20 hex nut slides into the slot from the back of the boss under the case.
- **Kickstand:** 2 M3 x 10–12mm screws. They thread straight into the side bosses (2.6mm pilot holes) and act as the pivots.
- **Optional:** stick TPU 40D or foam pads inside the bays so the radio and tuner can't slide.
