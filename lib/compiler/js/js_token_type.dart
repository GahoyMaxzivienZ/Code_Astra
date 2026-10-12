enum JsTokenType {
  // Keywords
  letKw,
  functionKw,
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
  dot,         // .  (ginagamit ng console.log)

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
