"use strict";
const bidi = require("./hebrew-bidi.js")();
const RTL = /[\u0590-\u08FF\uFB1D-\uFDFF\uFE70-\uFEFF]/;

function reorderString(text) {
  if (!text || text.includes("\u001b") || !RTL.test(text)) return text;
  const levels = bidi.getEmbeddingLevels(text);
  const indices = bidi.getReorderedIndices(text, levels);
  let out = "";
  for (let i = 0; i < indices.length; i++) {
    const src = indices[i];
    const ch = text[src];
    const mirrored = (levels.levels[src] & 1) ? bidi.getMirroredCharacter(ch) : null;
    out += mirrored || ch;
  }
  return out;
}

function reorderCells(cells) {
  if (!cells || !cells.length) return cells;
  let text = "";
  const map = [];
  const spanStart = [];
  for (let i = 0; i < cells.length; i++) {
    const value = cells[i].value || "";
    spanStart.push(text.length);
    text += value;
    for (let j = 0; j < value.length; j++) map.push(i);
  }
  if (!RTL.test(text)) return cells;
  const levels = bidi.getEmbeddingLevels(text);
  const indices = bidi.getReorderedIndices(text, levels);
  const seen = new Set();
  const out = [];
  for (let k = 0; k < indices.length; k++) {
    const ci = map[indices[k]];
    if (ci === undefined || seen.has(ci)) continue;
    seen.add(ci);
    let cell = cells[ci];
    const ch = cell.value;
    if (ch && ch.length === 1 && (levels.levels[spanStart[ci]] & 1)) {
      const mirrored = bidi.getMirroredCharacter(ch);
      if (mirrored && mirrored !== ch) cell = Object.assign({}, cell, { value: mirrored });
    }
    out.push(cell);
  }
  return out.length === cells.length ? out : cells;
}

module.exports = { reorderString, reorderCells };
