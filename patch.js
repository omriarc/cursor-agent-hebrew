"use strict";
const fs = require("fs");
const path = require("path");

const versionDir = process.argv[2];
if (!versionDir) {
  console.error("usage: patch.js <version-dir>");
  process.exit(1);
}

const indexPath = path.join(versionDir, "index.js");
const reorderPath = path.join(__dirname, "hebrew-reorder.js");
const hook =
  "globalThis.__hebrewReorderCells=require(" +
  JSON.stringify(reorderPath) +
  ").reorderCells;globalThis.__hebrewReorderString=require(" +
  JSON.stringify(reorderPath) +
  ").reorderString;\n";
const marker = "__hebrewReorderCells";
const needle1 = "const o=k(Q(r));let c=i;for(const t of o){";
const repl1 = "const o=globalThis.__hebrewReorderCells(k(Q(r)));let c=i;for(const t of o){";
const needle2 = 'n+=" ".repeat(r)+e.text,t+=r';
const repl2 = 'n+=" ".repeat(r)+globalThis.__hebrewReorderString(e.text),t+=r';
const banner = "/*! For license information please see index.js.LICENSE.txt */\n";

let source;
try {
  source = fs.readFileSync(indexPath, "utf8");
} catch (err) {
  console.error("cursor-hebrew: cannot read " + indexPath);
  process.exit(0);
}

if (source.includes(marker)) {
  const relative = 'require("./hebrew-reorder.js")';
  if (source.includes(relative)) {
    const absolute = "require(" + JSON.stringify(reorderPath) + ")";
    fs.writeFileSync(indexPath, source.split(relative).join(absolute));
  }
  process.exit(0);
}

if (!source.startsWith(banner) || !source.includes(needle1) || !source.includes(needle2)) {
  console.error("cursor-hebrew: this Agent build renders text differently, Hebrew was left unchanged");
  process.exit(0);
}

const backup = path.join(versionDir, "index.js.hebrew-bidi-backup");
if (!fs.existsSync(backup)) fs.copyFileSync(indexPath, backup);

let next = banner + hook + source.slice(banner.length);
next = next.replace(needle1, repl1);
next = next.replace(needle2, repl2);
fs.writeFileSync(indexPath, next);
