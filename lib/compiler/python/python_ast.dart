/// Base class ng lahat ng AST nodes
abstract class PythonNode {}

/// Ang buong program: listahan ng top-level statements, na direktang
/// isinasagawa mula taas hanggang baba (tulad ng totoong Python script —
/// walang kailangang "main" function).
class ProgramNode extends PythonNode {
  final List<StatementNode> statements;
  ProgramNode(this.statements);
}

/// Base class ng lahat ng statements
abstract class StatementNode extends PythonNode {}

/// def add(a, b):
///     return a + b
class FunctionDefNode extends StatementNode {
  final String name;
  final List<String> params; // walang type — dynamically typed si Python
  final List<StatementNode> body;
  FunctionDefNode(this.name, this.params, this.body);
}

/// x = 5   (parehong ginagamit para sa unang pag-declare at reassignment,
/// dahil walang hiwalay na "type" na kailangang isulat sa Python)
class AssignmentStatementNode extends StatementNode {
  final String name;
  final ExpressionNode value;
  AssignmentStatementNode(this.name, this.value);
}

/// print(expr1, expr2, ...)
class PrintStatementNode extends StatementNode {
  final List<ExpressionNode> args;
  PrintStatementNode(this.args);
}

/// if condition:
///     ...
/// else:
///     ...
class IfStatementNode extends StatementNode {
  final ExpressionNode condition;
  final List<StatementNode> thenBranch;
  final List<StatementNode>? elseBranch;
  IfStatementNode(this.condition, this.thenBranch, this.elseBranch);
}

/// while condition:
///     ...
class WhileStatementNode extends StatementNode {
  final ExpressionNode condition;
  final List<StatementNode> body;
  WhileStatementNode(this.condition, this.body);
}

/// for i in range(start, end):
///     ...
/// (rangeArgs: 1 argument = range(end), 2 arguments = range(start, end))
class ForRangeStatementNode extends StatementNode {
  final String varName;
  final List<ExpressionNode> rangeArgs;
  final List<StatementNode> body;
  ForRangeStatementNode(this.varName, this.rangeArgs, this.body);
}

/// return expression  (o "return" lang, walang value)
class ReturnStatementNode extends StatementNode {
  final ExpressionNode? value;
  ReturnStatementNode(this.value);
}

/// break  — lumalabas agad sa pinakamalapit na loop
class BreakStatementNode extends StatementNode {
  BreakStatementNode();
}

/// continue  — lumalaktaw sa susunod na iteration ng pinakamalapit na loop
class ContinueStatementNode extends StatementNode {
  ContinueStatementNode();
}

/// isang expression na tumatayong statement, hal. standalone function call
class ExpressionStatementNode extends StatementNode {
  final ExpressionNode expression;
  ExpressionStatementNode(this.expression);
}

/// Base class ng lahat ng expressions
abstract class ExpressionNode extends PythonNode {}

class StringLiteralNode extends ExpressionNode {
  final String value;
  StringLiteralNode(this.value);
}

class NumberLiteralNode extends ExpressionNode {
  final int value;
  NumberLiteralNode(this.value);
}

class IdentifierNode extends ExpressionNode {
  final String name;
  IdentifierNode(this.name);
}

/// left operator right, hal. 5 + 3, x > 2
class BinaryExpressionNode extends ExpressionNode {
  final ExpressionNode left;
  final String operator;
  final ExpressionNode right;
  BinaryExpressionNode(this.left, this.operator, this.right);
}

/// unary operator, hal. not x
class UnaryExpressionNode extends ExpressionNode {
  final String operator; // sa ngayon: 'not'
  final ExpressionNode operand;
  UnaryExpressionNode(this.operator, this.operand);
}

/// pagtawag sa isang function, hal. add(2, 3)
class CallExpressionNode extends ExpressionNode {
  final String name;
  final List<ExpressionNode> arguments;
  CallExpressionNode(this.name, this.arguments);
}
