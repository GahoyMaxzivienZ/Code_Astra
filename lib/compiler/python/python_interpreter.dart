import 'dart:math' show pow;

import 'python_ast.dart';

class _ReturnSignal implements Exception {
  final dynamic value;
  _ReturnSignal(this.value);
}

class _BreakSignal implements Exception {
  const _BreakSignal();
}

class _ContinueSignal implements Exception {
  const _ContinueSignal();
}

class PythonInterpreter {
  final StringBuffer _output = StringBuffer();

  // ---------- Mga helper (formatting, operators, safety limits) ----------

  static const Map<String, dynamic> _builtinLiterals = {
    'True': true,
    'False': false,
    'None': null,
  };
  int _totalIterations = 0;
  int _callDepth = 0;

  /// Paano ipi-print ang isang value sa language na ito.
  String _fmt(dynamic v) =>
      v == null ? 'None' : (v is bool ? (v ? 'True' : 'False') : v.toString());

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

  void _requireBool(dynamic v, String op) {
    if (v is! bool) {
      throw FormatException(
        'Boolean (True/False) lang ang puwedeng gamitin sa \"$op\", pero ${_typeName(v)} ang ibinigay. Gumamit ng comparison, hal. x > 5 $op y < 10.',
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

  /// "+" sa Python: numero + numero, o string + string. Ang pagsasama ng
  /// string at numero ay TypeError (kailangan ng str()).
  dynamic _add(dynamic l, dynamic r) {
    if (l is String && r is String) return l + r;
    if (l is num && r is num) return l + r;
    throw FormatException(
      'TypeError: hindi mo pwedeng i-"+" ang ${_typeName(l)} at ${_typeName(r)}. '
      'Sa Python, ilagay sila bilang magkahiwalay na argument sa print(), hal. print("Sum:", total).',
    );
  }

  final Map<String, FunctionDefNode> _functions = {};

  late Map<String, dynamic> _globalEnv;

  String interpret(ProgramNode program) {
    final globalEnv = <String, dynamic>{};
    _globalEnv = globalEnv;
    try {
      _executeBlock(program.statements, globalEnv);
    } on _ReturnSignal {
      throw FormatException(
        'Hindi pwedeng gamitin ang "return" sa labas ng function.',
      );
    }
    return _output.toString();
  }

  void _executeBlock(List<StatementNode> statements, Map<String, dynamic> env) {
    for (final statement in statements) {
      _executeStatement(statement, env);
    }
  }

  void _executeStatement(StatementNode statement, Map<String, dynamic> env) {
    if (statement is FunctionDefNode) {
      // "Irerehistro" lang ang function habang umaabot dito ang execution
      // — parehas ito ng totoong Python behavior (top-to-bottom).
      _functions[statement.name] = statement;
    } else if (statement is PrintStatementNode) {
      final parts = statement.args
          .map((e) => _fmt(_evaluateExpression(e, env)))
          .toList();
      _output.writeln(parts.join(' '));
    } else if (statement is AssignmentStatementNode) {
      env[statement.name] = _evaluateExpression(statement.value, env);
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

        try {
          _executeBlock(statement.body, env);
        } on _BreakSignal {
          break;
        } on _ContinueSignal {
          // tuloy sa susunod na iteration (bibilangin pa rin sa limit)
        }

        iterations++;
        _countIteration();
        if (iterations > 100000) {
          throw FormatException(
            'Sobra na sa 100,000 iterations ang while loop mo — baka infinite loop ito.',
          );
        }
      }
    } else if (statement is ForRangeStatementNode) {
      final argValues = statement.rangeArgs
          .map((e) => _evaluateExpression(e, env))
          .toList();

      if (argValues.isEmpty || argValues.length > 3) {
        throw FormatException(
          'Kailangan ng 1 hanggang 3 argumento ang range(): range(end), range(start, end), o range(start, end, step).',
        );
      }
      if (argValues.any((v) => v is! int)) {
        throw FormatException(
          'Buong numero (int) lang ang puwedeng gamitin sa range().',
        );
      }
      var start = 0;
      int end;
      var step = 1;
      if (argValues.length == 1) {
        end = argValues[0] as int;
      } else {
        start = argValues[0] as int;
        end = argValues[1] as int;
        if (argValues.length == 3) step = argValues[2] as int;
      }
      if (step == 0) {
        throw FormatException('Hindi pwedeng 0 ang step ng range().');
      }

      var iterations = 0;
      for (var i = start; step > 0 ? i < end : i > end; i += step) {
        env[statement.varName] = i;
        try {
          _executeBlock(statement.body, env);
        } on _BreakSignal {
          break;
        } on _ContinueSignal {
          // tuloy sa susunod na iteration (bibilangin pa rin sa limit)
        }

        iterations++;
        _countIteration();
        if (iterations > 100000) {
          throw FormatException(
            'Sobra na sa 100,000 iterations ang for loop mo.',
          );
        }
      }
    } else if (statement is ReturnStatementNode) {
      final value = statement.value != null
          ? _evaluateExpression(statement.value!, env)
          : null;
      throw _ReturnSignal(value);
    } else if (statement is BreakStatementNode) {
      throw const _BreakSignal();
    } else if (statement is ContinueStatementNode) {
      throw const _ContinueSignal();
    } else if (statement is ExpressionStatementNode) {
      _evaluateExpression(statement.expression, env);
    } else {
      throw FormatException('Hindi pa suportado ang statement type na ito.');
    }
  }

  dynamic _evaluateExpression(
    ExpressionNode expression,
    Map<String, dynamic> env,
  ) {
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
          'Hindi kilalang variable na "${expression.name}". Siguraduhing na-assign mo na ito bago gamitin.',
        );
      }
      return env[expression.name];
    }
    if (expression is UnaryExpressionNode) {
      final value = _evaluateExpression(expression.operand, env);
      if (value is! bool) {
        throw FormatException(
          'Boolean (True/False) lang ang puwedeng gamitin sa \"not\", pero ${_typeName(value)} ang ibinigay. Gumamit ng comparison, hal. not (x > 5).',
        );
      }
      return !value;
    }
    if (expression is BinaryExpressionNode &&
        (expression.operator == 'and' || expression.operator == 'or')) {
      final isAnd = expression.operator == 'and';
      final left = _evaluateExpression(expression.left, env);
      _requireBool(left, expression.operator);
      // Short-circuit: kapag False na ang kaliwa ng "and" (o True na ang
      // kaliwa ng "or"), hindi na ie-evaluate ang kanan.
      if (isAnd && left == false) return false;
      if (!isAnd && left == true) return true;
      final right = _evaluateExpression(expression.right, env);
      _requireBool(right, expression.operator);
      return right;
    }
    if (expression is BinaryExpressionNode) {
      final left = _evaluateExpression(expression.left, env);
      final right = _evaluateExpression(expression.right, env);

      final op = expression.operator;
      if (op == '-' ||
          op == '*' ||
          op == '/' ||
          op == '%' ||
          op == '//' ||
          op == '**') {
        if (!(op == '*' &&
            ((left is String && right is int) ||
                (left is int && right is String)))) {
          _requireNumbers(left, right, op);
        }
      }

      switch (op) {
        case '+':
          return _add(left, right);
        case '-':
          return left - right;
        case '*':
          if (left is String && right is int) return left * right;
          if (left is int && right is String) return right * left;
          return left * right;
        case '/':
          if (right == 0) {
            throw FormatException(
              'ZeroDivisionError: hindi pwede mag-divide ng 0.',
            );
          }
          return left / right; // sa Python 3, laging float ang resulta ng /
        case '//':
          if (right == 0) {
            throw FormatException(
              'ZeroDivisionError: hindi pwede mag-divide ng 0.',
            );
          }
          if (left is int && right is int) return (left / right).floor();
          return (left / right).floorToDouble();
        case '%':
          if (right == 0) {
            throw FormatException(
              'ZeroDivisionError: hindi pwede mag-divide ng 0.',
            );
          }
          var m = left % right;
          if (m != 0 && right < 0)
            m += right; // sign ng divisor, gaya ng Python
          return m;
        case '**':
          if (left is int && right is int && right >= 0) {
            var result = 1;
            for (var i = 0; i < right; i++) {
              result *= left;
            }
            return result;
          }
          return pow(left, right);
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

  dynamic _callFunction(
    CallExpressionNode call,
    Map<String, dynamic> callerEnv,
  ) {
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
      newEnv[function.params[i]] = _evaluateExpression(
        call.arguments[i],
        callerEnv,
      );
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
