enum CsTokenType {
  // Keywords
  publicKw,
  staticKw,
  voidKw,
  intKw,
  ifKw,
  elseKw,
  whileKw,
  forKw,
  returnKw,
  classKw,

  // Literals
  identifier,
  numberLiteral,
  stringLiteral,

  // Symbols
  lparen,      // (
  rparen,      // )
  lbrace,      // {
  rbrace,      // }
  lbracket,    // [
  rbracket,    // ]
  semicolon,   // ;
  dot,         // .
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

  // Special
  eof,
}
