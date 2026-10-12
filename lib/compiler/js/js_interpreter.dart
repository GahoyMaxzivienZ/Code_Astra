import 'js_ast.dart';

class _ReturnSignal implements Exception {
  final dynamic value;
  _ReturnSignal(this.value);
}

class JsInterpreter {
  final StringBuffer _output = StringBuffer();

  // ---------- Mga helper (formatting, operators, safety limits) ----------

  static const Map<String, dynamic> _builtinLiterals = {'true': true, 'false': false, 'null': null, 'undefined': null};
  int _totalIterations = 0;
  int _callDepth = 0;

  /// Paano ipi-print ang isang value sa language na ito.
  String _fmt(dynamic v) => v == null ? 'undefined' : v.toString();

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

  /// Ang "/" sa JavaScript/PHP ay tunay na division (7 / 2 = 3.5). Kung
  /// buo ang resulta, ibinabalik bilang int para "3" ang lumabas at hindi "3.0".
  dynamic _divide(dynamic l, dynamic r) {
    final result = l / r;
    return result == result.truncateToDouble() ? result.toInt() : result;
  }
  final Map<String, FunctionDeclarationNode> _functions = {};

  late Map<String, dynamic> _globalEnv;

  String interpret(ProgramNode program) {
    // "Function hoisting" — parehong konsepto ng totoong JavaScript:
    // lahat ng function declarations ay "nakikita" na bago pa man
    // umandar ang unang linya ng code, kaya pwede mo tawagin ang
    // isang function kahit na-declare pa lang ito sa ibaba.
    for (final statement in program.statements) {
      if (statement is FunctionDeclarationNode) {
        _functions[statement.name] = statement;
      }
    }

    final env = <String, dynamic>{};
    _globalEnv = env;
    try {
      for (final statement in program.statements) {
        if (statement is FunctionDeclarationNode) {
          continue; // na-hoist na, i-skip na lang sa sequential execution
        }
        _executeStatement(statement, env);
      }
    } on _ReturnSignal {
      throw FormatException('Hindi pwedeng gamitin ang "return" sa labas ng function.');
    }

    return _output.toString();
  }

  void _executeBlock(List<StatementNode> statements, Map<String, dynamic> env) {
    for (final statement in statements) {
      _executeStatement(statement, env);
    }
  }

  void _executeStatement(StatementNode statement, Map<String, dynamic> env) {
    if (statement is ConsoleLogStatementNode) {
      final parts = statement.args
          .map((e) => _fmt(_evaluateExpression(e, env)))
          .toList();
      _output.writeln(parts.join(' '));
    } else if (statement is VariableDeclarationNode) {
      final value = _evaluateExpression(statement.initializer, env);
      env[statement.name] = value;
    } else if (statement is AssignmentStatementNode) {
      // Puwedeng i-assign ang variable ng loob ng function kung "let" ito sa labas
      final target = env.containsKey(statement.name)
          ? env
          : (_globalEnv.containsKey(statement.name) ? _globalEnv : null);
      if (target == null) {
        throw FormatException(
          'Hindi kilalang variable na "${statement.name}". Siguraduhing na-declare mo na ito (gamit "let") bago i-assign.',
        );
      }
      final value = _evaluateExpression(statement.value, env);
      target[statement.name] = value;
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
    } else if (statement is FunctionDeclarationNode) {
      // na-hoist na sa simula ng interpret(), wala nang gagawin dito
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
          _globalEnv.containsKey(expression.name)) {
        return _globalEnv[expression.name];
      }
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
          return _divide(left, right);
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
    final function = _functions[call.name];
    if (function == null) {
      throw FormatException('Hindi kilalang function na "${call.name}".');
    }
    if (call.arguments.length != function.params.length) {
      throw FormatException(
        'Ang function na "${call.name}" ay umaasa ng ${function.params.length} argumento, pero ${call.arguments.length} ang ibinigay.',
      );
    }

    final newEnv = <String, dynamic>{};
    for (var i = 0; i < function.params.length; i++) {
      newEnv[function.params[i]] = _evaluateExpression(call.arguments[i], callerEnv);
    }

    _callDepth++;
    if (_callDepth > 500) {
      _callDepth = 0;
      throw FormatException(
        'Sobrang lalim ng recursion (higit 500 na nested na tawag) — baka walang base case ang function mo.',
      );
    }
    try {
      _executeBlock(function.body, newEnv);
    } on _ReturnSignal catch (signal) {
      return signal.value;
    } finally {
      if (_callDepth > 0) _callDepth--;
    }

    return null;
  }
}
