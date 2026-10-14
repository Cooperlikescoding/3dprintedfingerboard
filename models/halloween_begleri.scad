// Halloween monkey's fist begleri for 550 paracord, printed in glow PLA.
// part = "core" | "skull" | "pumpkin" | "all"
// Glow PLA is abrasive, so use a hardened nozzle.
part = "all";
$fn = 64;

// Weighted core: tie the monkey's fist around it.
core_d   = 19;     // 19mm suits a 4-pass monkey's fist in 550 cord; use 16 for a 3-pass
nut_af   = 10.0;   // across-flats of your nut (M5 = 8, M6 = 10, M8 = 13)
nut_t    = 5.0;    // nut thickness
nut_tol  = 0.3;
flat     = 1.0;    // flat on the bottom so it prints without supports (the knot hides it)

// Slider beads
cord_d   = 4.6;    // bore for 550 cord
bead_d   = 15;

cz        = core_d/2 - flat;                         // core center height above the bed
pause_z   = cz + (nut_t + nut_tol)/2;                // top of the nut pocket
echo(str("CORE: pause the print at about Z = ", pause_z, " mm (the first layer that covers the pocket), then drop in the nut"));

module core() difference() {
  translate([0, 0, cz]) sphere(d = core_d);
  translate([0, 0, -50]) cube(100, center = true);                          // bottom flat
  translate([0, 0, cz - (nut_t + nut_tol)/2])
    cylinder(d = (nut_af + nut_tol) / cos(30), h = nut_t + nut_tol, $fn = 6);
}

// Bore runs left to right, so the face points out while the bead is on the cord.
module bore() rotate([0, 90, 0]) cylinder(d = cord_d, h = 50, center = true, $fn = 32);

module skull() {
  r = bead_d/2;
  difference() {
    union() {
      translate([0, 0, r]) scale([1, 1.05, 1]) sphere(r = r);                  // cranium
      hull() for (x = [-r*0.45, r*0.45])                                      // jaw
        translate([x, -r*0.55, r*0.35]) sphere(r = r*0.32);
    }
    for (x = [-1, 1]) translate([x * r*0.38, -r*0.85, r*1.05]) sphere(r = r*0.3);   // eye sockets
    translate([0, -r*1.0, r*0.62]) rotate([90, 0, 0])                         // nose
      linear_extrude(4, center = true) polygon([[-r*0.12, 0], [r*0.12, 0], [0, r*0.26]]);
    for (x = [-2:2]) translate([x * r*0.18, -r*0.95, r*0.3])                  // teeth
      cube([r*0.05, 3, r*0.35], center = true);
    translate([0, 0, r]) bore();
    translate([0, 0, -50]) cube(100, center = true);
  }
}

module pumpkin() {
  r = bead_d/2;
  difference() {
    union() {
      for (a = [0:45:315]) rotate([0, 0, a]) translate([r*0.28, 0, r*0.85])  // ribbed lobes
        scale([0.75, 0.6, 0.85]) sphere(r = r);
      translate([0, 0, r*1.55]) rotate([8, 0, 0]) cylinder(d1 = r*0.45, d2 = r*0.3, h = r*0.5);   // stem
    }
    for (x = [-1, 1]) translate([x * r*0.38, -r*0.7, r*1.05]) rotate([90, 0, 0])     // triangle eyes
      linear_extrude(r, center = true) polygon([[-r*0.18, -r*0.12], [r*0.18, -r*0.12], [0, r*0.2]]);
    translate([0, -r*0.75, r*0.55]) rotate([90, 0, 0]) linear_extrude(r, center = true)   // zig-zag mouth
      polygon([[-r*0.55, 0.0], [-r*0.3, -r*0.2], [-r*0.15, 0], [0, -r*0.22], [r*0.15, 0],
               [r*0.3, -r*0.2], [r*0.55, 0.0], [r*0.3, r*0.12], [-r*0.3, r*0.12]]);
    translate([0, 0, r*0.85]) bore();
    translate([0, 0, -50]) cube(100, center = true);
  }
}

if (part == "core") core();
else if (part == "skull") skull();
else if (part == "pumpkin") pumpkin();
else { core(); translate([24, 0, 0]) skull(); translate([46, 0, 0]) pumpkin(); }
