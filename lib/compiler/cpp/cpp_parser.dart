import '../token.dart';
import 'cpp_token_type.dart';
import 'cpp_ast.dart';

class CppParser {
  final List<Token<CppTokenType>> tokens;
  int _pos = 0;

  CppParser(this.tokens);

  ProgramNode parseProgram() {
    final functions = <FunctionNode>[];

    while (!_check(CppTokenType.eof)) {
      // "using namespace std;" — i-skip lang, hindi natin kailangan
      if (_check(CppTokenType.identifier) && _peek().lexeme == 'using') {
        _parseUsingDirective();
        continue;
      }
      functions.add(_parseFunction());
    }

    return ProgramNode(functions);
  }

  void _parseUsingDirective() {
    _expect(CppTokenType.identifier); // "using"
    _expect(CppTokenType.identifier); // "namespace"
    _expect(CppTokenType.identifier); // hal. "std"
    _expect(CppTokenType.semicolon);
  }

  // ---------- Functions ----------

  FunctionNode _parseFunction() {
    String returnType;
    if (_check(CppTokenType.voidKw)) {
      _advance();
      returnType = 'void';
    } else if (_check(CppTokenType.intKw)) {
      _advance();
      returnType = 'int';
    } else {
      throw FormatException(
        'Inaasahan ang return type ("void" o "int") sa line ${_peek().line}, pero "${_peek().lexeme}" ang nakita.',
      );
    }

    final nameToken = _expect(CppTokenType.identifier);
    _expect(CppTokenType.lparen);

    final params = <ParamNode>[];
    if (!_check(CppTokenType.rparen)) {
      params.add(_parseParam());
      while (_check(CppTokenType.comma)) {
        _advance();
        params.add(_parseParam());
      }
    }
    _expect(CppTokenType.rparen);

    final body = _parseBlock();
    return FunctionNode(returnType, nameToken.lexeme, params, body);
  }

  ParamNode _parseParam() {
    _expect(CppTokenType.intKw); // sa ngayon, "int" type lang ang param
    final nameToken = _expect(CppTokenType.identifier);
    return ParamNode('int', nameToken.lexeme);
  }

  // ---------- Blocks ----------

  List<StatementNode> _parseBlock() {
    _expect(CppTokenType.lbrace);
    final statements = <StatementNode>[];
    while (!_check(CppTokenType.rbrace)) {
      statements.add(_parseStatement());
    }
    _expect(CppTokenType.rbrace);
    return statements;
  }

  // ---------- Statements ----------

  StatementNode _parseStatement() {
    if (_check(CppTokenType.intKw)) {
      return _parseVariableDeclaration();
    }
    if (_check(CppTokenType.ifKw)) {
      return _parseIfStatement();
    }
    if (_check(CppTokenType.whileKw)) {
      return _parseWhileStatement();
    }
    if (_check(CppTokenType.forKw)) {
      return _parseForStatement();
    }
    if (_check(CppTokenType.returnKw)) {
      return _parseReturnStatement();
    }
    if (_check(CppTokenType.identifier) && _peek().lexeme == 'cout') {
      return _parseCoutStatement();
    }
    if (_check(CppTokenType.identifier) &&
        _peekNext().type == CppTokenType.lparen) {
      return _parseCallStatement();
    }
    if (_check(CppTokenType.identifier)) {
      return _parseAssignmentStatement();
    }
    throw FormatException(
      'Hindi ma-parse ang statement sa line ${_peek().line}: hindi kilalang statement na nagsisimula sa "${_peek().lexeme}"',
    );
  }

  StatementNode _parseVariableDeclaration() {
    _expect(CppTokenType.intKw);
    final nameToken = _expect(CppTokenType.identifier);
    _expect(CppTokenType.assign);
    final initializer = _parseComparison();
    _expect(CppTokenType.semicolon);
    return VariableDeclarationNode('int', nameToken.lexeme, initializer);
  }

