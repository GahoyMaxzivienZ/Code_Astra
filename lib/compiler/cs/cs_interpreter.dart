import 'cs_ast.dart';

class _ReturnSignal implements Exception {
  final dynamic value;
  _ReturnSignal(this.value);
}

class CsInterpreter {
  final StringBuffer _output = StringBuffer();

  // ---------- Mga helper (formatting, operators, safety limits) ----------

  static const Map<String, dynamic> _builtinLiterals = {'true': true, 'false': false, 'null': null};
  int _totalIterations = 0;
  int _callDepth = 0;

  /// Paano ipi-print ang isang value sa language na ito.
  String _fmt(dynamic v) => v == null ? '' : (v is bool ? (v ? 'True' : 'False') : v.toString());

  String _typeName(dynamic v) {
    if (v is String) return 'string';
    if (v is bool) return 'boolean';
    if (v is int || v is double) return 'number';
    return 'wala (null)';
  }

  void _countIteration() {
    _totalIterations++;
    if (_totalIterations > 500000) {
      throw FormatException(
        'Sobra na sa 500,000 na kabuuang iterations ang program mo — baka infinite loop o masyadong malaki ang nested loops.',
      );
    }
  }

  void _requireNumbers(dynamic l, dynamic r, String op) {
    if (l is! num || r is! num) {
      throw FormatException(
        'Hindi pwedeng gamitin ang "$op" sa ${_typeName(l)} at ${_typeName(r)}. Numero lang ang puwedeng i-"$op".',
      );
    }
  }

  /// "+" — pagdugtong kung may string sa isa (hal. "Sum: " + 42), kung hindi
  /// ay addition ng dalawang numero.
  dynamic _add(dynamic l, dynamic r) {
    if (l is String || r is String) return _fmt(l) + _fmt(r);
    _requireNumbers(l, r, '+');
    return l + r;
  }
  late Map<String, MethodNode> _methods;

  String interpret(ProgramNode program) {
    _methods = {for (final m in program.methods) m.name: m};

    final main = _methods['Main'];
    if (main == null) {
      throw FormatException(
        'Walang Main method na nahanap. Kailangan may "static void Main(string[] args)".',
      );
    }

    final env = <String, dynamic>{};
    try {
      _executeBlock(main.body, env);
    } on _ReturnSignal catch (_) {
      // ok lang, maagang natapos ang Main via "return;"
    }

    return _output.toString();
  }

  void _executeBlock(List<StatementNode> statements, Map<String, dynamic> env) {
    for (final statement in statements) {
      _executeStatement(statement, env);
    }
  }

  void _executeStatement(StatementNode statement, Map<String, dynamic> env) {
    if (statement is PrintStatementNode) {
      final value = _evaluateExpression(statement.argument, env);
      _output.writeln(_fmt(value));
    } else if (statement is VariableDeclarationNode) {
      final value = _evaluateExpression(statement.initializer, env);
      env[statement.name] = value;
    } else if (statement is AssignmentStatementNode) {
      if (!env.containsKey(statement.name)) {
        throw FormatException(
          'Hindi kilalang variable na "${statement.name}". Siguraduhing na-declare mo na ito bago i-assign.',
        );
      }
      final value = _evaluateExpression(statement.value, env);
      env[statement.name] = value;
    } else if (statement is IfStatementNode) {
      final condition = _evaluateExpression(statement.condition, env);
      if (condition is! bool) {
        throw FormatException(
          'Kailangang boolean (resulta ng comparison tulad ng x > 5) ang condition ng if statement.',
        );
      }
      if (condition) {
        _executeBlock(statement.thenBranch, env);
      } else if (statement.elseBranch != null) {
        _executeBlock(statement.elseBranch!, env);
      }
    } else if (statement is WhileStatementNode) {
      var iterations = 0;
      while (true) {
        final condition = _evaluateExpression(statement.condition, env);
        if (condition is! bool) {
          throw FormatException(
            'Kailangang boolean (resulta ng comparison tulad ng x < 10) ang condition ng while statement.',
          );
        }
        if (!condition) break;

        _executeBlock(statement.body, env);

        iterations++;
        _countIteration();
        if (iterations > 100000) {
          throw FormatException(
            'Sobra na sa 100,000 iterations ang while loop mo — baka infinite loop ito.',
          );
        }
      }
    } else if (statement is BlockWrapperNode) {
      _executeBlock(statement.statements, env);
    } else if (statement is ReturnStatementNode) {
      final value = statement.value != null
          ? _evaluateExpression(statement.value!, env)
          : null;
      throw _ReturnSignal(value);
    } else if (statement is ExpressionStatementNode) {
      _evaluateExpression(statement.expression, env);
    } else {
      throw FormatException('Hindi pa suportado ang statement type na ito.');
    }
  }

