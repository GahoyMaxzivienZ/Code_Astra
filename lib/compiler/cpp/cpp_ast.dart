/// Base class ng lahat ng AST nodes
abstract class CppNode {}

/// Ang buong program: listahan ng functions (kasama si "main")
/// Walang "class wrapper" dito, kaya't ito ang top-level structure
/// (magkaiba sa Java na naka-loob lahat sa isang class).
class ProgramNode extends CppNode {
  final List<FunctionNode> functions;
  ProgramNode(this.functions);
}

/// Isang parameter ng function, hal. "int a"
class ParamNode extends CppNode {
  final String paramType;
  final String name;
  ParamNode(this.paramType, this.name);
}

/// int add(int a, int b) { ... }
/// int main() { ... }
class FunctionNode extends CppNode {
  final String returnType; // "void" o "int"
  final String name;
  final List<ParamNode> params;
  final List<StatementNode> body;

  FunctionNode(this.returnType, this.name, this.params, this.body);
}

/// Base class ng lahat ng statements
abstract class StatementNode extends CppNode {}

/// cout << expr1 << expr2 << endl;
/// (endl ay kino-convert na StringLiteralNode('\n') sa Parser mismo)
class CoutStatementNode extends StatementNode {
  final List<ExpressionNode> parts;
  CoutStatementNode(this.parts);
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

/// return expression; (o "return;" kung void)
class ReturnStatementNode extends StatementNode {
  final ExpressionNode? value;
  ReturnStatementNode(this.value);
}

/// isang expression na tumatayong statement, hal. "add(2, 3);"
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
abstract class ExpressionNode extends CppNode {}

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
