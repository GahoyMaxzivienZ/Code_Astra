import '../token.dart';
import 'js_token_type.dart';

class JsLexer {
  final String source;
  int _pos = 0;
  int _line = 1;

  JsLexer(this.source);

  // Note: "console" at "log" ay hindi keywords dito — plain identifiers
  // lang sila, tinitignan na lang ang lexeme nila sa Parser (parehong
  // approach ginamit natin sa "System"/"println" sa Java).
  static const Map<String, JsTokenType> _keywords = {
    'let': JsTokenType.letKw,
    'function': JsTokenType.functionKw,
    'if': JsTokenType.ifKw,
    'else': JsTokenType.elseKw,
    'while': JsTokenType.whileKw,
    'for': JsTokenType.forKw,
    'return': JsTokenType.returnKw,
  };

  List<Token<JsTokenType>> tokenize() {
    final tokens = <Token<JsTokenType>>[];

    while (!_isAtEnd()) {
      _skipWhitespaceAndComments();
      if (_isAtEnd()) break;

      final c = _peek();

      if (_isDigit(c)) {
        tokens.add(_scanNumber());
      } else if (_isAlpha(c)) {
        tokens.add(_scanIdentifierOrKeyword());
      } else if (c == '"' || c == "'") {
        tokens.add(_scanString(c));
      } else {
        tokens.add(_scanSymbolOrOperator());
      }
    }

    tokens.add(Token(JsTokenType.eof, '', _line));
    return tokens;
  }

  // ---------- Helpers ----------

  bool _isAtEnd() => _pos >= source.length;

  String _peek() => source[_pos];

  String _advance() => source[_pos++];

  bool _isDigit(String c) => c.compareTo('0') >= 0 && c.compareTo('9') <= 0;

  bool _isAlpha(String c) =>
      (c.compareTo('a') >= 0 && c.compareTo('z') <= 0) ||
      (c.compareTo('A') >= 0 && c.compareTo('Z') <= 0) ||
      c == '_';

  bool _isAlphaNumeric(String c) => _isAlpha(c) || _isDigit(c);

  void _skipWhitespaceAndComments() {
    while (!_isAtEnd()) {
      final c = _peek();
      if (c == '\n') {
        _line++;
        _advance();
      } else if (c == ' ' || c == '\t' || c == '\r') {
        _advance();
      } else if (c == '/' &&
          _pos + 1 < source.length &&
          source[_pos + 1] == '/') {
        while (!_isAtEnd() && _peek() != '\n') {
          _advance();
        }
      } else {
        break;
      }
    }
  }

  // ---------- Scanners ----------

  Token<JsTokenType> _scanNumber() {
    final start = _pos;
    while (!_isAtEnd() && _isDigit(_peek())) {
      _advance();
    }
    final text = source.substring(start, _pos);
    return Token(JsTokenType.numberLiteral, text, _line);
  }

  Token<JsTokenType> _scanIdentifierOrKeyword() {
    final start = _pos;
    while (!_isAtEnd() && _isAlphaNumeric(_peek())) {
      _advance();
    }
    final text = source.substring(start, _pos);
    final keywordType = _keywords[text];
    if (keywordType != null) {
      return Token(keywordType, text, _line);
    }
    return Token(JsTokenType.identifier, text, _line);
  }

  Token<JsTokenType> _scanString(String quoteChar) {
    final startLine = _line;
    _advance(); // consume opening quote
    final start = _pos;
    while (!_isAtEnd() && _peek() != quoteChar) {
      if (_peek() == '\\' && _pos + 1 < source.length) {
        _advance(); // laktawan ang escaped character (hal. \\" o \\n)
      }
      if (_peek() == '\n') _line++;
      _advance();
    }
    if (_isAtEnd()) {
      throw FormatException(
        'Walang closing quote ang string na nagsimula sa line $startLine.',
      );
    }
    final text = unescapeString(source.substring(start, _pos));
    _advance(); // consume closing quote
    return Token(JsTokenType.stringLiteral, text, startLine);
  }

  Token<JsTokenType> _scanSymbolOrOperator() {
    final c = _advance();
    switch (c) {
      case '(':
        return Token(JsTokenType.lparen, c, _line);
      case ')':
        return Token(JsTokenType.rparen, c, _line);
      case '{':
        return Token(JsTokenType.lbrace, c, _line);
      case '}':
        return Token(JsTokenType.rbrace, c, _line);
      case ';':
        return Token(JsTokenType.semicolon, c, _line);
      case ',':
        return Token(JsTokenType.comma, c, _line);
      case '.':
        return Token(JsTokenType.dot, c, _line);
      case '+':
        return Token(JsTokenType.plus, c, _line);
      case '-':
        return Token(JsTokenType.minus, c, _line);
      case '*':
        return Token(JsTokenType.star, c, _line);
      case '%':
        return Token(JsTokenType.percent, c, _line);
      case '/':
        return Token(JsTokenType.slash, c, _line);
      case '=':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(JsTokenType.equals, '==', _line);
        }
        return Token(JsTokenType.assign, c, _line);
      case '!':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(JsTokenType.notEquals, '!=', _line);
        }
        throw FormatException(
          'Hindi suportado ang "!" na mag-isa sa line $_line',
        );
      case '>':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(JsTokenType.greaterEqual, '>=', _line);
        }
        return Token(JsTokenType.greater, c, _line);
      case '<':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(JsTokenType.lessEqual, '<=', _line);
        }
        return Token(JsTokenType.less, c, _line);
      default:
        throw FormatException(
          'Hindi kilalang character na "$c" sa line $_line',
        );
    }
  }
}
