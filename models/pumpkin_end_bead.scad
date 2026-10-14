// Jack-o'-lantern begleri END bead for 550 paracord, weighted with an M6 nut.
// Three bodies, printed as one multi-material object:
//   shell = Bambu PLA Silk+ Orange/Gold   (face is cut through to the core)
//   core  = eSun PLA Glow Rainbow         (glows through the eyes and mouth; abrasive, use a hardened nozzle)
//   stem  = brown PLA
// The cord enters through the stem, passes through the nut, and the knot hides in the recess on the bottom.
// part = "shell" | "core" | "stem" | "all"
part = "all";
$fn = 64;

r        = 12;     // pumpkin radius (about 24mm wide)
core_d   = 17;
cord_d   = 4.6;    // 550 paracord
knot_d   = 9.5;    // recess for an overhand knot in 550 cord
knot_h   = 5.5;
nut_af   = 10.0;   // M6
nut_t    = 5.0;
nut_tol  = 0.3;
flat     = 1.0;    // trimmed off the bottom so it prints flat

bc    = r*0.85 - flat;                 // body center height after the bottom trim
nut_z = bc - (nut_t + nut_tol)/2;      // bottom of the nut pocket
echo(str("PUMPKIN: pause at Z = ", nut_z + nut_t + nut_tol, " mm (the first layer that covers the pocket), then drop in the M6 nut"));

module lobes() for (a = [0:45:315]) rotate([0, 0, a]) translate([r*0.28, 0, bc]) scale([0.75, 0.6, 0.85]) sphere(r = r);
module stem_shape() translate([0, 0, bc + r*0.62]) rotate([8, 0, 0]) cylinder(d1 = r*0.5, d2 = r*0.35, h = r*0.55);
module core_sphere() translate([0, 0, bc]) sphere(d = core_d);
module trim() translate([0, 0, -50]) cube(100, center = true);

module face() {
  for (x = [-1, 1]) translate([x * r*0.38, -r, bc + r*0.2]) rotate([90, 0, 0])            // triangle eyes
    linear_extrude(12, center = true) polygon([[-r*0.2, -r*0.14], [r*0.2, -r*0.14], [0, r*0.22]]);
  translate([0, -r, bc + r*0.03]) rotate([90, 0, 0]) linear_extrude(12, center = true)    // nose
    polygon([[-r*0.08, 0], [r*0.08, 0], [0, r*0.13]]);
  translate([0, -r, bc - r*0.3]) rotate([90, 0, 0]) linear_extrude(12, center = true)     // toothy grin
    polygon([[-r*0.55, r*0.08], [-r*0.32, -r*0.14], [-r*0.18, r*0.0], [0, -r*0.2], [r*0.18, r*0.0],
             [r*0.32, -r*0.14], [r*0.55, r*0.08], [r*0.3, r*0.16], [-r*0.3, r*0.16]]);
}

module channels() {
  translate([0, 0, -1]) cylinder(d = cord_d, h = 40, $fn = 32);          // cord path, bottom to the top of the stem
  translate([0, 0, -1]) cylinder(d = knot_d, h = knot_h + 1, $fn = 40);  // knot recess
}
module nut_pocket() translate([0, 0, nut_z]) cylinder(d = (nut_af + nut_tol) / cos(30), h = nut_t + nut_tol, $fn = 6);

module shell() difference() { lobes(); core_sphere(); face(); stem_shape(); channels(); trim(); }
module core()  difference() { core_sphere(); channels(); nut_pocket(); trim(); }
module stem()  difference() { stem_shape(); lobes(); channels(); }

if (part == "shell") shell();
else if (part == "core") core();
else if (part == "stem") stem();
else if (part == "all") { color("orange") shell(); color("greenyellow") core(); color("saddlebrown") stem(); }
