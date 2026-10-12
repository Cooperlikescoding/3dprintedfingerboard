$fn=48;
deck_tilt = 25;   // show the deck partway through a kickflip
spin = 20;        // show the yoke partway through a shuvit
// base: thumb-held puck with a hex nut weight inside
color("dimgray") difference(){ cylinder(d=30,h=8); translate([0,0,2]) cylinder(d=14,h=4,$fn=6); }
color("gold") translate([0,0,2.5]) difference(){ cylinder(d=13,h=3,$fn=6); cylinder(d=7,h=10,center=true);}  // nut weight (cutaway)
// vertical shuvit pivot
color("silver") translate([0,0,8]) cylinder(d=5,h=4);
color("hotpink") for(a=[0:90:270]) rotate(a) translate([6.5,0,8]) sphere(d=1.6);   // TPU 68D detent bumps
rotate(spin) {
  // yoke (U-frame) holding the deck at both ends
  color("steelblue") {
    translate([-34,-5,12]) cube([68,10,3]);
    for(sx=[-1,1]) translate([sx*32.5-1.5,-5,12]) cube([3,10,14]);
  }
  // kickflip axle along the deck length
  color("silver") translate([-35,0,21]) rotate([0,90,0]) cylinder(d=2.4,h=70);
  // mini deck: 60 x 22mm with kicked nose and tail
  color("orange") translate([0,0,21]) rotate([deck_tilt,0,0]) {
    hull(){ for(sx=[-1,1]) translate([sx*20,0,0]) cylinder(d=22,h=2.2,center=true); }
    for(sx=[-1,1]) translate([sx*28,0,0]) rotate([0,-sx*20,0]) translate([sx*3,0,1]) scale([1,1,0.2]) sphere(d=12);
    color("black") for(sx=[-1,1]) translate([sx*14,0,-2.3]) cube([6,14,2.4],center=true);   // fake trucks for the look
  }
}
