import '../compiler/java/java_lexer.dart';
import '../compiler/java/java_parser.dart';
import '../compiler/java/java_interpreter.dart';
import '../compiler/cpp/cpp_lexer.dart';
import '../compiler/cpp/cpp_parser.dart';
import '../compiler/cpp/cpp_interpreter.dart';
import '../compiler/python/python_lexer.dart';
import '../compiler/python/python_parser.dart';
import '../compiler/python/python_interpreter.dart';
import '../compiler/js/js_lexer.dart';
import '../compiler/js/js_parser.dart';
import '../compiler/js/js_interpreter.dart';
import '../compiler/cs/cs_lexer.dart';
import '../compiler/cs/cs_parser.dart';
import '../compiler/cs/cs_interpreter.dart';
import '../compiler/php/php_lexer.dart';
import '../compiler/php/php_parser.dart';
import '../compiler/php/php_interpreter.dart';

class CompilerResult {
  final bool success;
  final String output;
  final String error;

  CompilerResult.success(this.output) : success = true, error = '';

  CompilerResult.failure(this.error) : success = false, output = '';
}

/// Generic na representasyon ng isang token, para magamit ng UI
/// (Token Visualizer) kahit magkaiba ang TokenType enum ng bawat language.
class TokenDisplay {
  final String typeName; // hal. "ifKw", "identifier", "numberLiteral"
  final String lexeme; // yung aktwal na text
  final int line;

  TokenDisplay(this.typeName, this.lexeme, this.line);
}

class CompilerService {
  static CompilerResult runJavaCode(String code) {
    try {
      final lexer = JavaLexer(code);
      final tokens = lexer.tokenize();
      final parser = JavaParser(tokens);
      final program = parser.parseProgram();
      final interpreter = JavaInterpreter();
      final output = interpreter.interpret(program);
      return CompilerResult.success(output);
    } on FormatException catch (e) {
      return CompilerResult.failure(e.message);
    } catch (e) {
      return CompilerResult.failure('Hindi inaasahang error: $e');
    }
  }

  static CompilerResult runCppCode(String code) {
    try {
      final lexer = CppLexer(code);
      final tokens = lexer.tokenize();
      final parser = CppParser(tokens);
      final program = parser.parseProgram();
      final interpreter = CppInterpreter();
      final output = interpreter.interpret(program);
      return CompilerResult.success(output);
    } on FormatException catch (e) {
      return CompilerResult.failure(e.message);
    } catch (e) {
      return CompilerResult.failure('Hindi inaasahang error: $e');
    }
  }

  static CompilerResult runPythonCode(String code) {
    try {
      final lexer = PythonLexer(code);
      final tokens = lexer.tokenize();
      final parser = PythonParser(tokens);
      final program = parser.parseProgram();
      final interpreter = PythonInterpreter();
      final output = interpreter.interpret(program);
      return CompilerResult.success(output);
    } on FormatException catch (e) {
      return CompilerResult.failure(e.message);
    } catch (e) {
      return CompilerResult.failure('Hindi inaasahang error: $e');
    }
  }

  static CompilerResult runJsCode(String code) {
    try {
      final lexer = JsLexer(code);
      final tokens = lexer.tokenize();
      final parser = JsParser(tokens);
      final program = parser.parseProgram();
      final interpreter = JsInterpreter();
      final output = interpreter.interpret(program);
      return CompilerResult.success(output);
    } on FormatException catch (e) {
      return CompilerResult.failure(e.message);
    } catch (e) {
      return CompilerResult.failure('Hindi inaasahang error: $e');
    }
  }

  static CompilerResult runCsCode(String code) {
    try {
      final lexer = CsLexer(code);
      final tokens = lexer.tokenize();
      final parser = CsParser(tokens);
      final program = parser.parseProgram();
      final interpreter = CsInterpreter();
      final output = interpreter.interpret(program);
      return CompilerResult.success(output);
    } on FormatException catch (e) {
      return CompilerResult.failure(e.message);
    } catch (e) {
      return CompilerResult.failure('Hindi inaasahang error: $e');
    }
  }

  static CompilerResult runPhpCode(String code) {
    try {
      final lexer = PhpLexer(code);
      final tokens = lexer.tokenize();
      final parser = PhpParser(tokens);
      final program = parser.parseProgram();
      final interpreter = PhpInterpreter();
      final output = interpreter.interpret(program);
      return CompilerResult.success(output);
    } on FormatException catch (e) {
      return CompilerResult.failure(e.message);
    } catch (e) {
      return CompilerResult.failure('Hindi inaasahang error: $e');
    }
  }

  /// Tinatakbo lang ang LEXER (hindi na hanggang Parser/Interpreter) para
  /// makuha ang listahan ng tokens — gamit ito ng Token Visualizer sa UI.
  /// "languageKey" ay isa sa: 'java', 'cpp', 'python', 'javascript',
  /// 'csharp', 'php'.
  static List<TokenDisplay> tokenizeForLanguage(
    String code,
    String languageKey,
  ) {
    switch (languageKey) {
      case 'java':
        return JavaLexer(code)
            .tokenize()
            .map((t) => TokenDisplay(t.type.name, t.lexeme, t.line))
            .toList();
      case 'cpp':
        return CppLexer(code)
            .tokenize()
            .map((t) => TokenDisplay(t.type.name, t.lexeme, t.line))
            .toList();
      case 'python':
        return PythonLexer(code)
            .tokenize()
            .map((t) => TokenDisplay(t.type.name, t.lexeme, t.line))
            .toList();
      case 'javascript':
        return JsLexer(code)
            .tokenize()
            .map((t) => TokenDisplay(t.type.name, t.lexeme, t.line))
            .toList();
      case 'csharp':
        return CsLexer(code)
            .tokenize()
            .map((t) => TokenDisplay(t.type.name, t.lexeme, t.line))
            .toList();
      case 'php':
        return PhpLexer(code)
            .tokenize()
            .map((t) => TokenDisplay(t.type.name, t.lexeme, t.line))
            .toList();
      default:
        return [];
    }
  }
}
