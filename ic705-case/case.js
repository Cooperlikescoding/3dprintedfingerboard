// IC-705 field case: parametric geometry built with manifold-3d (always-watertight CSG)
// and shown with three.js. Shared by the browser designer (index.html) and the STL exporter (export-stl.js).
// Axes: X = width, Y = up, Z = depth (radio front face at Z = 0, +Z towards you). Units: mm.

export const DEFAULTS = {
  // Equipment: measure yours with calipers and override these.
  radio:  { w: 200, h: 83.5, d: 82 },    // IC-705 body, without knobs
  tuner:  { w: 190, h: 40,   d: 105 },   // AH-705 lying flat
  mic:    { w: 56,  h: 98,   d: 30 },    // HM-243: width, length, thickness (estimate, so measure it)
  clear: 1.0,       // gap around each item
  wall: 3.0,
  bump: 6,          // how far the frame sticks out past the radio's front face to protect the knobs
  feetH: 10,
  // Lid
  lidClear: 22,     // space in front of the frame for the knobs (the main dial sticks out about 15mm)
  lidOverlap: 10,
  lidTol: 0.4,
  // Hardware
  tripodNutAF: 11.1, tripodNutT: 5.6, tripodHole: 6.8,  // 1/4-20 nut
  pivotPilot: 2.6,  // M3 screw threads straight into the boss
  legLen: 50,
  cableD: 6.4,      // C-clips for coax/USB leads
};

