/// Base class ng lahat ng AST nodes
abstract class CsNode {}

/// Ang buong program: isang class, may listahan ng methods
class ProgramNode extends CsNode {
  final String className;
  final List<MethodNode> methods;
  ProgramNode(this.className, this.methods);
}

/// Isang parameter ng method, hal. "int a"
class ParamNode extends CsNode {
  final String paramType;
  final String name;
  ParamNode(this.paramType, this.name);
}

/// static int Add(int a, int b) { ... }
/// static void Main(string[] args) { ... }
class MethodNode extends CsNode {
  final String returnType; // "void" o "int"
  final String name;
  final List<ParamNode> params;
  final List<StatementNode> body;
  MethodNode(this.returnType, this.name, this.params, this.body);
}

/// Base class ng lahat ng statements
abstract class StatementNode extends CsNode {}

/// Console.WriteLine(expression);
class PrintStatementNode extends StatementNode {
  final ExpressionNode argument;
  PrintStatementNode(this.argument);
}

/// int x = 5;
class VariableDeclarationNode extends StatementNode {
  final String varType;
  final String name;
  final ExpressionNode initializer;
  VariableDeclarationNode(this.varType, this.name, this.initializer);
}

/// x = x + 1;
class AssignmentStatementNode extends StatementNode {
  final String name;
  final ExpressionNode value;
  AssignmentStatementNode(this.name, this.value);
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

/// return expression;
class ReturnStatementNode extends StatementNode {
  final ExpressionNode? value;
  ReturnStatementNode(this.value);
}

/// isang expression na tumatayong statement
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
abstract class ExpressionNode extends CsNode {}

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

class BinaryExpressionNode extends ExpressionNode {
  final ExpressionNode left;
  final String operator;
  final ExpressionNode right;
  BinaryExpressionNode(this.left, this.operator, this.right);
}

class CallExpressionNode extends ExpressionNode {
  final String name;
  final List<ExpressionNode> arguments;
  CallExpressionNode(this.name, this.arguments);
}
