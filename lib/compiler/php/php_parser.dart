import '../token.dart';
import 'php_token_type.dart';
import 'php_ast.dart';

class PhpParser {
  final List<Token<PhpTokenType>> tokens;
  int _pos = 0;

  PhpParser(this.tokens);

  ProgramNode parseProgram() {
    final statements = <StatementNode>[];
    while (!_check(PhpTokenType.eof)) {
      statements.add(_parseStatement());
    }
    return ProgramNode(statements);
  }

  // ---------- Blocks ----------

  List<StatementNode> _parseBlock() {
    _expect(PhpTokenType.lbrace);
    final statements = <StatementNode>[];
    while (!_check(PhpTokenType.rbrace)) {
      statements.add(_parseStatement());
    }
    _expect(PhpTokenType.rbrace);
    return statements;
  }

  // ---------- Statements ----------

  StatementNode _parseStatement() {
    if (_check(PhpTokenType.functionKw)) {
      return _parseFunctionDeclaration();
    }
    if (_check(PhpTokenType.ifKw)) {
      return _parseIfStatement();
    }
    if (_check(PhpTokenType.whileKw)) {
      return _parseWhileStatement();
    }
    if (_check(PhpTokenType.forKw)) {
      return _parseForStatement();
    }
    if (_check(PhpTokenType.returnKw)) {
      return _parseReturnStatement();
    }
    if (_check(PhpTokenType.echoKw)) {
      return _parseEchoStatement();
    }
    // Function call bilang standalone statement — bare identifier
    // (walang "$"), sinusundan ng "("
    if (_check(PhpTokenType.identifier) &&
        !_peek().lexeme.startsWith('\$') &&
        _peekNext().type == PhpTokenType.lparen) {
      return _parseCallStatement();
    }
    // Variable assignment — may "$" sa unahan
    if (_check(PhpTokenType.identifier) && _peek().lexeme.startsWith('\$')) {
      return _parseAssignmentStatement();
    }
    throw FormatException(
      'Hindi ma-parse ang statement sa line ${_peek().line}: hindi kilalang statement na nagsisimula sa "${_peek().lexeme}"',
    );
  }

  StatementNode _parseFunctionDeclaration() {
    _expect(PhpTokenType.functionKw);
    final nameToken = _expect(PhpTokenType.identifier); // bare name
    _expect(PhpTokenType.lparen);

    final params = <String>[];
    if (!_check(PhpTokenType.rparen)) {
      params.add(_expect(PhpTokenType.identifier).lexeme); // "$a"
      while (_check(PhpTokenType.comma)) {
        _advance();
        params.add(_expect(PhpTokenType.identifier).lexeme);
      }
    }
    _expect(PhpTokenType.rparen);

    final body = _parseBlock();
    return FunctionDeclarationNode(nameToken.lexeme, params, body);
  }

  StatementNode _parseAssignmentStatement() {
    final assignment = _parseAssignmentCore();
    _expect(PhpTokenType.semicolon);
    return assignment;
  }

  /// Sinusuportahan: x = expr, x += expr, x -= expr, x *= expr, x /= expr,
  /// x %= expr, x++, x--  (lahat ay ginagawang simpleng assignment).
  AssignmentStatementNode _parseAssignmentCore() {
    final nameToken = _expect(PhpTokenType.identifier);
    final opType = _peek().type;
    const compound = <PhpTokenType, String>{
      PhpTokenType.plus: '+',
      PhpTokenType.minus: '-',
      PhpTokenType.star: '*',
      PhpTokenType.slash: '/',
      PhpTokenType.percent: '%',
      PhpTokenType.dot: '.',
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
      if (next == PhpTokenType.assign) {
        _advance();
        _advance();
        final value = _parseComparison();
        return AssignmentStatementNode(
          nameToken.lexeme,
          BinaryExpressionNode(IdentifierNode(nameToken.lexeme), op, value),
        );
      }
    }
    _expect(PhpTokenType.assign);
    final value = _parseComparison();
    return AssignmentStatementNode(nameToken.lexeme, value);
  }

  StatementNode _parseEchoStatement() {
    _expect(PhpTokenType.echoKw);
    final args = <ExpressionNode>[_parseComparison()];
    while (_check(PhpTokenType.comma)) {
      _advance();
      args.add(_parseComparison());
    }
    _expect(PhpTokenType.semicolon);
    return EchoStatementNode(args);
  }

  StatementNode _parseIfStatement() {
    if (_check(PhpTokenType.identifier) && _peek().lexeme == 'elseif') {
      _advance();
    } else {
      _expect(PhpTokenType.ifKw);
    }
    _expect(PhpTokenType.lparen);
    final condition = _parseComparison();
    _expect(PhpTokenType.rparen);
    final thenBranch = _parseBlock();

    List<StatementNode>? elseBranch;
    if (_check(PhpTokenType.identifier) && _peek().lexeme == 'elseif') {
      elseBranch = [_parseIfStatement()];
    } else if (_check(PhpTokenType.elseKw)) {
      _advance();
      elseBranch = _check(PhpTokenType.ifKw)
          ? [_parseIfStatement()]
          : _parseBlock();
    }

    return IfStatementNode(condition, thenBranch, elseBranch);
  }

  StatementNode _parseWhileStatement() {
    _expect(PhpTokenType.whileKw);
    _expect(PhpTokenType.lparen);
    final condition = _parseComparison();
    _expect(PhpTokenType.rparen);
    final body = _parseBlock();
    return WhileStatementNode(condition, body);
  }

