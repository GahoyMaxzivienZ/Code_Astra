import '../token.dart';
import 'cpp_token_type.dart';

class CppLexer {
  final String source;
  int _pos = 0;
  int _line = 1;

  CppLexer(this.source);

  // Note: "cout", "endl", "using", "namespace", "main", "std" ay hindi
  // keywords dito — plain identifiers lang sila, tinitignan na lang
  // ang lexeme nila sa Parser (parehong approach ginamit natin sa
  // "System"/"println" sa Java lexer).
  static const Map<String, CppTokenType> _keywords = {
    'int': CppTokenType.intKw,
    'void': CppTokenType.voidKw,
    'if': CppTokenType.ifKw,
    'else': CppTokenType.elseKw,
    'while': CppTokenType.whileKw,
    'for': CppTokenType.forKw,
    'return': CppTokenType.returnKw,
  };

  List<Token<CppTokenType>> tokenize() {
    final tokens = <Token<CppTokenType>>[];

    while (!_isAtEnd()) {
      _skipWhitespaceCommentsAndPreprocessor();
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

    tokens.add(Token(CppTokenType.eof, '', _line));
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

  void _skipWhitespaceCommentsAndPreprocessor() {
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
        // single-line comment
        while (!_isAtEnd() && _peek() != '\n') {
          _advance();
        }
      } else if (c == '#') {
        // preprocessor directive, hal. "#include <iostream>" — i-skip
        // lang buong linya, hindi bahagi ng "foundations" scope natin
        while (!_isAtEnd() && _peek() != '\n') {
          _advance();
        }
      } else {
        break;
      }
    }
  }

  // ---------- Scanners ----------

  Token<CppTokenType> _scanNumber() {
    final start = _pos;
    while (!_isAtEnd() && _isDigit(_peek())) {
      _advance();
    }
    final text = source.substring(start, _pos);
    return Token(CppTokenType.numberLiteral, text, _line);
  }

  Token<CppTokenType> _scanIdentifierOrKeyword() {
    final start = _pos;
    while (!_isAtEnd() && _isAlphaNumeric(_peek())) {
      _advance();
    }
    final text = source.substring(start, _pos);
    final keywordType = _keywords[text];
    if (keywordType != null) {
      return Token(keywordType, text, _line);
    }
    return Token(CppTokenType.identifier, text, _line);
  }

  Token<CppTokenType> _scanString() {
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
    return Token(CppTokenType.stringLiteral, text, startLine);
  }

  Token<CppTokenType> _scanSymbolOrOperator() {
    final c = _advance();
    switch (c) {
      case '(':
        return Token(CppTokenType.lparen, c, _line);
      case ')':
        return Token(CppTokenType.rparen, c, _line);
      case '{':
        return Token(CppTokenType.lbrace, c, _line);
      case '}':
        return Token(CppTokenType.rbrace, c, _line);
      case ';':
        return Token(CppTokenType.semicolon, c, _line);
      case ',':
        return Token(CppTokenType.comma, c, _line);
      case '+':
        return Token(CppTokenType.plus, c, _line);
      case '-':
        return Token(CppTokenType.minus, c, _line);
      case '*':
        return Token(CppTokenType.star, c, _line);
      case '%':
        return Token(CppTokenType.percent, c, _line);
      case '/':
        return Token(CppTokenType.slash, c, _line);
      case '=':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(CppTokenType.equals, '==', _line);
        }
        return Token(CppTokenType.assign, c, _line);
      case '!':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(CppTokenType.notEquals, '!=', _line);
        }
        throw FormatException(
          'Hindi suportado ang "!" na mag-isa sa line $_line',
        );
      case '>':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(CppTokenType.greaterEqual, '>=', _line);
        }
        return Token(CppTokenType.greater, c, _line);
      case '<':
        if (!_isAtEnd() && _peek() == '<') {
          _advance();
          return Token(CppTokenType.shiftLeft, '<<', _line);
        }
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(CppTokenType.lessEqual, '<=', _line);
        }
        return Token(CppTokenType.less, c, _line);
      default:
        throw FormatException(
          'Hindi kilalang character na "$c" sa line $_line',
        );
    }
  }
}