  StatementNode _parseAssignmentStatement() {
    final assignment = _parseAssignmentCore();
    _expect(CppTokenType.semicolon);
    return assignment;
  }

  /// Sinusuportahan: x = expr, x += expr, x -= expr, x *= expr, x /= expr,
  /// x %= expr, x++, x--  (lahat ay ginagawang simpleng assignment).
  AssignmentStatementNode _parseAssignmentCore() {
    final nameToken = _expect(CppTokenType.identifier);
    final opType = _peek().type;
    const compound = <CppTokenType, String>{
      CppTokenType.plus: '+',
      CppTokenType.minus: '-',
      CppTokenType.star: '*',
      CppTokenType.slash: '/',
      CppTokenType.percent: '%',
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
      if (next == CppTokenType.assign) {
        _advance();
        _advance();
        final value = _parseComparison();
        return AssignmentStatementNode(
          nameToken.lexeme,
          BinaryExpressionNode(IdentifierNode(nameToken.lexeme), op, value),
        );
      }
    }
    _expect(CppTokenType.assign);
    final value = _parseComparison();
    return AssignmentStatementNode(nameToken.lexeme, value);
  }

  StatementNode _parseCoutStatement() {
    _expect(CppTokenType.identifier); // "cout"
    _expect(CppTokenType.shiftLeft);

    final parts = <ExpressionNode>[_parseCoutItem()];
    while (_check(CppTokenType.shiftLeft)) {
      _advance();
      parts.add(_parseCoutItem());
    }
    _expect(CppTokenType.semicolon);
    return CoutStatementNode(parts);
  }

  ExpressionNode _parseCoutItem() {
    if (_check(CppTokenType.identifier) && _peek().lexeme == 'endl') {
      _advance();
      return StringLiteralNode('\n');
    }
    return _parseComparison();
  }

  StatementNode _parseIfStatement() {
    _expect(CppTokenType.ifKw);
    _expect(CppTokenType.lparen);
    final condition = _parseComparison();
    _expect(CppTokenType.rparen);
    final thenBranch = _parseBlock();

    List<StatementNode>? elseBranch;
    if (_check(CppTokenType.elseKw)) {
      _advance();
      elseBranch = _check(CppTokenType.ifKw)
          ? [_parseIfStatement()]
          : _parseBlock();
    }

    return IfStatementNode(condition, thenBranch, elseBranch);
  }

  StatementNode _parseWhileStatement() {
    _expect(CppTokenType.whileKw);
    _expect(CppTokenType.lparen);
    final condition = _parseComparison();
    _expect(CppTokenType.rparen);
    final body = _parseBlock();
    return WhileStatementNode(condition, body);
  }

  StatementNode _parseForStatement() {
    _expect(CppTokenType.forKw);
    _expect(CppTokenType.lparen);

    final init = _parseVariableDeclaration();

    final condition = _parseComparison();
    _expect(CppTokenType.semicolon);

    final update = _parseAssignmentCore();

    _expect(CppTokenType.rparen);

    final body = _parseBlock();
    final whileBody = [...body, update];
    final whileLoop = WhileStatementNode(condition, whileBody);

    return BlockWrapperNode([init, whileLoop]);
  }

  StatementNode _parseReturnStatement() {
    _expect(CppTokenType.returnKw);
    ExpressionNode? value;
    if (!_check(CppTokenType.semicolon)) {
      value = _parseComparison();
    }
    _expect(CppTokenType.semicolon);
    return ReturnStatementNode(value);
  }

  StatementNode _parseCallStatement() {
    final nameToken = _expect(CppTokenType.identifier);
    _expect(CppTokenType.lparen);
    final args = _parseArgumentList();
    _expect(CppTokenType.rparen);
    _expect(CppTokenType.semicolon);
    return ExpressionStatementNode(CallExpressionNode(nameToken.lexeme, args));
  }

