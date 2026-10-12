import '../token.dart';
import 'python_token_type.dart';
import 'python_ast.dart';

class PythonParser {
  final List<Token<PythonTokenType>> tokens;
  int _pos = 0;

  /// Ilang loop ang kasalukuyang nakabukas — para malaman kung valid
  /// ang "break"/"continue" (bawal sa labas ng loop).
  int _loopDepth = 0;

  PythonParser(this.tokens);

  ProgramNode parseProgram() {
    final statements = <StatementNode>[];
    _skipNewlines();
    while (!_check(PythonTokenType.eof)) {
      statements.add(_parseStatement());
      _skipNewlines();
    }
    return ProgramNode(statements);
  }

  // ---------- Blocks (indentation-based) ----------

  /// Isang block ay: ":" NEWLINE INDENT statement+ DEDENT
  /// Ang ":" ay dapat na-consume na ng caller bago tawagin ito.
  List<StatementNode> _parseBlock() {
    _expect(PythonTokenType.newline);
    _expect(PythonTokenType.indent);

    final statements = <StatementNode>[];
    _skipNewlines();
    while (!_check(PythonTokenType.dedent)) {
      statements.add(_parseStatement());
      _skipNewlines();
    }
    _expect(PythonTokenType.dedent);
    return statements;
  }

  void _skipNewlines() {
    while (_check(PythonTokenType.newline)) {
      _advance();
    }
  }

  // ---------- Statements ----------

  StatementNode _parseStatement() {
    if (_check(PythonTokenType.defKw)) {
      return _parseFunctionDef();
    }
    if (_check(PythonTokenType.ifKw)) {
      return _parseIfStatement();
    }
    if (_check(PythonTokenType.whileKw)) {
      return _parseWhileStatement();
    }
    if (_check(PythonTokenType.forKw)) {
      return _parseForStatement();
    }
    if (_check(PythonTokenType.returnKw)) {
      return _parseReturnStatement();
    }
    if (_check(PythonTokenType.breakKw)) {
      return _parseBreakStatement();
    }
    if (_check(PythonTokenType.continueKw)) {
      return _parseContinueStatement();
    }
    if (_check(PythonTokenType.identifier) && _peek().lexeme == 'print') {
      return _parsePrintStatement();
    }
    if (_check(PythonTokenType.identifier) &&
        _peekNext().type == PythonTokenType.lparen) {
      return _parseCallStatement();
    }
    if (_check(PythonTokenType.identifier)) {
      return _parseAssignmentStatement();
    }
    throw FormatException(
      'Hindi ma-parse ang statement sa line ${_peek().line}: hindi kilalang statement na nagsisimula sa "${_peek().lexeme}"',
    );
  }

  StatementNode _parseFunctionDef() {
    _expect(PythonTokenType.defKw);
    final nameToken = _expect(PythonTokenType.identifier);
    _expect(PythonTokenType.lparen);

    final params = <String>[];
    if (!_check(PythonTokenType.rparen)) {
      params.add(_expect(PythonTokenType.identifier).lexeme);
      while (_check(PythonTokenType.comma)) {
        _advance();
        params.add(_expect(PythonTokenType.identifier).lexeme);
      }
    }
    _expect(PythonTokenType.rparen);
    _expect(PythonTokenType.colon);

    // Bagong function = bagong "loop context" (hindi pwedeng mag-break
    // mula sa loob ng function papunta sa loop sa labas nito).
    final savedLoopDepth = _loopDepth;
    _loopDepth = 0;
    final List<StatementNode> body;
    try {
      body = _parseBlock();
    } finally {
      _loopDepth = savedLoopDepth;
    }
    return FunctionDefNode(nameToken.lexeme, params, body);
  }

  StatementNode _parseAssignmentStatement() {
    final assignment = _parseAssignmentCore();
    _expect(PythonTokenType.newline);
    return assignment;
  }

  /// Sinusuportahan: x = expr, x += expr, x -= expr, x *= expr, x /= expr,
  /// x %= expr, x++, x--  (lahat ay ginagawang simpleng assignment).
  AssignmentStatementNode _parseAssignmentCore() {
    final nameToken = _expect(PythonTokenType.identifier);
    final opType = _peek().type;
    const compound = <PythonTokenType, String>{
      PythonTokenType.plus: '+',
      PythonTokenType.minus: '-',
      PythonTokenType.star: '*',
      PythonTokenType.slash: '/',
      PythonTokenType.percent: '%',
    };
    if (compound.containsKey(opType)) {
      final op = compound[opType]!;
      final next = _peekNext().type;
      if (next == PythonTokenType.assign) {
        _advance();
        _advance();
        final value = _parseOr();
        return AssignmentStatementNode(
          nameToken.lexeme,
          BinaryExpressionNode(IdentifierNode(nameToken.lexeme), op, value),
        );
      }
    }
    _expect(PythonTokenType.assign);
    final value = _parseOr();
    return AssignmentStatementNode(nameToken.lexeme, value);
  }

