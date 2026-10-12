enum PhpTokenType {
  // Keywords
  functionKw,
  ifKw,
  elseKw,
  whileKw,
  forKw,
  returnKw,
  echoKw,

  // Literals
  identifier, // kasama na dito ang mga variable tulad ng "$x" (kasama ang $ sa lexeme)
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
  dot, // .  (concatenation)
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
