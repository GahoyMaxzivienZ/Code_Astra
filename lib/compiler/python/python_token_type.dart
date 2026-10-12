enum PythonTokenType {
  // Keywords
  defKw,
  ifKw,
  elseKw,
  whileKw,
  forKw,
  inKw,
  returnKw,
  elifKw,
  andKw,
  orKw,
  notKw,
  breakKw,
  continueKw,

  // Literals
  identifier,
  numberLiteral,
  stringLiteral,

  // Symbols
  lparen, // (
  rparen, // )
  colon, // :
  comma, // ,
  // Operators
  plus,
  minus,
  star,
  slash,
  percent, // %
  slashSlash, // //
  starStar, // **
  assign, // =
  equals, // ==
  notEquals, // !=
  greater, // >
  less, // <
  greaterEqual, // >=
  lessEqual, // <=
  // Structural tokens (natatangi sa indentation-based languages tulad ng Python)
  newline, // katapusan ng isang logical line
  indent, // dumagdag ang indentation level (bagong block)
  dedent, // bumaba ang indentation level (katapusan ng block)
  // Special
  eof,
}
