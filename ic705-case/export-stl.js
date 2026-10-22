// Exports print-ready STLs (already laid flat for printing) to ../stl/ic705_*.stl
// Usage: npm install && npm run export            (uses DEFAULTS in case.js)
//        node export-stl.js my-sizes.json         (overrides, e.g. {"mic": {"w": 58, "h": 101, "d": 31}})
import Module from 'manifold-3d';
import { writeFileSync, readFileSync, mkdirSync } from 'node:fs';
import { buildCase, toSTL, forPrint, DEFAULTS } from './case.js';

const over = process.argv[2] ? JSON.parse(readFileSync(process.argv[2], 'utf8')) : {};
const p = structuredClone(DEFAULTS);
for (const [k, v] of Object.entries(over)) p[k] = typeof v === 'object' ? { ...p[k], ...v } : v;

const wasm = await Module();
wasm.setup();
const t0 = Date.now();
const parts = buildCase(wasm, p);
const d = parts.dims;
console.log(`Built in ${Date.now() - t0} ms. Body ${d.W.toFixed(1)} W x ${d.H.toFixed(1)} H x ${d.D.toFixed(1)} D mm (without handle, feet, cradle)`);
mkdirSync('../stl', { recursive: true });
// Assembled-pose meshes for the designer page to show if WebAssembly can't run.
if (!process.argv[2]) {
  mkdirSync('preview', { recursive: true });
  const meshes = Object.fromEntries(['frame', 'lid', 'leg'].map(n => [n, Buffer.from(toSTL(parts[n])).toString('base64')]));
  writeFileSync('preview/parts.json', JSON.stringify({ ghosts: parts.ghosts, dims: parts.dims, pivot: parts.pivot, meshes }));
}
for (const name of ['frame', 'lid', 'leg']) {
  const m = forPrint(parts[name], name);
  const bb = m.boundingBox();
  writeFileSync(`../stl/ic705_${name}.stl`, Buffer.from(toSTL(m)));
  const s = [0, 1, 2].map(i => (bb.max[i] - bb.min[i]).toFixed(1));
  console.log(`ic705_${name}.stl  ${s[0]} x ${s[2]} footprint, ${s[1]} tall, ${(m.volume() / 1000).toFixed(0)} cm3, genus ${m.genus()}`);
}
