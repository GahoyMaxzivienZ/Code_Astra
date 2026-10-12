import '../token.dart';
import 'js_token_type.dart';
import 'js_ast.dart';

class JsParser {
  final List<Token<JsTokenType>> tokens;
  int _pos = 0;

  JsParser(this.tokens);

  ProgramNode parseProgram() {
    final statements = <StatementNode>[];
    while (!_check(JsTokenType.eof)) {
      statements.add(_parseStatement());
    }
    return ProgramNode(statements);
  }

  // ---------- Blocks ----------

  List<StatementNode> _parseBlock() {
    _expect(JsTokenType.lbrace);
    final statements = <StatementNode>[];
    while (!_check(JsTokenType.rbrace)) {
      statements.add(_parseStatement());
    }
    _expect(JsTokenType.rbrace);
    return statements;
  }

  // ---------- Statements ----------

  StatementNode _parseStatement() {
    if (_check(JsTokenType.letKw)) {
      return _parseVariableDeclaration();
    }
    if (_check(JsTokenType.functionKw)) {
      return _parseFunctionDeclaration();
    }
    if (_check(JsTokenType.ifKw)) {
      return _parseIfStatement();
    }
    if (_check(JsTokenType.whileKw)) {
      return _parseWhileStatement();
    }
    if (_check(JsTokenType.forKw)) {
      return _parseForStatement();
    }
    if (_check(JsTokenType.returnKw)) {
      return _parseReturnStatement();
    }
    if (_check(JsTokenType.identifier) && _peek().lexeme == 'console') {
      return _parseConsoleLogStatement();
    }
    if (_check(JsTokenType.identifier) &&
        _peekNext().type == JsTokenType.lparen) {
      return _parseCallStatement();
    }
    if (_check(JsTokenType.identifier)) {
      return _parseAssignmentStatement();
    }
    throw FormatException(
      'Hindi ma-parse ang statement sa line ${_peek().line}: hindi kilalang statement na nagsisimula sa "${_peek().lexeme}"',
    );
  }

  StatementNode _parseVariableDeclaration() {
    _expect(JsTokenType.letKw);
    final nameToken = _expect(JsTokenType.identifier);
    _expect(JsTokenType.assign);
    final initializer = _parseComparison();
    _expect(JsTokenType.semicolon);
    return VariableDeclarationNode(nameToken.lexeme, initializer);
  }

  StatementNode _parseFunctionDeclaration() {
    _expect(JsTokenType.functionKw);
    final nameToken = _expect(JsTokenType.identifier);
    _expect(JsTokenType.lparen);

    final params = <String>[];
    if (!_check(JsTokenType.rparen)) {
      params.add(_expect(JsTokenType.identifier).lexeme);
      while (_check(JsTokenType.comma)) {
        _advance();
        params.add(_expect(JsTokenType.identifier).lexeme);
      }
    }
    _expect(JsTokenType.rparen);

    final body = _parseBlock();
    return FunctionDeclarationNode(nameToken.lexeme, params, body);
  }

  StatementNode _parseAssignmentStatement() {
    final assignment = _parseAssignmentCore();
    _expect(JsTokenType.semicolon);
    return assignment;
  }

  /// Sinusuportahan: x = expr, x += expr, x -= expr, x *= expr, x /= expr,
  /// x %= expr, x++, x--  (lahat ay ginagawang simpleng assignment).
  AssignmentStatementNode _parseAssignmentCore() {
    final nameToken = _expect(JsTokenType.identifier);
    final opType = _peek().type;
    const compound = <JsTokenType, String>{
      JsTokenType.plus: '+',
      JsTokenType.minus: '-',
      JsTokenType.star: '*',
      JsTokenType.slash: '/',
      JsTokenType.percent: '%',
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
      if (next == JsTokenType.assign) {
        _advance();
        _advance();
        final value = _parseComparison();
        return AssignmentStatementNode(
          nameToken.lexeme,
          BinaryExpressionNode(IdentifierNode(nameToken.lexeme), op, value),
        );
      }
    }
    _expect(JsTokenType.assign);
    final value = _parseComparison();
    return AssignmentStatementNode(nameToken.lexeme, value);
  }

  StatementNode _parseConsoleLogStatement() {
    _expect(JsTokenType.identifier); // "console"
    _expect(JsTokenType.dot);
    final methodToken = _expect(JsTokenType.identifier); // "log"
    if (methodToken.lexeme != 'log') {
      throw FormatException(
        'Inaasahan ang "log" pero "${methodToken.lexeme}" ang nakita sa line ${methodToken.line}',
      );
    }
    _expect(JsTokenType.lparen);
    final args = _parseArgumentList();
    _expect(JsTokenType.rparen);
    _expect(JsTokenType.semicolon);
    return ConsoleLogStatementNode(args);
  }

  StatementNode _parseIfStatement() {
    _expect(JsTokenType.ifKw);
    _expect(JsTokenType.lparen);
    final condition = _parseComparison();
    _expect(JsTokenType.rparen);
    final thenBranch = _parseBlock();

    List<StatementNode>? elseBranch;
    if (_check(JsTokenType.elseKw)) {
      _advance();
      elseBranch = _check(JsTokenType.ifKw)
          ? [_parseIfStatement()]
          : _parseBlock();
    }

    return IfStatementNode(condition, thenBranch, elseBranch);
  }

