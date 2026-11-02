// Magnet-free iambic paddle for the IC-705's built-in keyer.
// The paddles spring back on TPU 40D flexure blades.
//
// Each paddle = 3 bodies printed together as one multi-material object (print 2 paddles):
//   paddle_foot + paddle_arm = PETG (or PAHT-CF)   paddle_blade = TPU 40D
// The blade's T-shaped ends lock into the foot and arm, so they hold together mechanically, not just by layer bond.
//
// Contacts: an M3 x 8 screw through each arm (threads into a 2.6mm pilot hole) touches an M3 x 12 bolt
// that runs through the center post. Turn the arm screws to set the gap (about 0.5mm).
// Wiring (3.5mm stereo): tip = left paddle (dit), ring = right paddle (dah), sleeve = center bolt (common).
//
// part = "base" | "pad" | "paddle_foot" | "paddle_blade" | "paddle_arm" | "assembly"
part = "assembly";
$fn = 40;

// ---- Tuning ----
blade_t   = 1.6;    // TPU blade thickness: thicker = stiffer paddle (1.2 light ... 2.2 heavy)
blade_len = 10;     // free length of the blade: longer = softer
gap       = 2.5;    // space between each arm and the center post
// ---- Weights: your hex nuts, pressed into the base from below ----
nut_af = 13;  nut_t = 6.5;     // M8 (M10: 17 / 8)
// ---- Jack ----
jack_d = 6.2;                  // panel-mount 3.5mm jack thread (most are 6mm)

arm_t = 3;  arm_h = 13;
post_w = 7;
ax = post_w/2 + gap + arm_t/2;          // arm centre-line distance from the middle
foot_len = 14;
y_blade0 = foot_len;
y_blade1 = foot_len + blade_len;
y_contact = 34;  z_contact = 7;
base_t = 10;
bx = 26;  by0 = -6;  by1 = 56;    // base outline: x -bx..bx

// ---------- Paddle (local coords: arm centred on x = 0, base top at z = 0) ----------
module blade() {
  translate([-blade_t/2, y_blade0 - 0.01, 0]) cube([blade_t, blade_len + 0.02, arm_h - 1]);
  for (y = [y_blade0 - 3, y_blade1]) translate([-2, y, 0]) cube([4, 3, arm_h - 1]);   // T-keys
}
module foot() difference() {
  translate([-4, 0, 0]) cube([8, foot_len, arm_h + 1]);
  for (y = [2.5, 7]) {
    translate([0, y, -1]) cylinder(d = 3.3, h = 30);
    translate([0, y, arm_h - 2]) cylinder(d = 6, h = 10);       // screw head counterbore
  }
  blade();
}
module arm() difference() {
  union() {
    translate([-3, y_blade1, 0]) cube([6, 4, arm_h]);                       // block that holds the blade key
    translate([-arm_t/2, y_blade1, 0]) cube([arm_t, 52 - y_blade1, arm_h]);  // arm
    hull() for (y = [54, 72]) for (z = [5, 17])                                // finger pad
      translate([-arm_t/2, y, z]) rotate([0, 90, 0]) cylinder(r = 5, h = arm_t);
    translate([-arm_t/2, 50, 0]) cube([arm_t, 8, arm_h]);
  }
  blade();
  translate([-5, y_contact, z_contact]) rotate([0, 90, 0]) cylinder(d = 2.6, h = 10);  // contact screw pilot
  translate([-5, 40, 3]) rotate([0, 90, 0]) cylinder(d = 1.6, h = 10);              // tiny hole to tie the wire on
}

// ---------- Base ----------
module base() difference() {
  union() {
    translate([-bx, by0, -base_t]) cube([2*bx, by1 - by0, base_t]);
    translate([-post_w/2, y_contact - 5, -0.01]) cube([post_w, 10, arm_h + 1]);       // center contact post
    translate([-9, by0, -0.01]) cube([18, 4, 16]);                                     // jack tab at the rear
  }
  // Center bolt (common contact) runs straight through the post.
  translate([-10, y_contact, z_contact]) rotate([0, 90, 0]) cylinder(d = 3.3, h = 20);
  // Jack hole and a cable channel to the middle.
  translate([0, by0 - 1, 9]) rotate([-90, 0, 0]) cylinder(d = jack_d, h = 10);
  translate([-3, by0 + 3.9, -2]) cube([6, y_contact - 5 - by0 - 3.9, 2.01]);
  // Clearance under each arm so it never rubs the base.
  for (s = [-1, 1]) translate([s * ax - 3.5, y_blade0 - 1, -1.2]) cube([7, by1 - y_blade0 + 2, 1.3]);
  // Paddle foot pilot holes.
  for (s = [-1, 1]) for (y = [2.5, 7]) translate([s * ax, y, -8]) cylinder(d = 2.6, h = 9);
  // Nut weights from below (clear of the foot screws).
  for (xy = [[-15, 24], [15, 24], [-15, 44], [15, 44], [0, 44]])
    translate([xy[0], xy[1], -base_t - 0.01]) cylinder(d = (nut_af + 0.3) / cos(30), h = nut_t + 0.3, $fn = 6);
}
module pad() translate([-bx + 1, by0 + 1, -base_t - 1.2]) cube([2*bx - 2, by1 - by0 - 2, 1.2]);   // TPU 40D grip pad, glue under the base

module paddle(s) translate([s * ax, 0, 0]) { color("dimgray") foot(); color("orange") blade(); color("silver") arm(); }

if (part == "base") translate([0, 0, base_t]) base();
else if (part == "pad") translate([0, 0, base_t + 1.2]) pad();
else if (part == "paddle_foot") foot();
else if (part == "paddle_blade") blade();
else if (part == "paddle_arm") arm();
else if (part == "assembly") {
  color("darkslategray") base();
  color("orange") pad();
  paddle(-1); paddle(1);
}
