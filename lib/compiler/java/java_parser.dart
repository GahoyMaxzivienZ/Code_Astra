import '../token.dart';
import 'java_token_type.dart';
import 'java_ast.dart';

class JavaParser {
  final List<Token<JavaTokenType>> tokens;
  int _pos = 0;

  JavaParser(this.tokens);

  ProgramNode parseProgram() {
    _expect(JavaTokenType.publicKw);
    _expect(JavaTokenType.classKw);
    final classNameToken = _expect(JavaTokenType.identifier);
    _expect(JavaTokenType.lbrace);

    final methods = <MethodNode>[];
    while (!_check(JavaTokenType.rbrace)) {
      methods.add(_parseMethod());
    }
    _expect(JavaTokenType.rbrace); // closing } ng class

    return ProgramNode(classNameToken.lexeme, methods);
  }

  // ---------- Methods / Functions ----------

  MethodNode _parseMethod() {
    _expect(JavaTokenType.publicKw);
    _expect(JavaTokenType.staticKw);

    String returnType;
    if (_check(JavaTokenType.voidKw)) {
      _advance();
      returnType = 'void';
    } else if (_check(JavaTokenType.intKw)) {
      _advance();
      returnType = 'int';
    } else {
      throw FormatException(
        'Inaasahan ang return type ("void" o "int") sa line ${_peek().line}, pero "${_peek().lexeme}" ang nakita.',
      );
    }

    final nameToken = _expect(JavaTokenType.identifier);
    _expect(JavaTokenType.lparen);

    final params = <ParamNode>[];
    if (nameToken.lexeme == 'main') {
      // special case: public static void main(String[] args)
      _expect(JavaTokenType.identifier); // "String"
      _expect(JavaTokenType.lbracket);
      _expect(JavaTokenType.rbracket);
      final argsToken = _expect(JavaTokenType.identifier); // "args"
      params.add(ParamNode('String[]', argsToken.lexeme));
    } else {
      if (!_check(JavaTokenType.rparen)) {
        params.add(_parseParam());
        while (_check(JavaTokenType.comma)) {
          _advance();
          params.add(_parseParam());
        }
      }
    }

    _expect(JavaTokenType.rparen);
    final body = _parseBlock();

    return MethodNode(returnType, nameToken.lexeme, params, body);
  }

  ParamNode _parseParam() {
    _expect(JavaTokenType.intKw); // sa ngayon, "int" type lang ang param
    final nameToken = _expect(JavaTokenType.identifier);
    return ParamNode('int', nameToken.lexeme);
  }

  // ---------- Blocks ----------

  List<StatementNode> _parseBlock() {
    _expect(JavaTokenType.lbrace);
    final statements = <StatementNode>[];
    while (!_check(JavaTokenType.rbrace)) {
      statements.add(_parseStatement());
    }
    _expect(JavaTokenType.rbrace);
    return statements;
  }

  // ---------- Statements ----------

  StatementNode _parseStatement() {
    if (_check(JavaTokenType.intKw)) {
      return _parseVariableDeclaration();
    }
    if (_check(JavaTokenType.ifKw)) {
      return _parseIfStatement();
    }
    if (_check(JavaTokenType.whileKw)) {
      return _parseWhileStatement();
    }
    if (_check(JavaTokenType.forKw)) {
      return _parseForStatement();
    }
    if (_check(JavaTokenType.returnKw)) {
      return _parseReturnStatement();
    }
    if (_check(JavaTokenType.identifier) && _peek().lexeme == 'System') {
      return _parsePrintStatement();
    }
    if (_check(JavaTokenType.identifier) &&
        _peekNext().type == JavaTokenType.lparen) {
      return _parseCallStatement();
    }
    if (_check(JavaTokenType.identifier)) {
      return _parseAssignmentStatement();
    }
    throw FormatException(
      'Hindi ma-parse ang statement sa line ${_peek().line}: hindi kilalang statement na nagsisimula sa "${_peek().lexeme}"',
    );
  }

  StatementNode _parseVariableDeclaration() {
    _expect(JavaTokenType.intKw);
    final nameToken = _expect(JavaTokenType.identifier);
    _expect(JavaTokenType.assign);
    final initializer = _parseComparison();
    _expect(JavaTokenType.semicolon);
    return VariableDeclarationNode('int', nameToken.lexeme, initializer);
  }

