/// Base class ng lahat ng AST nodes
abstract class JavaNode {}

/// Ang buong program: isang class, may listahan ng methods
/// (kasama si "main" at ang mga custom functions)
class ProgramNode extends JavaNode {
  final String className;
  final List<MethodNode> methods;

  ProgramNode(this.className, this.methods);
}

/// Isang parameter ng function, hal. "int a" sa loob ng add(int a, int b)
class ParamNode extends JavaNode {
  final String paramType;
  final String name;
  ParamNode(this.paramType, this.name);
}

/// public static int add(int a, int b) { ... }
/// public static void main(String[] args) { ... }
class MethodNode extends JavaNode {
  final String returnType; // "void" o "int"
  final String name;
  final List<ParamNode> params;
  final List<StatementNode> body;

  MethodNode(this.returnType, this.name, this.params, this.body);
}

/// Base class ng lahat ng statements
abstract class StatementNode extends JavaNode {}

/// System.out.println(expression);
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

/// x = x + 1;  (reassignment sa existing variable, walang type sa harap)
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

/// return expression;  (o "return;" kung walang value)
class ReturnStatementNode extends StatementNode {
  final ExpressionNode? value;
  ReturnStatementNode(this.value);
}

/// isang expression na tumatayong statement, hal. "add(2, 3);" mag-isa sa isang line
class ExpressionStatementNode extends StatementNode {
  final ExpressionNode expression;
  ExpressionStatementNode(this.expression);
}

/// Internal helper: pinagsasama ang ilang statements para maging "isa"
/// (ginagamit ng for-loop desugaring sa parser)
class BlockWrapperNode extends StatementNode {
  final List<StatementNode> statements;
  BlockWrapperNode(this.statements);
}

/// Base class ng lahat ng expressions
abstract class ExpressionNode extends JavaNode {}

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

/// left operator right, hal. 5 + 3, x > 2, x == 5
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
