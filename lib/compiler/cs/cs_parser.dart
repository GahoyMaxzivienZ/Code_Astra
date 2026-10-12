import '../token.dart';
import 'cs_token_type.dart';
import 'cs_ast.dart';

class CsParser {
  final List<Token<CsTokenType>> tokens;
  int _pos = 0;

  CsParser(this.tokens);

  ProgramNode parseProgram() {
    // "using System;" (o kahit anong "using X.Y;") — i-skip lang
    while (_check(CsTokenType.identifier) && _peek().lexeme == 'using') {
      _skipUsingDirective();
    }

    if (_check(CsTokenType.publicKw)) _advance();
    _expect(CsTokenType.classKw);
    final classNameToken = _expect(CsTokenType.identifier);
    _expect(CsTokenType.lbrace);

    final methods = <MethodNode>[];
    while (!_check(CsTokenType.rbrace)) {
      methods.add(_parseMethod());
    }
    _expect(CsTokenType.rbrace);

    return ProgramNode(classNameToken.lexeme, methods);
  }

  void _skipUsingDirective() {
    // "using" + kahit anong tokens hanggang ";" — hindi natin kailangan
    // i-intindi ang laman, basta i-skip lang buong linya
    while (!_check(CsTokenType.semicolon)) {
      _advance();
    }
    _advance(); // consume ";"
  }

  // ---------- Methods ----------

  MethodNode _parseMethod() {
    if (_check(CsTokenType.publicKw)) _advance();
    _expect(CsTokenType.staticKw);

    String returnType;
    if (_check(CsTokenType.voidKw)) {
      _advance();
      returnType = 'void';
    } else if (_check(CsTokenType.intKw)) {
      _advance();
      returnType = 'int';
    } else {
      throw FormatException(
        'Inaasahan ang return type ("void" o "int") sa line ${_peek().line}, pero "${_peek().lexeme}" ang nakita.',
      );
    }

    final nameToken = _expect(CsTokenType.identifier);
    _expect(CsTokenType.lparen);

    final params = <ParamNode>[];
    if (nameToken.lexeme == 'Main') {
      // special case: static void Main(string[] args)
      if (!_check(CsTokenType.rparen)) {
        _expect(CsTokenType.identifier); // "string"
        _expect(CsTokenType.lbracket);
        _expect(CsTokenType.rbracket);
        final argsToken = _expect(CsTokenType.identifier); // "args"
        params.add(ParamNode('string[]', argsToken.lexeme));
      }
    } else {
      if (!_check(CsTokenType.rparen)) {
        params.add(_parseParam());
        while (_check(CsTokenType.comma)) {
          _advance();
          params.add(_parseParam());
        }
      }
    }

    _expect(CsTokenType.rparen);
    final body = _parseBlock();
    return MethodNode(returnType, nameToken.lexeme, params, body);
  }

  ParamNode _parseParam() {
    _expect(CsTokenType.intKw); // sa ngayon, "int" type lang ang param
    final nameToken = _expect(CsTokenType.identifier);
    return ParamNode('int', nameToken.lexeme);
  }

  // ---------- Blocks ----------

  List<StatementNode> _parseBlock() {
    _expect(CsTokenType.lbrace);
    final statements = <StatementNode>[];
    while (!_check(CsTokenType.rbrace)) {
      statements.add(_parseStatement());
    }
    _expect(CsTokenType.rbrace);
    return statements;
  }

  // ---------- Statements ----------

  StatementNode _parseStatement() {
    if (_check(CsTokenType.intKw)) {
      return _parseVariableDeclaration();
    }
    if (_check(CsTokenType.ifKw)) {
      return _parseIfStatement();
    }
    if (_check(CsTokenType.whileKw)) {
      return _parseWhileStatement();
    }
    if (_check(CsTokenType.forKw)) {
      return _parseForStatement();
    }
    if (_check(CsTokenType.returnKw)) {
      return _parseReturnStatement();
    }
    if (_check(CsTokenType.identifier) && _peek().lexeme == 'Console') {
      return _parsePrintStatement();
    }
    if (_check(CsTokenType.identifier) &&
        _peekNext().type == CsTokenType.lparen) {
      return _parseCallStatement();
    }
    if (_check(CsTokenType.identifier)) {
      return _parseAssignmentStatement();
    }
    throw FormatException(
      'Hindi ma-parse ang statement sa line ${_peek().line}: hindi kilalang statement na nagsisimula sa "${_peek().lexeme}"',
    );
  }