  StatementNode _parseWhileStatement() {
    _expect(JsTokenType.whileKw);
    _expect(JsTokenType.lparen);
    final condition = _parseComparison();
    _expect(JsTokenType.rparen);
    final body = _parseBlock();
    return WhileStatementNode(condition, body);
  }

  StatementNode _parseForStatement() {
    _expect(JsTokenType.forKw);
    _expect(JsTokenType.lparen);

    final init = _parseVariableDeclaration(); // may kasama nang semicolon

    final condition = _parseComparison();
    _expect(JsTokenType.semicolon);

    final update = _parseAssignmentCore();

    _expect(JsTokenType.rparen);

    final body = _parseBlock();
    final whileBody = [...body, update];
    final whileLoop = WhileStatementNode(condition, whileBody);

    return BlockWrapperNode([init, whileLoop]);
  }

  StatementNode _parseReturnStatement() {
    _expect(JsTokenType.returnKw);
    ExpressionNode? value;
    if (!_check(JsTokenType.semicolon)) {
      value = _parseComparison();
    }
    _expect(JsTokenType.semicolon);
    return ReturnStatementNode(value);
  }

  StatementNode _parseCallStatement() {
    final nameToken = _expect(JsTokenType.identifier);
    _expect(JsTokenType.lparen);
    final args = _parseArgumentList();
    _expect(JsTokenType.rparen);
    _expect(JsTokenType.semicolon);
    return ExpressionStatementNode(CallExpressionNode(nameToken.lexeme, args));
  }

  List<ExpressionNode> _parseArgumentList() {
    final args = <ExpressionNode>[];
    if (!_check(JsTokenType.rparen)) {
      args.add(_parseComparison());
      while (_check(JsTokenType.comma)) {
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
      JsTokenType.greater,
      JsTokenType.less,
      JsTokenType.greaterEqual,
      JsTokenType.lessEqual,
      JsTokenType.equals,
      JsTokenType.notEquals,
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

    while (_check(JsTokenType.plus) || _check(JsTokenType.minus)) {
      final opToken = _advance();
      final op = opToken.type == JsTokenType.plus ? '+' : '-';
      final right = _parseTerm();
      left = BinaryExpressionNode(left, op, right);
    }

    return left;
  }

  ExpressionNode _parseTerm() {
    var left = _parsePrimary();

    while (_check(JsTokenType.star) ||
        _check(JsTokenType.slash) ||
        _check(JsTokenType.percent)) {
      final opToken = _advance();
      final op = opToken.lexeme;
      final right = _parsePrimary();
      left = BinaryExpressionNode(left, op, right);
    }

    return left;
  }

  ExpressionNode _parsePrimary() {
    final token = _peek();

    if (token.type == JsTokenType.minus) {
      _advance();
      final operand = _parsePrimary();
      return BinaryExpressionNode(NumberLiteralNode(0), '-', operand);
    }

    if (token.type == JsTokenType.stringLiteral) {
      _advance();
      return StringLiteralNode(token.lexeme);
    }
    if (token.type == JsTokenType.numberLiteral) {
      _advance();
      return NumberLiteralNode(int.parse(token.lexeme));
    }
    if (token.type == JsTokenType.identifier) {
      _advance();
      if (_check(JsTokenType.lparen)) {
        _advance();
        final args = _parseArgumentList();
        _expect(JsTokenType.rparen);
        return CallExpressionNode(token.lexeme, args);
      }
      return IdentifierNode(token.lexeme);
    }
    if (token.type == JsTokenType.lparen) {
      _advance();
      final expr = _parseComparison();
      _expect(JsTokenType.rparen);
      return expr;
    }

    throw FormatException(
      'Hindi ma-parse ang expression sa line ${token.line}: hindi inaasahang token na "${token.lexeme}"',
    );
  }

  String _operatorSymbol(JsTokenType type) {
    switch (type) {
      case JsTokenType.greater:
        return '>';
      case JsTokenType.less:
        return '<';
      case JsTokenType.greaterEqual:
        return '>=';
      case JsTokenType.lessEqual:
        return '<=';
      case JsTokenType.equals:
        return '==';
      case JsTokenType.notEquals:
        return '!=';
      default:
        throw FormatException('Hindi kilalang operator type: $type');
    }
  }

  // ---------- Helpers ----------

  Token<JsTokenType> _peek() => tokens[_pos];

  Token<JsTokenType> _peekNext() =>
      _pos + 1 < tokens.length ? tokens[_pos + 1] : tokens[tokens.length - 1];

  Token<JsTokenType> _advance() => tokens[_pos++];

  bool _check(JsTokenType type) => _peek().type == type;

  Token<JsTokenType> _expect(JsTokenType type) {
    if (_check(type)) {
      return _advance();
    }
    throw FormatException(
      'Inaasahan ang "${type.name}" pero "${_peek().lexeme}" (${_peek().type.name}) ang nakita sa line ${_peek().line}',
    );
  }
}
