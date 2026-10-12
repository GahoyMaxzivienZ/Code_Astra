/// Base class ng lahat ng AST nodes
abstract class PhpNode {}

/// Ang buong program: listahan ng top-level statements, direktang
/// isinasagawa mula taas hanggang baba (parehong konsepto ng script).
class ProgramNode extends PhpNode {
  final List<StatementNode> statements;
  ProgramNode(this.statements);
}

/// Base class ng lahat ng statements
abstract class StatementNode extends PhpNode {}

/// function add($a, $b) { return $a + $b; }
class FunctionDeclarationNode extends StatementNode {
  final String name; // walang "$" — pangalan ng function
  final List<String> params; // may "$" — pangalan ng mga parameters
  final List<StatementNode> body;
  FunctionDeclarationNode(this.name, this.params, this.body);
}

/// $x = 5;  (unang pag-declare man o reassignment, parehong syntax)
class AssignmentStatementNode extends StatementNode {
  final String name; // may "$" kasama
  final ExpressionNode value;
  AssignmentStatementNode(this.name, this.value);
}

/// echo $expr1, $expr2, ...;
class EchoStatementNode extends StatementNode {
  final List<ExpressionNode> args;
  EchoStatementNode(this.args);
}

/// if ($condition) { ... } else { ... }
class IfStatementNode extends StatementNode {
  final ExpressionNode condition;
  final List<StatementNode> thenBranch;
  final List<StatementNode>? elseBranch;
  IfStatementNode(this.condition, this.thenBranch, this.elseBranch);
}

/// while ($condition) { ... }
class WhileStatementNode extends StatementNode {
  final ExpressionNode condition;
  final List<StatementNode> body;
  WhileStatementNode(this.condition, this.body);
}

/// return $expression;
class ReturnStatementNode extends StatementNode {
  final ExpressionNode? value;
  ReturnStatementNode(this.value);
}

/// isang expression na tumatayong statement (hal. standalone function call)
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
abstract class ExpressionNode extends PhpNode {}

class StringLiteralNode extends ExpressionNode {
  final String value;
  StringLiteralNode(this.value);
}

class NumberLiteralNode extends ExpressionNode {
  final int value;
  NumberLiteralNode(this.value);
}

/// Reference sa isang variable, hal. "$x" — kasama ang "$" sa pangalan
class IdentifierNode extends ExpressionNode {
  final String name;
  IdentifierNode(this.name);
}

class BinaryExpressionNode extends ExpressionNode {
  final ExpressionNode left;
  final String operator;
  final ExpressionNode right;
  BinaryExpressionNode(this.left, this.operator, this.right);
}

/// pagtawag sa isang function, hal. add($x, $y) — walang "$" ang pangalan
/// ng function mismo, "$" lang ang laman ng mga arguments
class CallExpressionNode extends ExpressionNode {
  final String name;
  final List<ExpressionNode> arguments;
  CallExpressionNode(this.name, this.arguments);
}
