enum CppTokenType {
  // Keywords
  intKw,
  voidKw,
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
  lparen,      // (
  rparen,      // )
  lbrace,      // {
  rbrace,      // }
  semicolon,   // ;
  comma,       // ,

  // Operators
  plus,
  minus,
  star,
  slash,
  percent, // %
  assign,        // =
  equals,        // ==
  notEquals,     // !=
  greater,       // >
  less,          // <
  greaterEqual,  // >=
  lessEqual,     // <=
  shiftLeft,     // <<  (ginagamit ng cout)

  // Special
  eof,
}
