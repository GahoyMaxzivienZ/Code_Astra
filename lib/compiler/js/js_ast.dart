/// Base class ng lahat ng AST nodes
abstract class JsNode {}

/// Ang buong program: listahan ng top-level statements — direktang
/// isinasagawa mula taas hanggang baba (parehong konsepto ng script,
/// tulad ng Python), walang kailangang "main".
class ProgramNode extends JsNode {
  final List<StatementNode> statements;
  ProgramNode(this.statements);
}

/// Base class ng lahat ng statements
abstract class StatementNode extends JsNode {}

/// function add(a, b) { return a + b; }
class FunctionDeclarationNode extends StatementNode {
  final String name;
  final List<String> params; // walang type, dynamically typed si JS
  final List<StatementNode> body;
  FunctionDeclarationNode(this.name, this.params, this.body);
}

/// let x = 5;
class VariableDeclarationNode extends StatementNode {
  final String name;
  final ExpressionNode initializer;
  VariableDeclarationNode(this.name, this.initializer);
}

/// x = x + 1;
class AssignmentStatementNode extends StatementNode {
  final String name;
  final ExpressionNode value;
  AssignmentStatementNode(this.name, this.value);
}

/// console.log(expr1, expr2, ...)
class ConsoleLogStatementNode extends StatementNode {
  final List<ExpressionNode> args;
  ConsoleLogStatementNode(this.args);
}

/// if (condition) { ... } else { ... }
class IfStatementNode extends StatementNode {
  final ExpressionNode condition;
  final List<StatementNode> thenBranch;
  final List<StatementNode>? elseBranch;
  IfStatementNode(this.condition, this.thenBranch, this.elseBranch);
}

/// while (condition) { ... }
class WhileStatementNode extends StatementNode {
  final ExpressionNode condition;
  final List<StatementNode> body;
  WhileStatementNode(this.condition, this.body);
}

/// return expression; (o "return;" kung walang value)
class ReturnStatementNode extends StatementNode {
  final ExpressionNode? value;
  ReturnStatementNode(this.value);
}

/// isang expression na tumatayong statement, hal. standalone function call
class ExpressionStatementNode extends StatementNode {
  final ExpressionNode expression;
  ExpressionStatementNode(this.expression);
}

/// Internal helper: pinagsasama ang init + while ng for-loop desugaring
class BlockWrapperNode extends StatementNode {
  final List<StatementNode> statements;
  BlockWrapperNode(this.statements);
}

/// Base class ng lahat ng expressions
abstract class ExpressionNode extends JsNode {}

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

/// pagtawag sa isang function, hal. add(2, 3)
class CallExpressionNode extends ExpressionNode {
  final String name;
  final List<ExpressionNode> arguments;
  CallExpressionNode(this.name, this.arguments);
}