  StatementNode _parsePrintStatement() {
    _expect(PythonTokenType.identifier); // "print"
    _expect(PythonTokenType.lparen);
    final args = _parseArgumentList();
    _expect(PythonTokenType.rparen);
    _expect(PythonTokenType.newline);
    return PrintStatementNode(args);
  }

  StatementNode _parseIfStatement() {
    if (_check(PythonTokenType.elifKw)) {
      _advance();
    } else {
      _expect(PythonTokenType.ifKw);
    }
    final condition = _parseOr();
    _expect(PythonTokenType.colon);
    final thenBranch = _parseBlock();

    List<StatementNode>? elseBranch;
    if (_check(PythonTokenType.elifKw)) {
      elseBranch = [_parseIfStatement()];
    } else if (_check(PythonTokenType.elseKw)) {
      _advance();
      _expect(PythonTokenType.colon);
      elseBranch = _parseBlock();
    }

    return IfStatementNode(condition, thenBranch, elseBranch);
  }

  StatementNode _parseWhileStatement() {
    _expect(PythonTokenType.whileKw);
    final condition = _parseOr();
    _expect(PythonTokenType.colon);
    _loopDepth++;
    final List<StatementNode> body;
    try {
      body = _parseBlock();
    } finally {
      _loopDepth--;
    }
    return WhileStatementNode(condition, body);
  }

  StatementNode _parseForStatement() {
    _expect(PythonTokenType.forKw);
    final varToken = _expect(PythonTokenType.identifier);
    _expect(PythonTokenType.inKw);

    final rangeToken = _expect(PythonTokenType.identifier);
    if (rangeToken.lexeme != 'range') {
      throw FormatException(
        'Sa ngayon, suportado lang ang "for x in range(...)" na uri ng loop, sa line ${rangeToken.line}.',
      );
    }
    _expect(PythonTokenType.lparen);
    final args = <ExpressionNode>[_parseOr()];
    while (_check(PythonTokenType.comma)) {
      _advance();
      args.add(_parseOr());
    }
    _expect(PythonTokenType.rparen);
    _expect(PythonTokenType.colon);

    _loopDepth++;
    final List<StatementNode> body;
    try {
      body = _parseBlock();
    } finally {
      _loopDepth--;
    }
    return ForRangeStatementNode(varToken.lexeme, args, body);
  }

  StatementNode _parseReturnStatement() {
    _expect(PythonTokenType.returnKw);
    ExpressionNode? value;
    if (!_check(PythonTokenType.newline)) {
      value = _parseOr();
    }
    _expect(PythonTokenType.newline);
    return ReturnStatementNode(value);
  }

  StatementNode _parseBreakStatement() {
    final kw = _expect(PythonTokenType.breakKw);
    if (_loopDepth == 0) {
      throw FormatException(
        'Hindi pwedeng gamitin ang \"break\" sa labas ng loop (line ${kw.line}).',
      );
    }
    _expect(PythonTokenType.newline);
    return BreakStatementNode();
  }

  StatementNode _parseContinueStatement() {
    final kw = _expect(PythonTokenType.continueKw);
    if (_loopDepth == 0) {
      throw FormatException(
        'Hindi pwedeng gamitin ang \"continue\" sa labas ng loop (line ${kw.line}).',
      );
    }
    _expect(PythonTokenType.newline);
    return ContinueStatementNode();
  }

  StatementNode _parseCallStatement() {
    final nameToken = _expect(PythonTokenType.identifier);
    _expect(PythonTokenType.lparen);
    final args = _parseArgumentList();
    _expect(PythonTokenType.rparen);
    _expect(PythonTokenType.newline);
    return ExpressionStatementNode(CallExpressionNode(nameToken.lexeme, args));
  }

  List<ExpressionNode> _parseArgumentList() {
    final args = <ExpressionNode>[];
    if (!_check(PythonTokenType.rparen)) {
      args.add(_parseOr());
      while (_check(PythonTokenType.comma)) {
        _advance();
        args.add(_parseOr());
      }
    }
    return args;
  }

  // ---------- Expressions (may precedence na) ----------

  // Precedence (pinakamababa -> pinakamataas): or, and, not, comparison

