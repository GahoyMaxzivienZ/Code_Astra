enum JavaTokenType {
  // Keywords
  publicKw,
  classKw,
  staticKw,
  voidKw,
  intKw,
  ifKw,
  elseKw,
  whileKw,
  forKw,
  returnKw,

  // Literals
  identifier,
  numberLiteral,
  stringLiteral,

  // Symbols
  lparen, // (
  rparen, // )
  lbrace, // {
  rbrace, // }
  lbracket, // [
  rbracket, // ]
  semicolon, // ;
  dot, // .
  comma, // ,
  // Operators
  plus,
  minus,
  star,
  slash,
  percent, // %
  assign, // =
  equals, // ==
  notEquals, // !=
  greater, // >
  less, // <
  greaterEqual, // >=
  lessEqual, // <=
  // Special
  eof,
}