  StatementNode _parseForStatement() {
    _expect(PhpTokenType.forKw);
    _expect(PhpTokenType.lparen);

    final init = _parseAssignmentStatement(); // "$i = 0;" may kasamang ";"

    final condition = _parseComparison();
    _expect(PhpTokenType.semicolon);

    final update = _parseAssignmentCore();

    _expect(PhpTokenType.rparen);
    final body = _parseBlock();
    final whileBody = [...body, update];
    final whileLoop = WhileStatementNode(condition, whileBody);

    return BlockWrapperNode([init, whileLoop]);
  }

  StatementNode _parseReturnStatement() {
    _expect(PhpTokenType.returnKw);
    ExpressionNode? value;
    if (!_check(PhpTokenType.semicolon)) {
      value = _parseComparison();
    }
    _expect(PhpTokenType.semicolon);
    return ReturnStatementNode(value);
  }

  StatementNode _parseCallStatement() {
    final nameToken = _expect(PhpTokenType.identifier);
    _expect(PhpTokenType.lparen);
    final args = _parseArgumentList();
    _expect(PhpTokenType.rparen);
    _expect(PhpTokenType.semicolon);
    return ExpressionStatementNode(CallExpressionNode(nameToken.lexeme, args));
  }

  List<ExpressionNode> _parseArgumentList() {
    final args = <ExpressionNode>[];
    if (!_check(PhpTokenType.rparen)) {
      args.add(_parseComparison());
      while (_check(PhpTokenType.comma)) {
        _advance();
        args.add(_parseComparison());
      }
    }
    return args;
  }

  // ---------- Expressions ----------

  ExpressionNode _parseComparison() {
    var left = _parseConcat();

    const comparisonTypes = {
      PhpTokenType.greater,
      PhpTokenType.less,
      PhpTokenType.greaterEqual,
      PhpTokenType.lessEqual,
      PhpTokenType.equals,
      PhpTokenType.notEquals,
    };

    if (comparisonTypes.contains(_peek().type)) {
      final opToken = _advance();
      final op = _operatorSymbol(opToken.type);
      final right = _parseConcat();
      left = BinaryExpressionNode(left, op, right);
    }

    return left;
  }

  // "." — string concatenation ng PHP. Mas mababa ang precedence kaysa + at -
  ExpressionNode _parseConcat() {
    var left = _parseExpression();
    while (_check(PhpTokenType.dot)) {
      _advance();
      final right = _parseExpression();
      left = BinaryExpressionNode(left, '.', right);
    }
    return left;
  }

  ExpressionNode _parseExpression() {
    var left = _parseTerm();

    while (_check(PhpTokenType.plus) || _check(PhpTokenType.minus)) {
      final opToken = _advance();
      final op = opToken.type == PhpTokenType.plus ? '+' : '-';
      final right = _parseTerm();
      left = BinaryExpressionNode(left, op, right);
    }

    return left;
  }

  ExpressionNode _parseTerm() {
    var left = _parsePrimary();

    while (_check(PhpTokenType.star) ||
        _check(PhpTokenType.slash) ||
        _check(PhpTokenType.percent)) {
      final opToken = _advance();
      final op = opToken.lexeme;
      final right = _parsePrimary();
      left = BinaryExpressionNode(left, op, right);
    }

    return left;
  }

  ExpressionNode _parsePrimary() {
    final token = _peek();

    if (token.type == PhpTokenType.minus) {
      _advance();
      final operand = _parsePrimary();
      return BinaryExpressionNode(NumberLiteralNode(0), '-', operand);
    }

    if (token.type == PhpTokenType.stringLiteral) {
      _advance();
      return StringLiteralNode(token.lexeme);
    }
    if (token.type == PhpTokenType.numberLiteral) {
      _advance();
      return NumberLiteralNode(int.parse(token.lexeme));
    }
    if (token.type == PhpTokenType.identifier) {
      _advance();
      if (_check(PhpTokenType.lparen)) {
        _advance();
        final args = _parseArgumentList();
        _expect(PhpTokenType.rparen);
        return CallExpressionNode(token.lexeme, args);
      }
      return IdentifierNode(token.lexeme);
    }
    if (token.type == PhpTokenType.lparen) {
      _advance();
      final expr = _parseComparison();
      _expect(PhpTokenType.rparen);
      return expr;
    }

    throw FormatException(
      'Hindi ma-parse ang expression sa line ${token.line}: hindi inaasahang token na "${token.lexeme}"',
    );
  }

  String _operatorSymbol(PhpTokenType type) {
    switch (type) {
      case PhpTokenType.greater:
        return '>';
      case PhpTokenType.less:
        return '<';
      case PhpTokenType.greaterEqual:
        return '>=';
      case PhpTokenType.lessEqual:
        return '<=';
      case PhpTokenType.equals:
        return '==';
      case PhpTokenType.notEquals:
        return '!=';
      default:
        throw FormatException('Hindi kilalang operator type: $type');
    }
  }

  // ---------- Helpers ----------

  Token<PhpTokenType> _peek() => tokens[_pos];

  Token<PhpTokenType> _peekNext() =>
      _pos + 1 < tokens.length ? tokens[_pos + 1] : tokens[tokens.length - 1];

  Token<PhpTokenType> _advance() => tokens[_pos++];

  bool _check(PhpTokenType type) => _peek().type == type;

  Token<PhpTokenType> _expect(PhpTokenType type) {
    if (_check(type)) {
      return _advance();
    }
    throw FormatException(
      'Inaasahan ang "${type.name}" pero "${_peek().lexeme}" (${_peek().type.name}) ang nakita sa line ${_peek().line}',
    );
  }
}