  List<ExpressionNode> _parseArgumentList() {
    final args = <ExpressionNode>[];
    if (!_check(CppTokenType.rparen)) {
      args.add(_parseComparison());
      while (_check(CppTokenType.comma)) {
        _advance();
        args.add(_parseComparison());
      }
    }
    return args;
  }

  // ---------- Expressions (may precedence na) ----------

  ExpressionNode _parseComparison() {
    var left = _parseExpression();

    const comparisonTypes = {
      CppTokenType.greater,
      CppTokenType.less,
      CppTokenType.greaterEqual,
      CppTokenType.lessEqual,
      CppTokenType.equals,
      CppTokenType.notEquals,
    };

    if (comparisonTypes.contains(_peek().type)) {
      final opToken = _advance();
      final op = _operatorSymbol(opToken.type);
      final right = _parseExpression();
      left = BinaryExpressionNode(left, op, right);
    }

    return left;
  }

  ExpressionNode _parseExpression() {
    var left = _parseTerm();

    while (_check(CppTokenType.plus) || _check(CppTokenType.minus)) {
      final opToken = _advance();
      final op = opToken.type == CppTokenType.plus ? '+' : '-';
      final right = _parseTerm();
      left = BinaryExpressionNode(left, op, right);
    }

    return left;
  }

  ExpressionNode _parseTerm() {
    var left = _parsePrimary();

    while (_check(CppTokenType.star) ||
        _check(CppTokenType.slash) ||
        _check(CppTokenType.percent)) {
      final opToken = _advance();
      final op = opToken.lexeme;
      final right = _parsePrimary();
      left = BinaryExpressionNode(left, op, right);
    }

    return left;
  }

  ExpressionNode _parsePrimary() {
    final token = _peek();

    if (token.type == CppTokenType.minus) {
      _advance();
      final operand = _parsePrimary();
      return BinaryExpressionNode(NumberLiteralNode(0), '-', operand);
    }

    if (token.type == CppTokenType.stringLiteral) {
      _advance();
      return StringLiteralNode(token.lexeme);
    }
    if (token.type == CppTokenType.numberLiteral) {
      _advance();
      return NumberLiteralNode(int.parse(token.lexeme));
    }
    if (token.type == CppTokenType.identifier) {
      _advance();
      if (_check(CppTokenType.lparen)) {
        _advance();
        final args = _parseArgumentList();
        _expect(CppTokenType.rparen);
        return CallExpressionNode(token.lexeme, args);
      }
      return IdentifierNode(token.lexeme);
    }
    if (token.type == CppTokenType.lparen) {
      _advance();
      final expr = _parseComparison();
      _expect(CppTokenType.rparen);
      return expr;
    }

    throw FormatException(
      'Hindi ma-parse ang expression sa line ${token.line}: hindi inaasahang token na "${token.lexeme}"',
    );
  }

  String _operatorSymbol(CppTokenType type) {
    switch (type) {
      case CppTokenType.greater:
        return '>';
      case CppTokenType.less:
        return '<';
      case CppTokenType.greaterEqual:
        return '>=';
      case CppTokenType.lessEqual:
        return '<=';
      case CppTokenType.equals:
        return '==';
      case CppTokenType.notEquals:
        return '!=';
      default:
        throw FormatException('Hindi kilalang operator type: $type');
    }
  }

  // ---------- Helpers ----------

  Token<CppTokenType> _peek() => tokens[_pos];

  Token<CppTokenType> _peekNext() =>
      _pos + 1 < tokens.length ? tokens[_pos + 1] : tokens[tokens.length - 1];

  Token<CppTokenType> _advance() => tokens[_pos++];

  bool _check(CppTokenType type) => _peek().type == type;

  Token<CppTokenType> _expect(CppTokenType type) {
    if (_check(type)) {
      return _advance();
    }
    throw FormatException(
      'Inaasahan ang "${type.name}" pero "${_peek().lexeme}" (${_peek().type.name}) ang nakita sa line ${_peek().line}',
    );
  }
}
