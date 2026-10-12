// 34mm printed truck. The axle is built into the hanger.
// part = "baseplate" | "hanger" | "kingpin" | "bushing" | "pivot_cup" | "axle_cap" | "assembly"
// Mount with the pivot facing the nearest end of the deck (kingpins face each other).
include <params.scad>
part = "assembly";

plate_t = 2.0;
a  = kp_angle;
u  = [sin(a), 0, cos(a)];      // kingpin and pivot axis direction (up, toward the pivot)
nv = [cos(a), 0, -sin(a)];     // perpendicular to the axis, toward the pivot
C  = [-3.5, 0, -5.5];          // where the kingpin passes through the hanger's center
pivot_off = 4.6;               // spacing between the kingpin axis and the pivot axis
hanger_t  = 3.0;               // hanger seat thickness along the axis
pivot_d   = 2.0;
axle_x    = -1.0;
hanger_w  = truck_w - 2 * (wheel_w + wheel_gap);
axle_len  = wheel_w + wheel_gap + 0.2;
tip_d     = 1.5;  tip_len = 1.2;   // reduced-diameter tip that the press-fit axle cap pushes onto

// Place children on the kingpin axis (off = 0) or the pivot axis (off = pivot_off), at distance s along it.
module on_axis(s, off = 0) translate(C + s * u + off * nv) rotate([0, a, 0]) children();
module seg(s0, s1, d, off = 0) on_axis(s0, off) cylinder(d = d, h = s1 - s0, $fn = 40);

s_top_bush = hanger_t/2;                      // top bushing starts here
s_boss     = hanger_t/2 + bushing_h;          // bottom of the baseplate bosses
s_bot_bush = -hanger_t/2 - bushing_h;         // bottom bushing ends here
s_head     = s_bot_bush - 1.0;                // kingpin head

module baseplate() difference() {
  union() {
    translate([-6.5, -4.5, -plate_t]) cube([14.5, 9, plate_t]);
    intersection() {
      union() {
        seg(s_boss, s_boss + 6, 5.0);
        seg(s_boss, s_boss + 6, 3.5, pivot_off);
      }
      translate([-20, -20, -20]) cube([40, 40, 20]);   // trim everything above the mounting face
    }
  }
  for (x = [-hole_dx/2, hole_dx/2]) for (y = [-hole_dy/2, hole_dy/2])
    translate([x, y, -10]) cylinder(d = plate_hole_d, h = 20, $fn = 20);
  seg(s_boss - 1, s_boss + 10, kp_d - press_fit);             // kingpin press-fit hole
  seg(s_boss - 1, s_boss + 2.6, pivot_d + 0.3, pivot_off);     // pivot cup hole
}

module hanger() difference() {
  union() {
    hull() {
      seg(-hanger_t/2, hanger_t/2, bushing_d + 1.2);
      seg(-hanger_t/2, hanger_t/2, pivot_d + 1.6, pivot_off);
    }
    hull() {
      seg(-hanger_t/2, hanger_t/2, bushing_d + 1.2);
      translate([axle_x, 0, axle_z]) rotate([90, 0, 0])
        cylinder(d = 4.0, h = hanger_w * 0.55, center = true, $fn = 40);
    }
    translate([axle_x, 0, axle_z]) rotate([90, 0, 0])            // tapered hanger arms
      cylinder(d1 = 3.0, d2 = 3.0, h = hanger_w, center = true, $fn = 40);
    seg(hanger_t/2 - 0.5, s_boss + 2.4, pivot_d, pivot_off);    // pivot nub
    for (sy = [-1, 1]) {                                          // axle stubs + tips
      translate([axle_x, sy * (hanger_w/2 - 0.5), axle_z]) rotate([-sy * 90, 0, 0]) {
        cylinder(d = axle_d, h = axle_len + 0.5, $fn = 32);
        translate([0, 0, axle_len + 0.49]) cylinder(d = tip_d, h = tip_len, $fn = 24);
      }
    }
  }
  seg(-10, 10, kp_d + 0.8);                                       // loose kingpin hole so the hanger can rock
  seg(s_head - 2, s_bot_bush, bushing_d + 1.0);                   // clearance for the bottom bushing and head
}

// The pin ends just below the mounting face so it never touches the deck.
kp_len = (-C[2] - (kp_d/2) * sin(a) - 0.15) / cos(a) - s_head;
module kingpin() {   // print lying flat: the shaft is split into two D-flats on the bed
  intersection() {
    union() {
      cylinder(d = bushing_d, h = 1.0, $fn = 40);
      cylinder(d = kp_d, h = kp_len, $fn = 32);
      translate([0, 0, kp_len - 0.6]) cylinder(d1 = kp_d, d2 = kp_d - 0.6, h = 0.6, $fn = 32);
    }
    translate([-kp_d/2 + 0.2, -10, -1]) cube([20, 20, kp_len + 2]);
  }
}
module bushing()   difference() { cylinder(d = bushing_d, h = bushing_h, $fn = 40);
                                  translate([0,0,-1]) cylinder(d = kp_d + 0.2, h = bushing_h + 2, $fn = 32); }
module pivot_cup() difference() { cylinder(d = pivot_d + 0.3, h = 2.4, $fn = 32);
                                  translate([0,0,0.4]) cylinder(d = pivot_d - 0.2, h = 3, $fn = 32); }
module axle_cap()  difference() { cylinder(d = 3.0, h = tip_len + 0.4, $fn = 32);
                                  translate([0,0,0.4]) cylinder(d = tip_d - press_fit, h = 3, $fn = 24); }

module assembly() {
  color("dimgray") baseplate();
  color("silver") hanger();
  color("orange") { seg(s_top_bush, s_boss, bushing_d); seg(s_bot_bush, -hanger_t/2, bushing_d); }
  color("gold") on_axis(s_head) kingpin();
  for (sy = [-1, 1]) translate([axle_x, sy * (hanger_w/2 + wheel_gap + wheel_w/2), axle_z])
    rotate([90, 0, 0]) color("hotpink") cylinder(d = wheel_d, h = wheel_w, center = true, $fn = 48);
}

if (part == "baseplate") rotate([180, 0, 0]) baseplate();   // print with the mounting face down
else if (part == "hanger") hanger();                        // print as modeled with supports; axles end up horizontal
else if (part == "kingpin") translate([0, 0, kp_d/2 - 0.2]) rotate([0, -90, 0]) kingpin();   // flat side on the bed
else if (part == "bushing") bushing();
else if (part == "pivot_cup") pivot_cup();
else if (part == "axle_cap") axle_cap();
else assembly();