  StatementNode _parseVariableDeclaration() {
    _expect(CsTokenType.intKw);
    final nameToken = _expect(CsTokenType.identifier);
    _expect(CsTokenType.assign);
    final initializer = _parseComparison();
    _expect(CsTokenType.semicolon);
    return VariableDeclarationNode('int', nameToken.lexeme, initializer);
  }

  StatementNode _parseAssignmentStatement() {
    final assignment = _parseAssignmentCore();
    _expect(CsTokenType.semicolon);
    return assignment;
  }

  /// Sinusuportahan: x = expr, x += expr, x -= expr, x *= expr, x /= expr,
  /// x %= expr, x++, x--  (lahat ay ginagawang simpleng assignment).
  AssignmentStatementNode _parseAssignmentCore() {
    final nameToken = _expect(CsTokenType.identifier);
    final opType = _peek().type;
    const compound = <CsTokenType, String>{
      CsTokenType.plus: '+',
      CsTokenType.minus: '-',
      CsTokenType.star: '*',
      CsTokenType.slash: '/',
      CsTokenType.percent: '%',
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
      if (next == CsTokenType.assign) {
        _advance();
        _advance();
        final value = _parseComparison();
        return AssignmentStatementNode(
          nameToken.lexeme,
          BinaryExpressionNode(IdentifierNode(nameToken.lexeme), op, value),
        );
      }
    }
    _expect(CsTokenType.assign);
    final value = _parseComparison();
    return AssignmentStatementNode(nameToken.lexeme, value);
  }

  StatementNode _parsePrintStatement() {
    _expect(CsTokenType.identifier); // "Console"
    _expect(CsTokenType.dot);
    final method = _expect(CsTokenType.identifier); // "WriteLine"
    if (method.lexeme != 'WriteLine') {
      throw FormatException(
        'Inaasahan ang "WriteLine" pero "${method.lexeme}" ang nakita sa line ${method.line}',
      );
    }
    _expect(CsTokenType.lparen);
    final argument = _parseComparison();
    _expect(CsTokenType.rparen);
    _expect(CsTokenType.semicolon);
    return PrintStatementNode(argument);
  }

  StatementNode _parseIfStatement() {
    _expect(CsTokenType.ifKw);
    _expect(CsTokenType.lparen);
    final condition = _parseComparison();
    _expect(CsTokenType.rparen);
    final thenBranch = _parseBlock();

    List<StatementNode>? elseBranch;
    if (_check(CsTokenType.elseKw)) {
      _advance();
      elseBranch = _check(CsTokenType.ifKw)
          ? [_parseIfStatement()]
          : _parseBlock();
    }

    return IfStatementNode(condition, thenBranch, elseBranch);
  }

  StatementNode _parseWhileStatement() {
    _expect(CsTokenType.whileKw);
    _expect(CsTokenType.lparen);
    final condition = _parseComparison();
    _expect(CsTokenType.rparen);
    final body = _parseBlock();
    return WhileStatementNode(condition, body);
  }

  StatementNode _parseForStatement() {
    _expect(CsTokenType.forKw);
    _expect(CsTokenType.lparen);

    final init = _parseVariableDeclaration();

    final condition = _parseComparison();
    _expect(CsTokenType.semicolon);

    final update = _parseAssignmentCore();

    _expect(CsTokenType.rparen);
    final body = _parseBlock();
    final whileBody = [...body, update];
    final whileLoop = WhileStatementNode(condition, whileBody);

    return BlockWrapperNode([init, whileLoop]);
  }

  StatementNode _parseReturnStatement() {
    _expect(CsTokenType.returnKw);
    ExpressionNode? value;
    if (!_check(CsTokenType.semicolon)) {
      value = _parseComparison();
    }
    _expect(CsTokenType.semicolon);
    return ReturnStatementNode(value);
  }

