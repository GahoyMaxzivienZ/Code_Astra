import '../token.dart';
import 'python_token_type.dart';

/// Ang PythonLexer ay iba kaysa sa JavaLexer/CppLexer dahil kailangan
/// niyang subaybayan ang INDENTATION (spacing sa simula ng linya) —
/// dito kasi "minamarkahan" ni Python kung saan nagsisimula/natatapos
/// ang isang code block, imbes na gumamit ng { }.
///
/// Ginagamit namin ang isang "indent stack" — listahan ng mga
/// indentation levels na kasalukuyang "bukas". Halimbawa, kung
/// papasok tayo ng mas malalim na indentation, mag-e-emit tayo ng
/// isang INDENT token. Kapag bumalik tayo sa mas mababaw na
/// indentation, mag-e-emit tayo ng DEDENT token(s).
class PythonLexer {
  final String source;
  int _pos = 0;
  int _line = 1;

  final List<int> _indentStack = [0];

  PythonLexer(String source)
    : source = source.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

  static const Map<String, PythonTokenType> _keywords = {
    'def': PythonTokenType.defKw,
    'if': PythonTokenType.ifKw,
    'else': PythonTokenType.elseKw,
    'while': PythonTokenType.whileKw,
    'for': PythonTokenType.forKw,
    'in': PythonTokenType.inKw,
    'return': PythonTokenType.returnKw,
    'elif': PythonTokenType.elifKw,
    'and': PythonTokenType.andKw,
    'or': PythonTokenType.orKw,
    'not': PythonTokenType.notKw,
    'break': PythonTokenType.breakKw,
    'continue': PythonTokenType.continueKw,
  };

  List<Token<PythonTokenType>> tokenize() {
    final tokens = <Token<PythonTokenType>>[];
    var atLineStart = true;

    while (!_isAtEnd()) {
      if (atLineStart) {
        // Bilangin ang leading spaces sa simula ng linyang ito
        var indentCount = 0;
        while (!_isAtEnd() && (_peek() == ' ' || _peek() == '\t')) {
          indentCount += _peek() == '\t'
              ? 4
              : 1; // ang tab ay bilang 4 na spaces
          _advance();
        }

        if (_isAtEnd()) break;

        // Blank line — laktawan, hindi ito nag-aaffect ng indentation
        if (_peek() == '\n') {
          _advance();
          _line++;
          continue;
        }

        // Comment-only line — laktawan din
        if (_peek() == '#') {
          while (!_isAtEnd() && _peek() != '\n') {
            _advance();
          }
          continue;
        }

        // May tunay na laman ang linyang ito — ikumpara ang indentation
        if (indentCount > _indentStack.last) {
          _indentStack.add(indentCount);
          tokens.add(Token(PythonTokenType.indent, '', _line));
        } else {
          while (indentCount < _indentStack.last) {
            _indentStack.removeLast();
            tokens.add(Token(PythonTokenType.dedent, '', _line));
          }
          if (indentCount != _indentStack.last) {
            throw FormatException(
              'Hindi tugma ang indentation sa line $_line. Siguraduhing consistent ang bilang ng spaces na ginagamit mo.',
            );
          }
        }

        atLineStart = false;
      }

      if (_isAtEnd()) break;
      final c = _peek();

      if (c == '\n') {
        tokens.add(Token(PythonTokenType.newline, '', _line));
        _advance();
        _line++;
        atLineStart = true;
        continue;
      }
      if (c == ' ' || c == '\t' || c == '\r') {
        _advance();
        continue;
      }
      if (c == '#') {
        while (!_isAtEnd() && _peek() != '\n') {
          _advance();
        }
        continue;
      }
      if (_isDigit(c)) {
        tokens.add(_scanNumber());
        continue;
      }
      if (_isAlpha(c)) {
        tokens.add(_scanIdentifierOrKeyword());
        continue;
      }
      if (c == '"' || c == "'") {
        tokens.add(_scanString(c));
        continue;
      }
      tokens.add(_scanSymbolOrOperator());
    }

    // Siguraduhing may closing NEWLINE ang huling linya (kung wala pang)
    if (tokens.isNotEmpty && tokens.last.type != PythonTokenType.newline) {
      tokens.add(Token(PythonTokenType.newline, '', _line));
    }

    // I-dedent lahat pababa sa 0 sa dulo ng file
    while (_indentStack.length > 1) {
      _indentStack.removeLast();
      tokens.add(Token(PythonTokenType.dedent, '', _line));
    }

    tokens.add(Token(PythonTokenType.eof, '', _line));
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

  // ---------- Scanners ----------

  Token<PythonTokenType> _scanNumber() {
    final start = _pos;
    while (!_isAtEnd() && _isDigit(_peek())) {
      _advance();
    }
    final text = source.substring(start, _pos);
    return Token(PythonTokenType.numberLiteral, text, _line);
  }

  Token<PythonTokenType> _scanIdentifierOrKeyword() {
    final start = _pos;
    while (!_isAtEnd() && _isAlphaNumeric(_peek())) {
      _advance();
    }
    final text = source.substring(start, _pos);
    final keywordType = _keywords[text];
    if (keywordType != null) {
      return Token(keywordType, text, _line);
    }
    return Token(PythonTokenType.identifier, text, _line);
  }

  Token<PythonTokenType> _scanString(String quoteChar) {
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
    return Token(PythonTokenType.stringLiteral, text, startLine);
  }

  Token<PythonTokenType> _scanSymbolOrOperator() {
    final c = _advance();
    switch (c) {
      case '(':
        return Token(PythonTokenType.lparen, c, _line);
      case ')':
        return Token(PythonTokenType.rparen, c, _line);
      case ':':
        return Token(PythonTokenType.colon, c, _line);
      case ',':
        return Token(PythonTokenType.comma, c, _line);
      case '+':
        return Token(PythonTokenType.plus, c, _line);
      case '-':
        return Token(PythonTokenType.minus, c, _line);
      case '*':
        if (!_isAtEnd() && _peek() == '*') {
          _advance();
          return Token(PythonTokenType.starStar, '**', _line);
        }
        return Token(PythonTokenType.star, c, _line);
      case '%':
        return Token(PythonTokenType.percent, c, _line);
      case '/':
        if (!_isAtEnd() && _peek() == '/') {
          _advance();
          return Token(PythonTokenType.slashSlash, '//', _line);
        }
        return Token(PythonTokenType.slash, c, _line);
      case '=':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(PythonTokenType.equals, '==', _line);
        }
        return Token(PythonTokenType.assign, c, _line);
      case '!':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(PythonTokenType.notEquals, '!=', _line);
        }
        throw FormatException(
          'Hindi suportado ang "!" na mag-isa sa line $_line. Sa Python, gamitin ang "not" para sa negation (hal. not x).',
        );
      case '>':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(PythonTokenType.greaterEqual, '>=', _line);
        }
        return Token(PythonTokenType.greater, c, _line);
      case '<':
        if (!_isAtEnd() && _peek() == '=') {
          _advance();
          return Token(PythonTokenType.lessEqual, '<=', _line);
        }
        return Token(PythonTokenType.less, c, _line);
      default:
        throw FormatException(
          'Hindi kilalang character na "$c" sa line $_line',
        );
    }
  }
}