// wasm = the initialised manifold-3d module (after setup()).
export function buildCase(wasm, p = DEFAULTS) {
  const { Manifold } = wasm;
  const box = (x0, x1, y0, y1, z0, z1) => {
    if (x1 <= x0 || y1 <= y0 || z1 <= z0) throw new Error(`box has no volume: ${[x0, x1, y0, y1, z0, z1].map(v => v.toFixed(1))}`);
    return Manifold.cube([x1 - x0, y1 - y0, z1 - z0]).translate([x0, y0, z0]);
  };
  const cylZ = (r, z0, z1, x, y, seg = 40) => Manifold.cylinder(z1 - z0, r, r, seg).translate([x, y, z0]);
  const cylX = (r, x0, x1, y, z, seg = 40) => Manifold.cylinder(x1 - x0, r, r, seg).rotate([0, 90, 0]).translate([x0, y, z]);
  const cylY = (r, y0, y1, x, z, seg = 40) => Manifold.cylinder(y1 - y0, r, r, seg).rotate([-90, 0, 0]).translate([x, y0, z]);
  const add = (...ms) => Manifold.union(ms);
  const sub = (a, ...ms) => (ms.length ? a.subtract(Manifold.union(ms)) : a);

  const { radio: R, tuner: T, mic: M, clear: c, wall: t } = p;

  // ---- Key dimensions ----
  const iw = Math.max(R.w, T.w) + 2 * c;          // inner width
  const W = iw + 2 * t;
  const xL = -W / 2, xR = W / 2;
  const F = p.bump;                                // front edge of the frame
  const zi = -(Math.max(R.d, T.d) + c);            // inner rear face
  const zo = zi - t;                               // outer rear face
  const yT0 = t, yT1 = t + T.h + c;                // tuner bay
  const yR0 = yT1 + t, yR1 = yR0 + R.h + c;        // radio bay (sits on the shelf)
  const H = yR1 + t;
  const dims = { W, H, D: F - zo, F, zo, yT0, yT1, yR0, yR1 };

  // ---- Frame ----
  const shell = sub(box(xL, xR, 0, H, zo, F),
    box(xL + t, xR - t, yT0, yT1, zi, F + 1),      // tuner bay
    box(xL + t, xR - t, yR0, yR1, zi, F + 1));     // radio bay

  // Handle: a front-to-back fin on the left of the top, with a hand hole.
  const hx = xL + 55, hz0 = zo + 8, hz1 = hz0 + 80, hH = 40;
  const handle = sub(box(hx - 8, hx + 8, H - 1, H + hH, hz0, hz1),
    box(hx - 9, hx + 9, H + 6, H + 28, hz0 + 12, hz1 - 12));

  // HM-243 cradle on the right of the top: open on top, with a slot in front for the coiled cable.
  const mInX = M.w + 2 * c, mInZ = M.h + 2 * c, mWallH = Math.min(22, M.d * 0.75);
  const mcx = xR - t - mInX / 2 - 6;
  const mz0 = zo, mz1 = zo + mInZ + 2 * t;
  const cradle = sub(box(mcx - mInX / 2 - t, mcx + mInX / 2 + t, H - 1, H + mWallH, mz0, mz1),
    box(mcx - mInX / 2, mcx + mInX / 2, H, H + mWallH + 1, mz0 + t, mz1 - t),
    box(mcx - 7, mcx + 7, H + 8, H + mWallH + 1, mz1 - t - 1, mz1 + 1));

  // Feet and the tripod boss underneath.
  const fh = p.feetH, tz = (zo + F) / 2;
  const feet = [];
  for (const fx of [xL + 4, xR - 24]) for (const [fz0, fz1] of [[F - 34, F - 14], [zo + 4, zo + 24]])
    feet.push(box(fx, fx + 20, -fh, 0.5, fz0, fz1));
  const boss = box(-14, 14, -fh, 0.5, tz - 14, tz + 14);

  // Kickstand pivot bosses on both sides, near the front bottom.
  const pivY = 12, pivZ = F - 22;
  const pivots = [cylX(6, xL - 6, xL + 0.5, pivY, pivZ), cylX(6, xR - 0.5, xR + 6, pivY, pivZ)];

  // Strap bars for a shoulder strap (25mm webbing) on both sides, front and rear.
  const bars = [];
  for (const s of [-1, 1]) for (const bz of [F - 40, zo + 30]) {
    const xw = s * W / 2;
    const [bx0, bx1] = s < 0 ? [xw - 7, xw + 0.5] : [xw - 0.5, xw + 7];
    const [gx0, gx1] = s < 0 ? [xw - 4, xw + 1] : [xw - 1, xw + 4];
    bars.push(sub(box(bx0, bx1, H - 30, H - 4, bz - 28, bz), box(gx0, gx1, H - 27, H - 7, bz - 29, bz + 1)));
  }

  // Cable C-clips at the rear of both sides, low down. The gap faces outwards.
  const clips = [];
  const cr = p.cableD / 2, cy = 26;
  for (const s of [-1, 1]) {
    const cx = s * (W / 2 + cr + 2);
    const body = add(cylZ(cr + 2.2, zo, zo + 12, cx, cy), box(Math.min(cx, s * W / 2 - s * 0.5), Math.max(cx, s * W / 2 - s * 0.5), cy - 4, cy + 4, zo, zo + 12));
    const [gx0, gx1] = s < 0 ? [cx - cr - 4, cx - 1] : [cx + 1, cx + cr + 4];
    clips.push(sub(body, cylZ(cr, zo - 1, zo + 13, cx, cy), box(gx0, gx1, cy - cr * 0.7, cy + cr * 0.7, zo - 1, zo + 13)));
  }

  let frame = add(shell, handle, cradle, ...feet, boss, ...pivots, ...bars, ...clips);

  // ---- Cut-outs ----
  const cuts = [];
  // Side windows: the IC-705 has jacks on both sides (BNC, SP/MIC, SD on the left; DC, USB, TUNER, KEY on the right).
  for (const [x0, x1] of [[xL - 8, xL + t + 1], [xR - t - 1, xR + 8]]) {
    cuts.push(box(x0, x1, yR0 + 8, yR1 - 8, zi + 10, F - 14));
    cuts.push(box(x0, x1, yT0 + 7, yT1 - 7, zi + 10, F - 34));
  }
  // Rear window for the BP-272 battery and the radio's back.
  cuts.push(box(xL + t + 12, xR - t - 12, yR0 + 8, yR1 - 8, zo - 1, zi + 1));
  // Webbing slots on the rear of the tuner bay (38mm MOLLE spacing).
  for (const sx of [-76, -38, 0, 38, 76]) for (const sy of [yT0 + 9, yT1 - 9])
    cuts.push(box(sx - 13, sx + 13, sy - 2, sy + 2, zo - 1, zi + 1));
  // Tripod: a 1/4-20 nut slides in from the rear of the boss and the tripod screw comes up from below.
  const af = p.tripodNutAF + 0.4, nutY0 = -fh + 1.5;
  cuts.push(cylY(p.tripodHole / 2, -fh - 1, t + 1, 0, tz));
  cuts.push(Manifold.cylinder(p.tripodNutT, af / 2 / Math.cos(Math.PI / 6), af / 2 / Math.cos(Math.PI / 6), 6)
    .rotate([0, 0, 30]).rotate([-90, 0, 0]).translate([0, nutY0, tz]));
  cuts.push(box(-af / 2, af / 2, nutY0, nutY0 + p.tripodNutT, tz - 15, tz));
  // Kickstand pilot holes (blind, for M3 screws).
  cuts.push(cylX(p.pivotPilot / 2, xL - 7, xL + 2, pivY, pivZ, 16), cylX(p.pivotPilot / 2, xR - 2, xR + 7, pivY, pivZ, 16));
  // Lid snap grooves on both sides.
  for (const [x0, x1] of [[xL - 1, xL + 0.9], [xR - 0.9, xR + 1]])
    cuts.push(box(x0, x1, H * 0.25, H * 0.75, F - p.lidOverlap + 2, F - p.lidOverlap + 4.5));
  frame = sub(frame, ...cuts);

  // ---- Lid: slides over the front of the frame and snaps into the side grooves ----
  const lt = p.lidTol, lov = p.lidOverlap;
  const lx0 = xL - lt, lx1 = xR + lt, ly0 = -lt, ly1 = H + lt;
  const lz0 = F - lov, lz1 = F + p.lidClear + t;
  let lid = sub(box(lx0 - t, lx1 + t, ly0 - t, ly1 + t, lz0, lz1), box(lx0, lx1, ly0, ly1, lz0 - 1, lz1 - t));
  lid = add(lid,
    box(lx0 - 0.1, lx0 + 0.8, H * 0.3, H * 0.7, lz0 + 2.4, lz0 + 4.1),       // snap ribs
    box(lx1 - 0.8, lx1 + 0.1, H * 0.3, H * 0.7, lz0 + 2.4, lz0 + 4.1));
  const lidCuts = [];
  if (mz1 > lz0) lidCuts.push(box(mcx - mInX / 2 - t - 1, mcx + mInX / 2 + t + 1, H - 2, ly1 + t + 1, lz0 - 1, mz1 + 1));   // clears the mic cradle
  lid = sub(lid, ...lidCuts);

  // ---- Kickstand leg (print two). Pivot hole at the origin, foot at -legLen along Z. ----
  const L = p.legLen;
  const leg = sub(add(box(0, 4, -5, 5, -L, 0), cylX(5, 0, 4, 0, 0), cylX(5, 0, 4, 0, -L)), cylX(1.7, -1, 5, 0, 0, 20));

  // ---- Reference models (not printed) ----
  const ghosts = {
    radio: { size: [R.w, R.h, R.d], pos: [0, yR0 + R.h / 2, -R.d / 2] },
    tuner: { size: [T.w, T.h, T.d], pos: [0, yT0 + T.h / 2, -T.d / 2] },
    mic:   { size: [M.w, M.d, M.h], pos: [mcx, H + M.d / 2, mz0 + t + c + M.h / 2] },
  };

  return { frame, lid, leg, ghosts, dims, pivot: { y: pivY, z: pivZ, xL: xL - 6, xR: xR + 6 } };
}