  StatementNode _parseAssignmentStatement() {
    final assignment = _parseAssignmentCore();
    _expect(JavaTokenType.semicolon);
    return assignment;
  }

  /// Sinusuportahan: x = expr, x += expr, x -= expr, x *= expr, x /= expr,
  /// x %= expr, x++, x--  (lahat ay ginagawang simpleng assignment).
  AssignmentStatementNode _parseAssignmentCore() {
    final nameToken = _expect(JavaTokenType.identifier);
    final opType = _peek().type;
    const compound = <JavaTokenType, String>{
      JavaTokenType.plus: '+',
      JavaTokenType.minus: '-',
      JavaTokenType.star: '*',
      JavaTokenType.slash: '/',
      JavaTokenType.percent: '%',
    };
    if (compound.containsKey(opType)) {
      final op = compound[opType]!;
      final next = _peekNext().type;
      if ((op == '+' || op == '-') && next == opType) {
        _advance();
        _advance();
        return AssignmentStatementNode(
          nameToken.lexeme,
          BinaryExpressionNode(
            IdentifierNode(nameToken.lexeme),
            op,
            NumberLiteralNode(1),
          ),
        );
      }
      if (next == JavaTokenType.assign) {
        _advance();
        _advance();
        final value = _parseComparison();
        return AssignmentStatementNode(
          nameToken.lexeme,
          BinaryExpressionNode(IdentifierNode(nameToken.lexeme), op, value),
        );
      }
    }
    _expect(JavaTokenType.assign);
    final value = _parseComparison();
    return AssignmentStatementNode(nameToken.lexeme, value);
  }

  StatementNode _parsePrintStatement() {
    _expect(JavaTokenType.identifier); // System
    _expect(JavaTokenType.dot);
    _expect(JavaTokenType.identifier); // out
    _expect(JavaTokenType.dot);
    final method = _expect(JavaTokenType.identifier); // println
    if (method.lexeme != 'println') {
      throw FormatException(
        'Inaasahan ang "println" pero "${method.lexeme}" ang nakita sa line ${method.line}',
      );
    }
    _expect(JavaTokenType.lparen);
    final argument = _parseComparison();
    _expect(JavaTokenType.rparen);
    _expect(JavaTokenType.semicolon);
    return PrintStatementNode(argument);
  }

  StatementNode _parseIfStatement() {
    _expect(JavaTokenType.ifKw);
    _expect(JavaTokenType.lparen);
    final condition = _parseComparison();
    _expect(JavaTokenType.rparen);
    final thenBranch = _parseBlock();

    List<StatementNode>? elseBranch;
    if (_check(JavaTokenType.elseKw)) {
      _advance();
      elseBranch = _check(JavaTokenType.ifKw)
          ? [_parseIfStatement()]
          : _parseBlock();
    }

    return IfStatementNode(condition, thenBranch, elseBranch);
  }

  StatementNode _parseWhileStatement() {
    _expect(JavaTokenType.whileKw);
    _expect(JavaTokenType.lparen);
    final condition = _parseComparison();
    _expect(JavaTokenType.rparen);
    final body = _parseBlock();
    return WhileStatementNode(condition, body);
  }

  StatementNode _parseForStatement() {
    _expect(JavaTokenType.forKw);
    _expect(JavaTokenType.lparen);

    final init = _parseVariableDeclaration(); // may kasama nang semicolon

    final condition = _parseComparison();
    _expect(JavaTokenType.semicolon);

    final update = _parseAssignmentCore();

    _expect(JavaTokenType.rparen);

    final body = _parseBlock();

    final whileBody = [...body, update];
    final whileLoop = WhileStatementNode(condition, whileBody);

    return BlockWrapperNode([init, whileLoop]);
  }

  StatementNode _parseReturnStatement() {
    _expect(JavaTokenType.returnKw);
    ExpressionNode? value;
    if (!_check(JavaTokenType.semicolon)) {
      value = _parseComparison();
    }
    _expect(JavaTokenType.semicolon);
    return ReturnStatementNode(value);
  }

  StatementNode _parseCallStatement() {
    final nameToken = _expect(JavaTokenType.identifier);
    _expect(JavaTokenType.lparen);
    final args = _parseArgumentList();
    _expect(JavaTokenType.rparen);
    _expect(JavaTokenType.semicolon);
    return ExpressionStatementNode(CallExpressionNode(nameToken.lexeme, args));
  }