  ExpressionNode _parseOr() {
    var left = _parseAnd();
    while (_check(PythonTokenType.orKw)) {
      _advance();
      final right = _parseAnd();
      left = BinaryExpressionNode(left, 'or', right);
    }
    return left;
  }

  ExpressionNode _parseAnd() {
    var left = _parseNot();
    while (_check(PythonTokenType.andKw)) {
      _advance();
      final right = _parseNot();
      left = BinaryExpressionNode(left, 'and', right);
    }
    return left;
  }

  ExpressionNode _parseNot() {
    if (_check(PythonTokenType.notKw)) {
      _advance();
      final operand = _parseNot(); // pwedeng "not not x"
      return UnaryExpressionNode('not', operand);
    }
    return _parseComparison();
  }

  ExpressionNode _parseComparison() {
    var left = _parseExpression();

    const comparisonTypes = {
      PythonTokenType.greater,
      PythonTokenType.less,
      PythonTokenType.greaterEqual,
      PythonTokenType.lessEqual,
      PythonTokenType.equals,
      PythonTokenType.notEquals,
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

    while (_check(PythonTokenType.plus) || _check(PythonTokenType.minus)) {
      final opToken = _advance();
      final op = opToken.type == PythonTokenType.plus ? '+' : '-';
      final right = _parseTerm();
      left = BinaryExpressionNode(left, op, right);
    }

    return left;
  }

  ExpressionNode _parseTerm() {
    var left = _parsePower();

    while (_check(PythonTokenType.star) ||
        _check(PythonTokenType.slash) ||
        _check(PythonTokenType.slashSlash) ||
        _check(PythonTokenType.percent)) {
      final opToken = _advance();
      final op = opToken.lexeme;
      final right = _parsePower();
      left = BinaryExpressionNode(left, op, right);
    }

    return left;
  }

  // ** (exponent) — mas mataas ang precedence kaysa * at /, at right-associative
  ExpressionNode _parsePower() {
    final base = _parsePrimary();
    if (_check(PythonTokenType.starStar)) {
      _advance();
      final exponent = _parsePower();
      return BinaryExpressionNode(base, '**', exponent);
    }
    return base;
  }

  ExpressionNode _parsePrimary() {
    final token = _peek();

    if (token.type == PythonTokenType.minus) {
      _advance();
      final operand = _parsePrimary();
      return BinaryExpressionNode(NumberLiteralNode(0), '-', operand);
    }

    if (token.type == PythonTokenType.stringLiteral) {
      _advance();
      return StringLiteralNode(token.lexeme);
    }
    if (token.type == PythonTokenType.numberLiteral) {
      _advance();
      return NumberLiteralNode(int.parse(token.lexeme));
    }
    if (token.type == PythonTokenType.identifier) {
      _advance();
      if (_check(PythonTokenType.lparen)) {
        _advance();
        final args = _parseArgumentList();
        _expect(PythonTokenType.rparen);
        return CallExpressionNode(token.lexeme, args);
      }
      return IdentifierNode(token.lexeme);
    }
    if (token.type == PythonTokenType.lparen) {
      _advance();
      final expr = _parseOr();
      _expect(PythonTokenType.rparen);
      return expr;
    }

    throw FormatException(
      'Hindi ma-parse ang expression sa line ${token.line}: hindi inaasahang token na "${token.lexeme}"',
    );
  }

  String _operatorSymbol(PythonTokenType type) {
    switch (type) {
      case PythonTokenType.greater:
        return '>';
      case PythonTokenType.less:
        return '<';
      case PythonTokenType.greaterEqual:
        return '>=';
      case PythonTokenType.lessEqual:
        return '<=';
      case PythonTokenType.equals:
        return '==';
      case PythonTokenType.notEquals:
        return '!=';
      default:
        throw FormatException('Hindi kilalang operator type: $type');
    }
  }

  // ---------- Helpers ----------

  Token<PythonTokenType> _peek() => tokens[_pos];

  Token<PythonTokenType> _peekNext() =>
      _pos + 1 < tokens.length ? tokens[_pos + 1] : tokens[tokens.length - 1];

  Token<PythonTokenType> _advance() => tokens[_pos++];

  bool _check(PythonTokenType type) => _peek().type == type;

  Token<PythonTokenType> _expect(PythonTokenType type) {
    if (_check(type)) {
      return _advance();
    }
    throw FormatException(
      'Inaasahan ang "${type.name}" pero "${_peek().lexeme}" (${_peek().type.name}) ang nakita sa line ${_peek().line}',
    );
  }
}