  dynamic _evaluateExpression(ExpressionNode expression, Map<String, dynamic> env) {
    if (expression is StringLiteralNode) {
      return expression.value;
    }
    if (expression is NumberLiteralNode) {
      return expression.value;
    }
    if (expression is IdentifierNode) {
      if (!env.containsKey(expression.name) &&
          _builtinLiterals.containsKey(expression.name)) {
        return _builtinLiterals[expression.name];
      }
      if (!env.containsKey(expression.name)) {
        throw FormatException(
          'Hindi kilalang variable na "${expression.name}". Siguraduhing na-declare mo na ito bago gamitin.',
        );
      }
      return env[expression.name];
    }
    if (expression is BinaryExpressionNode) {
      final left = _evaluateExpression(expression.left, env);
      final right = _evaluateExpression(expression.right, env);

      final op = expression.operator;
      if (op == '-' || op == '*' || op == '/' || op == '%') {
        _requireNumbers(left, right, op);
      }

      switch (op) {
        case '+':
          return _add(left, right);
        case '-':
          return left - right;
        case '*':
          return left * right;
        case '/':
          if (right == 0) {
            throw FormatException('Hindi pwede mag-divide ng 0.');
          }
          return left ~/ right; // integer division (int lang ang suportado)
        case '%':
          if (right == 0) {
            throw FormatException('Hindi pwede mag-divide ng 0 (modulo).');
          }
          return left.remainder(right);
        case '>':
          return left > right;
        case '<':
          return left < right;
        case '>=':
          return left >= right;
        case '<=':
          return left <= right;
        case '==':
          return left == right;
        case '!=':
          return left != right;
        default:
          throw FormatException(
            'Hindi kilalang operator na "${expression.operator}".',
          );
      }
    }
    if (expression is CallExpressionNode) {
      return _callFunction(expression, env);
    }
    throw FormatException('Hindi pa suportado ang expression type na ito.');
  }

  dynamic _callFunction(CallExpressionNode call, Map<String, dynamic> callerEnv) {
    final method = _methods[call.name];
    if (method == null) {
      throw FormatException('Hindi kilalang function na "${call.name}".');
    }
    if (call.arguments.length != method.params.length) {
      throw FormatException(
        'Ang function na "${call.name}" ay umaasa ng ${method.params.length} argumento, pero ${call.arguments.length} ang ibinigay.',
      );
    }

    final newEnv = <String, dynamic>{};
    for (var i = 0; i < method.params.length; i++) {
      newEnv[method.params[i].name] = _evaluateExpression(call.arguments[i], callerEnv);
    }

    _callDepth++;
    if (_callDepth > 500) {
      _callDepth = 0;
      throw FormatException(
        'Sobrang lalim ng recursion (higit 500 na nested na tawag) — baka walang base case ang function mo.',
      );
    }
    try {
      _executeBlock(method.body, newEnv);
    } on _ReturnSignal catch (signal) {
      return signal.value;
    } finally {
      if (_callDepth > 0) _callDepth--;
    }

    return null;
  }
}