  List<ExpressionNode> _parseArgumentList() {
    final args = <ExpressionNode>[];
    if (!_check(JavaTokenType.rparen)) {
      args.add(_parseComparison());
      while (_check(JavaTokenType.comma)) {
        _advance();
        args.add(_parseComparison());
      }
    }
    return args;
  }

  // ---------- Expressions (may precedence na) ----------

  // Pinaka-mataas na antas: comparison (>, <, >=, <=, ==, !=)
  ExpressionNode _parseComparison() {
    var left = _parseExpression();

    const comparisonTypes = {
      JavaTokenType.greater,
      JavaTokenType.less,
      JavaTokenType.greaterEqual,
      JavaTokenType.lessEqual,
      JavaTokenType.equals,
      JavaTokenType.notEquals,
    };

    if (comparisonTypes.contains(_peek().type)) {
      final opToken = _advance();
      final op = _operatorSymbol(opToken.type);
      final right = _parseExpression();
      left = BinaryExpressionNode(left, op, right);
    }

    return left;
  }

  // Susunod: addition/subtraction
  ExpressionNode _parseExpression() {
    var left = _parseTerm();

    while (_check(JavaTokenType.plus) || _check(JavaTokenType.minus)) {
      final opToken = _advance();
      final op = opToken.type == JavaTokenType.plus ? '+' : '-';
      final right = _parseTerm();
      left = BinaryExpressionNode(left, op, right);
    }

    return left;
  }

  // Susunod: multiplication/division
  ExpressionNode _parseTerm() {
    var left = _parsePrimary();

    while (_check(JavaTokenType.star) ||
        _check(JavaTokenType.slash) ||
        _check(JavaTokenType.percent)) {
      final opToken = _advance();
      final op = opToken.lexeme;
      final right = _parsePrimary();
      left = BinaryExpressionNode(left, op, right);
    }

    return left;
  }

  // Pinaka-baba: literals, identifiers, function calls, (expression)
  ExpressionNode _parsePrimary() {
    final token = _peek();

    if (token.type == JavaTokenType.minus) {
      _advance();
      final operand = _parsePrimary();
      return BinaryExpressionNode(NumberLiteralNode(0), '-', operand);
    }

    if (token.type == JavaTokenType.stringLiteral) {
      _advance();
      return StringLiteralNode(token.lexeme);
    }
    if (token.type == JavaTokenType.numberLiteral) {
      _advance();
      return NumberLiteralNode(int.parse(token.lexeme));
    }
    if (token.type == JavaTokenType.identifier) {
      _advance();
      if (_check(JavaTokenType.lparen)) {
        _advance(); // consume "("
        final args = _parseArgumentList();
        _expect(JavaTokenType.rparen);
        return CallExpressionNode(token.lexeme, args);
      }
      return IdentifierNode(token.lexeme);
    }
    if (token.type == JavaTokenType.lparen) {
      _advance();
      final expr = _parseComparison();
      _expect(JavaTokenType.rparen);
      return expr;
    }

    throw FormatException(
      'Hindi ma-parse ang expression sa line ${token.line}: hindi inaasahang token na "${token.lexeme}"',
    );
  }

  String _operatorSymbol(JavaTokenType type) {
    switch (type) {
      case JavaTokenType.greater:
        return '>';
      case JavaTokenType.less:
        return '<';
      case JavaTokenType.greaterEqual:
        return '>=';
      case JavaTokenType.lessEqual:
        return '<=';
      case JavaTokenType.equals:
        return '==';
      case JavaTokenType.notEquals:
        return '!=';
      default:
        throw FormatException('Hindi kilalang operator type: $type');
    }
  }

  // ---------- Helpers ----------

  Token<JavaTokenType> _peek() => tokens[_pos];

  Token<JavaTokenType> _peekNext() =>
      _pos + 1 < tokens.length ? tokens[_pos + 1] : tokens[tokens.length - 1];

  Token<JavaTokenType> _advance() => tokens[_pos++];

  bool _check(JavaTokenType type) => _peek().type == type;

  Token<JavaTokenType> _expect(JavaTokenType type) {
    if (_check(type)) {
      return _advance();
    }
    throw FormatException(
      'Inaasahan ang "${type.name}" pero "${_peek().lexeme}" (${_peek().type.name}) ang nakita sa line ${_peek().line}',
    );
  }
}
