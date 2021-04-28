library constants;

const escape = 27;
const arrowLeft = 68;
const arrowRight = 67;
const arrowUp = 65;
const arrowDown = 66;
const startOfLine = 1;
const endOfLine = 5;
const eof = 4;
const backspace = 127;
const clear = 12;
const newLine = 10;
const carriageReturn = 13;
const forward = 6;
const backward = 2;
const killToStart = 21;
const killToEnd = 11;
const yank = 25;
const home = 72;
const end = 70;

final String ansiEscape = new String.fromCharCode(escape);

/// Returns the code of the first code unit.
int c(String s) => s.codeUnitAt(0);
