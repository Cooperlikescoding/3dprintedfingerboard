// 34mm popsicle deck: medium concave, 20° kicks, modeled grip.
// Print grip side up with tree supports under the kicks.
include <params.scad>

R  = deck_w / 2;          // full-round nose and tail
xs = deck_len / 2 - R;    // where the rounded ends begin

function half_w(x) = abs(x) <= xs ? deck_w / 2
    : max(0.25, sqrt(max(0, R*R - pow(abs(x) - xs, 2))));

function kick_z(x) = let(d = abs(x) - kick_start, k = tan(kick_angle))
    d <= 0 ? 0
  : d <= kick_bend ? d*d / (2*kick_bend) * k
  : kick_bend/2 * k + (d - kick_bend) * k;

function frac(a) = a - floor(a);
function grip_h(x, y, edge) = !grip ? 0 :
    let(a = (x + y) / grip_pitch, b = (x - y) / grip_pitch,
        h = 1 - 2 * max(abs(frac(a) - 0.5), abs(frac(b) - 0.5)),
        fade = min(1, max(0, edge - 0.8) / 0.8))
    -grip_depth * (1 - h) * fade;   // grooves cut down into the top surface

nx = grip ? 400 : 120;
ny = grip ? 136 : 40;

// Cosine spacing along x packs more samples into the rounded ends.
function xu(i) = -deck_len/2 * cos(180 * i / nx) * 0.9999;
function yv(i, j) = half_w(xu(i)) * (2 * j / ny - 1);
function ztop(i, j) = let(x = xu(i), y = yv(i, j), hw = half_w(x))
    kick_z(x) + concave_depth * pow(y / (deck_w/2), 2)
  + grip_h(x, y, hw - abs(y));

top = [for (i = [0:nx]) for (j = [0:ny]) [xu(i), yv(i, j), ztop(i, j)]];
bot = [for (i = [0:nx]) for (j = [0:ny])
          let(x = xu(i), y = yv(i, j))
          [x, y, kick_z(x) + concave_depth * pow(y / (deck_w/2), 2) - deck_t]];
n = (nx + 1) * (ny + 1);
function T(i, j) = i * (ny + 1) + j;
function B(i, j) = n + T(i, j);

faces = concat(
  [for (i = [0:nx-1]) for (j = [0:ny-1]) each
     [[T(i,j), T(i,j+1), T(i+1,j+1)], [T(i,j), T(i+1,j+1), T(i+1,j)]]],
  [for (i = [0:nx-1]) for (j = [0:ny-1]) each
     [[B(i,j), B(i+1,j+1), B(i,j+1)], [B(i,j), B(i+1,j), B(i+1,j+1)]]],
  [for (i = [0:nx-1]) each
     [[T(i,0), T(i+1,0), B(i+1,0)], [T(i,0), B(i+1,0), B(i,0)],
      [T(i,ny), B(i+1,ny), T(i+1,ny)], [T(i,ny), B(i,ny), B(i+1,ny)]]],
  [for (j = [0:ny-1]) each
     [[T(0,j), B(0,j), B(0,j+1)], [T(0,j), B(0,j+1), T(0,j+1)],
      [T(nx,j), B(nx,j+1), B(nx,j)], [T(nx,j), T(nx,j+1), B(nx,j+1)]]]
);

module deck_body() polyhedron(concat(top, bot), faces, convexity = 6);

difference() {
  deck_body();
  for (sx = [-1, 1]) for (x = [wheelbase/2, wheelbase/2 + hole_dx])
    for (y = [-hole_dy/2, hole_dy/2])
      translate([sx * x, y, -10]) cylinder(d = deck_hole_d, h = 20, $fn = 24);
}