// Manifold -> THREE.BufferGeometry (flat-shaded).
export function toGeometry(THREE, manifold) {
  const m = manifold.getMesh();
  const pos = new Float32Array(m.triVerts.length * 3);
  for (let i = 0; i < m.triVerts.length; i++) {
    const v = m.triVerts[i] * m.numProp;
    pos[i * 3] = m.vertProperties[v]; pos[i * 3 + 1] = m.vertProperties[v + 1]; pos[i * 3 + 2] = m.vertProperties[v + 2];
  }
  const g = new THREE.BufferGeometry();
  g.setAttribute('position', new THREE.BufferAttribute(pos, 3));
  g.computeVertexNormals();
  return g;
}

// Binary STL, converted from this file's Y-up axes to the slicer's Z-up axes.
export function toSTL(manifold) {
  const m = manifold.getMesh();
  const tris = m.triVerts.length / 3;
  const buf = new ArrayBuffer(84 + tris * 50);
  const dv = new DataView(buf);
  dv.setUint32(80, tris, true);
  const P = (i) => { const v = m.triVerts[i] * m.numProp; const x = m.vertProperties[v], y = m.vertProperties[v + 1], z = m.vertProperties[v + 2]; return [x, -z, y]; };
  let o = 84;
  for (let t = 0; t < tris; t++) {
    const a = P(t * 3), b = P(t * 3 + 1), c = P(t * 3 + 2);
    const u = [b[0] - a[0], b[1] - a[1], b[2] - a[2]], w = [c[0] - a[0], c[1] - a[1], c[2] - a[2]];
    const n = [u[1] * w[2] - u[2] * w[1], u[2] * w[0] - u[0] * w[2], u[0] * w[1] - u[1] * w[0]];
    const l = Math.hypot(...n) || 1;
    for (const v of [[n[0] / l, n[1] / l, n[2] / l], a, b, c]) { dv.setFloat32(o, v[0], true); dv.setFloat32(o + 4, v[1], true); dv.setFloat32(o + 8, v[2], true); o += 12; }
    o += 2;
  }
  return buf;
}

// Rotations (degrees, in this file's Y-up axes) that lay each part flat for printing.
export const PRINT_POSE = {
  frame: [-90, 0, 0],   // on its back: walls and shelf print vertically, no supports needed
  lid:   [90, 0, 0],    // face down
  leg:   [0, 0, -90],   // flat
};

// Rotate a part into its print pose and set it on the bed, centred.
export function forPrint(manifold, name) {
  const r = manifold.rotate(PRINT_POSE[name]);
  const bb = r.boundingBox();
  return r.translate([-(bb.min[0] + bb.max[0]) / 2, -bb.min[1], -(bb.min[2] + bb.max[2]) / 2]);
}
