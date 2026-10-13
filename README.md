# Cursor Agent Hebrew

[עברית](README.he.md)

Hebrew in the Cursor Agent terminal reads from right to left. English stays on the left.

Agent paints its screen one cell at a time, left to right. Hebrew is stored with the first letter first, so a word like `היי` was landing with `ה` on the left. This launcher reorders those cells with the Unicode bidirectional algorithm just before they are drawn.

The model text is unchanged. The fix lives outside the Agent install, in `~/.local/share/cursor-hebrew`.

## Install

Cursor Agent must already be installed (`agent` works in a terminal).

```bash
git clone git@github.com:omriarc/cursor-agent-hebrew.git
cd cursor-agent-hebrew
./install.sh
```

Open a new terminal and start `agent` again.

## After an Agent update

An update replaces the Agent version and puts the original `agent` shortcut back. The next terminal puts this launcher back and applies Hebrew to the new version before Agent starts.

## What you will notice

- A Hebrew line reads from the right.
- An English line stays on the left.
- A number inside Hebrew, such as `12`, stays `12`.
- While typing, the caret can sit at the edge of a Hebrew word. The letters are still in the right order.

If a future Agent build draws the screen differently, the installer leaves Hebrew unchanged and prints one line, instead of breaking Agent.

## License

The launcher is MIT. `hebrew-bidi.js` is [bidi-js](https://github.com/lojjic/bidi-js) by Jason Johnston, also MIT. See `LICENSE` and `NOTICE`.
