// 7mm street wheel.
// part = "solid" (default: one-piece TPU 68D) | "core" + "tire" (two-material version: PETG core + TPU 68D tire)
include <params.scad>
part = "solid";
core_d = wheel_d - 2 * tire_t;
bore   = axle_d + spin_fit;

module core() difference() {
  union() {
    cylinder(d = core_d, h = wheel_w, $fn = 64);
    translate([0, 0, -0.3]) cylinder(d = bore + 1.4, h = 0.3, $fn = 32);   // inner hub so the wheel doesn't rub the hanger
  }
  translate([0, 0, -1]) cylinder(d = bore, h = wheel_w + 2, $fn = 32);
}
module tire() difference() {
  hull() {
    translate([0, 0, 0.3]) cylinder(d = wheel_d, h = wheel_w - 0.6, $fn = 64);
    cylinder(d = wheel_d - 0.6, h = wheel_w, $fn = 64);
  }
  translate([0, 0, -1]) cylinder(d = core_d, h = wheel_w + 2, $fn = 64);
}
translate([0, 0, 0.3]) {
  if (part == "solid") union() { core(); tire(); }
  if (part == "core") core();
  if (part == "tire") tire();
}
