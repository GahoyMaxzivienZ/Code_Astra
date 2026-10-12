import '../token.dart';
import 'php_token_type.dart';

class PhpLexer {
  final String source;
  int _pos = 0;
  int _line = 1;

  PhpLexer(this.source);

  static const Map<String, PhpTokenType> _keywords = {
    'function': PhpTokenType.functionKw,
    'if': PhpTokenType.ifKw,
    'else': PhpTokenType.elseKw,
    'while': PhpTokenType.whileKw,
    'for': PhpTokenType.forKw,
    'return': PhpTokenType.returnKw,
    'echo': PhpTokenType.echoKw,
  };

  List<Token<PhpTokenType>> tokenize() {
    final tokens = <Token<PhpTokenType>>[];

    while (!_isAtEnd()) {
      _skipWhitespaceCommentsAndTags();
      if (_isAtEnd()) break;

      final c = _peek();

      if (c == '\$') {
        tokens.add(_scanVariable());
      } else if (_isDigit(c)) {
        tokens.add(_scanNumber());
      } else if (_isAlpha(c)) {
        tokens.add(_scanIdentifierOrKeyword());
      } else if (c == '"' || c == "'") {
        tokens.add(_scanString(c));
      } else {
        tokens.add(_scanSymbolOrOperator());
      }
    }

    tokens.add(Token(PhpTokenType.eof, '', _line));
    return tokens;
  }

  // ---------- Helpers ----------

  bool _isAtEnd() => _pos >= source.length;

  String _peek() => source[_pos];

  String _advance() => source[_pos++];

  bool _matchAhead(String literal) {
    if (_pos + literal.length > source.length) return false;
    return source.substring(_pos, _pos + literal.length) == literal;
  }

  bool _isDigit(String c) => c.compareTo('0') >= 0 && c.compareTo('9') <= 0;

  bool _isAlpha(String c) =>
      (c.compareTo('a') >= 0 && c.compareTo('z') <= 0) ||
      (c.compareTo('A') >= 0 && c.compareTo('Z') <= 0) ||
      c == '_';

  bool _isAlphaNumeric(String c) => _isAlpha(c) || _isDigit(c);

  void _skipWhitespaceCommentsAndTags() {
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
      } else if (_matchAhead('<?php')) {
        // opening PHP tag — i-skip lang, hindi natin kailangan sa AST
        for (var i = 0; i < 5; i++) {
          _advance();
        }
      } else if (_matchAhead('?>')) {
        // closing PHP tag — i-skip din
        _advance();
        _advance();
      } else {
        break;
      }
    }
  }

  // ---------- Scanners ----------

  Token<PhpTokenType> _scanVariable() {
    final start = _pos;
    _advance(); // consume "$"
    if (_isAtEnd() || !_isAlpha(_peek())) {
      throw FormatException(
        'Inaasahan ang pangalan ng variable pagkatapos ng "\$" sa line $_line',
      );
    }
    while (!_isAtEnd() && _isAlphaNumeric(_peek())) {
      _advance();
    }
    final text = source.substring(start, _pos); // kasama ang "$"
    return Token(PhpTokenType.identifier, text, _line);
  }

  Token<PhpTokenType> _scanNumber() {
    final start = _pos;
    while (!_isAtEnd() && _isDigit(_peek())) {
      _advance();
    }
    final text = source.substring(start, _pos);
    return Token(PhpTokenType.numberLiteral, text, _line);
  }

  Token<PhpTokenType> _scanIdentifierOrKeyword() {
    final start = _pos;
    while (!_isAtEnd() && _isAlphaNumeric(_peek())) {
      _advance();
    }
    final text = source.substring(start, _pos);
    final keywordType = _keywords[text];
    if (keywordType != null) {
      return Token(keywordType, text, _line);
    }
    return Token(PhpTokenType.identifier, text, _line);
  }

  Token<PhpTokenType> _scanString(String quoteChar) {
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
    return Token(PhpTokenType.stringLiteral, text, startLine);
  }

  Token<PhpTokenType> _scanSymbolOrOperator() {
    final c = _advance();
    switch (c) {
      case '(':
        return Token(PhpTokenType.lparen, c, _line);
      case ')':
        return Token(PhpTokenType.rparen, c, _line);
      case '{':
        return Token(PhpTokenType.lbrace, c, _line);
      case '}':
        return Token(PhpTokenType.rbrace, c, _line);
      case ';':
        return Token(PhpTokenType.semicolon, c, _line);
      case ',':
        return Token(PhpTokenType.comma, c, _line);
      case '+':
        return Token(PhpTokenType.plus, c, _line);
      case '-':
        return Token(PhpTokenType.minus, c, _line);
      case '*':
        return Token(PhpTokenType.star, c, _line);
      case '.':
        return Token(PhpTokenType.dot, c, _line);
      case '%':
        return Token(PhpTokenType.percent, c, _line);
      case '/':
        return Token(PhpTokenType.slash, c, _line);
      case '=':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(PhpTokenType.equals, '==', _line);
        }
        return Token(PhpTokenType.assign, c, _line);
      case '!':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(PhpTokenType.notEquals, '!=', _line);
        }
        throw FormatException(
          'Hindi suportado ang "!" na mag-isa sa line $_line',
        );
      case '>':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(PhpTokenType.greaterEqual, '>=', _line);
        }
        return Token(PhpTokenType.greater, c, _line);
      case '<':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(PhpTokenType.lessEqual, '<=', _line);
        }
        return Token(PhpTokenType.less, c, _line);
      default:
        throw FormatException(
          'Hindi kilalang character na "$c" sa line $_line',
        );
    }
  }
}
