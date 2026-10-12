import '../token.dart';
import 'java_token_type.dart';

class JavaLexer {
  final String source;
  int _pos = 0;
  int _line = 1;

  JavaLexer(this.source);

  static const Map<String, JavaTokenType> _keywords = {
    'public': JavaTokenType.publicKw,
    'class': JavaTokenType.classKw,
    'static': JavaTokenType.staticKw,
    'void': JavaTokenType.voidKw,
    'int': JavaTokenType.intKw,
    'if': JavaTokenType.ifKw,
    'else': JavaTokenType.elseKw,
    'while': JavaTokenType.whileKw,
    'for': JavaTokenType.forKw,
    'return': JavaTokenType.returnKw,
  };

  List<Token<JavaTokenType>> tokenize() {
    final tokens = <Token<JavaTokenType>>[];

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

    tokens.add(Token(JavaTokenType.eof, '', _line));
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

  Token<JavaTokenType> _scanNumber() {
    final start = _pos;
    while (!_isAtEnd() && _isDigit(_peek())) {
      _advance();
    }
    final text = source.substring(start, _pos);
    return Token(JavaTokenType.numberLiteral, text, _line);
  }

  Token<JavaTokenType> _scanIdentifierOrKeyword() {
    final start = _pos;
    while (!_isAtEnd() && _isAlphaNumeric(_peek())) {
      _advance();
    }
    final text = source.substring(start, _pos);
    final keywordType = _keywords[text];
    if (keywordType != null) {
      return Token(keywordType, text, _line);
    }
    return Token(JavaTokenType.identifier, text, _line);
  }

  Token<JavaTokenType> _scanString() {
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
    return Token(JavaTokenType.stringLiteral, text, startLine);
  }

  Token<JavaTokenType> _scanSymbolOrOperator() {
    final c = _advance();
    switch (c) {
      case '(':
        return Token(JavaTokenType.lparen, c, _line);
      case ')':
        return Token(JavaTokenType.rparen, c, _line);
      case '{':
        return Token(JavaTokenType.lbrace, c, _line);
      case '}':
        return Token(JavaTokenType.rbrace, c, _line);
      case '[':
        return Token(JavaTokenType.lbracket, c, _line);
      case ']':
        return Token(JavaTokenType.rbracket, c, _line);
      case ';':
        return Token(JavaTokenType.semicolon, c, _line);
      case '.':
        return Token(JavaTokenType.dot, c, _line);
      case ',':
        return Token(JavaTokenType.comma, c, _line);
      case '+':
        return Token(JavaTokenType.plus, c, _line);
      case '-':
        return Token(JavaTokenType.minus, c, _line);
      case '*':
        return Token(JavaTokenType.star, c, _line);
      case '%':
        return Token(JavaTokenType.percent, c, _line);
      case '/':
        return Token(JavaTokenType.slash, c, _line);
      case '=':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(JavaTokenType.equals, '==', _line);
        }
        return Token(JavaTokenType.assign, c, _line);
      case '!':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(JavaTokenType.notEquals, '!=', _line);
        }
        throw FormatException(
          'Hindi suportado ang "!" na mag-isa sa line $_line',
        );
      case '>':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(JavaTokenType.greaterEqual, '>=', _line);
        }
        return Token(JavaTokenType.greater, c, _line);
      case '<':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(JavaTokenType.lessEqual, '<=', _line);
        }
        return Token(JavaTokenType.less, c, _line);
      default:
        throw FormatException(
          'Hindi kilalang character na "$c" sa line $_line',
        );
    }
  }
}
