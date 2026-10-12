class Token<T> {
  final T type;
  final String lexeme; // yung actual text na na-scan, e.g. "println", "5", "+"
  final int line;

  Token(this.type, this.lexeme, this.line);

  @override
  String toString() => '$type("$lexeme")';
}

/// Ginagawang totoong character ang mga escape sequence sa loob ng string
/// literal (hal. "\n" -> newline, "\"" -> quote).
String unescapeString(String raw) {
  if (!raw.contains('\\')) return raw;
  final b = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final c = raw[i];
    if (c == '\\' && i + 1 < raw.length) {
      final n = raw[++i];
      switch (n) {
        case 'n':
          b.write('\n');
          break;
        case 't':
          b.write('\t');
          break;
        case 'r':
          b.write('\r');
          break;
        case '\\':
          b.write('\\');
          break;
        case '"':
          b.write('"');
          break;
        case "'":
          b.write("'");
          break;
        case r'$':
          b.write(r'$');
          break;
        default:
          b.write('\\');
          b.write(n);
      }
    } else {
      b.write(c);
    }
  }
  return b.toString();
}