  StatementNode _parseCallStatement() {
    final nameToken = _expect(CsTokenType.identifier);
    _expect(CsTokenType.lparen);
    final args = _parseArgumentList();
    _expect(CsTokenType.rparen);
    _expect(CsTokenType.semicolon);
    return ExpressionStatementNode(CallExpressionNode(nameToken.lexeme, args));
  }

  List<ExpressionNode> _parseArgumentList() {
    final args = <ExpressionNode>[];
    if (!_check(CsTokenType.rparen)) {
      args.add(_parseComparison());
      while (_check(CsTokenType.comma)) {
        _advance();
        args.add(_parseComparison());
      }
    }
    return args;
  }

  // ---------- Expressions ----------

  ExpressionNode _parseComparison() {
    var left = _parseExpression();

    const comparisonTypes = {
      CsTokenType.greater,
      CsTokenType.less,
      CsTokenType.greaterEqual,
      CsTokenType.lessEqual,
      CsTokenType.equals,
      CsTokenType.notEquals,
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

    while (_check(CsTokenType.plus) || _check(CsTokenType.minus)) {
      final opToken = _advance();
      final op = opToken.type == CsTokenType.plus ? '+' : '-';
      final right = _parseTerm();
      left = BinaryExpressionNode(left, op, right);
    }

    return left;
  }

  ExpressionNode _parseTerm() {
    var left = _parsePrimary();

    while (_check(CsTokenType.star) ||
        _check(CsTokenType.slash) ||
        _check(CsTokenType.percent)) {
      final opToken = _advance();
      final op = opToken.lexeme;
      final right = _parsePrimary();
      left = BinaryExpressionNode(left, op, right);
    }

    return left;
  }

  ExpressionNode _parsePrimary() {
    final token = _peek();

    if (token.type == CsTokenType.minus) {
      _advance();
      final operand = _parsePrimary();
      return BinaryExpressionNode(NumberLiteralNode(0), '-', operand);
    }

    if (token.type == CsTokenType.stringLiteral) {
      _advance();
      return StringLiteralNode(token.lexeme);
    }
    if (token.type == CsTokenType.numberLiteral) {
      _advance();
      return NumberLiteralNode(int.parse(token.lexeme));
    }
    if (token.type == CsTokenType.identifier) {
      _advance();
      if (_check(CsTokenType.lparen)) {
        _advance();
        final args = _parseArgumentList();
        _expect(CsTokenType.rparen);
        return CallExpressionNode(token.lexeme, args);
      }
      return IdentifierNode(token.lexeme);
    }
    if (token.type == CsTokenType.lparen) {
      _advance();
      final expr = _parseComparison();
      _expect(CsTokenType.rparen);
      return expr;
    }

    throw FormatException(
      'Hindi ma-parse ang expression sa line ${token.line}: hindi inaasahang token na "${token.lexeme}"',
    );
  }

  String _operatorSymbol(CsTokenType type) {
    switch (type) {
      case CsTokenType.greater:
        return '>';
      case CsTokenType.less:
        return '<';
      case CsTokenType.greaterEqual:
        return '>=';
      case CsTokenType.lessEqual:
        return '<=';
      case CsTokenType.equals:
        return '==';
      case CsTokenType.notEquals:
        return '!=';
      default:
        throw FormatException('Hindi kilalang operator type: $type');
    }
  }

  // ---------- Helpers ----------

  Token<CsTokenType> _peek() => tokens[_pos];

  Token<CsTokenType> _peekNext() =>
      _pos + 1 < tokens.length ? tokens[_pos + 1] : tokens[tokens.length - 1];

  Token<CsTokenType> _advance() => tokens[_pos++];

  bool _check(CsTokenType type) => _peek().type == type;

  Token<CsTokenType> _expect(CsTokenType type) {
    if (_check(type)) {
      return _advance();
    }
    throw FormatException(
      'Inaasahan ang "${type.name}" pero "${_peek().lexeme}" (${_peek().type.name}) ang nakita sa line ${_peek().line}',
    );
  }
}
