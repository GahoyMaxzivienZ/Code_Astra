import '../token.dart';
import 'cs_token_type.dart';

class CsLexer {
  final String source;
  int _pos = 0;
  int _line = 1;

  CsLexer(this.source);

  // Note: "using", "System", "Console", "WriteLine", "Main", "string"
  // ay hindi keywords dito — plain identifiers lang sila, tinitignan
  // na lang ang lexeme nila sa Parser.
  static const Map<String, CsTokenType> _keywords = {
    'public': CsTokenType.publicKw,
    'static': CsTokenType.staticKw,
    'void': CsTokenType.voidKw,
    'int': CsTokenType.intKw,
    'if': CsTokenType.ifKw,
    'else': CsTokenType.elseKw,
    'while': CsTokenType.whileKw,
    'for': CsTokenType.forKw,
    'return': CsTokenType.returnKw,
    'class': CsTokenType.classKw,
  };

  List<Token<CsTokenType>> tokenize() {
    final tokens = <Token<CsTokenType>>[];

    while (!_isAtEnd()) {
      _skipWhitespaceAndComments();
      if (_isAtEnd()) break;

      final c = _peek();

      if (_isDigit(c)) {
        tokens.add(_scanNumber());
      } else if (_isAlpha(c)) {
        tokens.add(_scanIdentifierOrKeyword());
      } else if (c == '"') {
        tokens.add(_scanString());
      } else {
        tokens.add(_scanSymbolOrOperator());
      }
    }

    tokens.add(Token(CsTokenType.eof, '', _line));
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

  Token<CsTokenType> _scanNumber() {
    final start = _pos;
    while (!_isAtEnd() && _isDigit(_peek())) {
      _advance();
    }
    final text = source.substring(start, _pos);
    return Token(CsTokenType.numberLiteral, text, _line);
  }

  Token<CsTokenType> _scanIdentifierOrKeyword() {
    final start = _pos;
    while (!_isAtEnd() && _isAlphaNumeric(_peek())) {
      _advance();
    }
    final text = source.substring(start, _pos);
    final keywordType = _keywords[text];
    if (keywordType != null) {
      return Token(keywordType, text, _line);
    }
    return Token(CsTokenType.identifier, text, _line);
  }

  Token<CsTokenType> _scanString() {
    final startLine = _line;
    _advance(); // consume opening "
    final start = _pos;
    while (!_isAtEnd() && _peek() != '"') {
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
    return Token(CsTokenType.stringLiteral, text, startLine);
  }

  Token<CsTokenType> _scanSymbolOrOperator() {
    final c = _advance();
    switch (c) {
      case '(':
        return Token(CsTokenType.lparen, c, _line);
      case ')':
        return Token(CsTokenType.rparen, c, _line);
      case '{':
        return Token(CsTokenType.lbrace, c, _line);
      case '}':
        return Token(CsTokenType.rbrace, c, _line);
      case '[':
        return Token(CsTokenType.lbracket, c, _line);
      case ']':
        return Token(CsTokenType.rbracket, c, _line);
      case ';':
        return Token(CsTokenType.semicolon, c, _line);
      case '.':
        return Token(CsTokenType.dot, c, _line);
      case ',':
        return Token(CsTokenType.comma, c, _line);
      case '+':
        return Token(CsTokenType.plus, c, _line);
      case '-':
        return Token(CsTokenType.minus, c, _line);
      case '*':
        return Token(CsTokenType.star, c, _line);
      case '%':
        return Token(CsTokenType.percent, c, _line);
      case '/':
        return Token(CsTokenType.slash, c, _line);
      case '=':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(CsTokenType.equals, '==', _line);
        }
        return Token(CsTokenType.assign, c, _line);
      case '!':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(CsTokenType.notEquals, '!=', _line);
        }
        throw FormatException(
          'Hindi suportado ang "!" na mag-isa sa line $_line',
        );
      case '>':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(CsTokenType.greaterEqual, '>=', _line);
        }
        return Token(CsTokenType.greater, c, _line);
      case '<':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(CsTokenType.lessEqual, '<=', _line);
        }
        return Token(CsTokenType.less, c, _line);
      default:
        throw FormatException(
          'Hindi kilalang character na "$c" sa line $_line',
        );
    }
  }
}
