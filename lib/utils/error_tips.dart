/// Turns a raw compiler error message into a beginner-friendly tip.
///
/// This is the same logic that used to live only inside
/// `_CodeEditorScreenState._friendlyTip` in code_editor_screen.dart. It's
/// pulled out here so the exercise checker (exercise_screen.dart) can show
/// the exact same tips without duplicating the list, and so the wording
/// only needs to be updated in one place.
///
/// Optional cleanup: you can delete `_friendlyTip` from
/// code_editor_screen.dart and call `ErrorTips.friendlyTip(...)` there
/// instead, so both screens read from this single source of truth.
class ErrorTips {
  ErrorTips._();

  static String? friendlyTip(String errorMessage) {
    final msg = errorMessage.toLowerCase();

    if (msg.contains('semicolon')) {
      return 'Baka nakalimutan mong maglagay ng ";" sa dulo ng isang linya.';
    }
    if (msg.contains('rparen') || msg.contains('lparen')) {
      return 'I-check mo kung magkatugma ang bilang ng "(" at ")" sa code mo.';
    }
    if (msg.contains('rbrace') || msg.contains('lbrace')) {
      return 'I-check mo kung magkatugma ang bilang ng "{" at "}" sa code mo.';
    }
    if (msg.contains('indentation')) {
      return 'Sa Python, importante ang consistent na indentation. '
          'Gumamit ng 4 spaces bawat level.';
    }
    if (msg.contains('hindi kilalang variable')) {
      return 'Siguraduhin mong na-declare/na-assign mo muna ang variable '
          'bago mo gamitin.';
    }
    if (msg.contains('hindi kilalang function')) {
      return 'I-check mo ang spelling ng function name, at kung na-define '
          'mo na ba ito.';
    }
    if (msg.contains('divide ng 0')) {
      return 'Hindi pwedeng hatiin ang isang numero sa 0.';
    }
    if (msg.contains('argumento')) {
      return 'I-check mo kung tumutugma ang bilang ng arguments sa bilang '
          'ng parameters.';
    }
    if (msg.contains('hindi kilalang character')) {
      return 'May character sa code mo na hindi kilala ng compiler — baka '
          'typo o maling symbol.';
    }
    return null;
  }

  /// Extra tip shown when the code RAN successfully but the output did
  /// not match what was expected — a different failure mode from a
  /// compiler error, so it needs its own hint.
  static String outputMismatchTip() {
    return 'Tumakbo ang code mo nang walang error, pero hindi tugma ang '
        'output. I-check mo ang exact spelling, spacing, at capitalization '
        'ng iniprint mo — kailangan itong eksaktong tumugma.';
  }
}
