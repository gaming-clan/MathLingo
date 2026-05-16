/// Paraqet një hyrje të tabelës matematikore — në modalitetin klasik ose invers.
///
/// Shembuj modaliteti klasik:
///   5 + 3 = ?   →  answer = 8
///   8 − 3 = ?   →  answer = 5
///
/// Shembuj modaliteti invers:
///   Zbritje → "? + 3 = 8"   (invers i mbledhjes)
///   Pjesëtim → "? × 3 = 21" (plotëso shumëzimin)
class TableQuestion {
  const TableQuestion({
    required this.prompt,
    required this.answer,
  });

  /// Pyetja si tekst (p.sh. "5 + 3 = ?", "? + 3 = 8", "? × 3 = 12")
  final String prompt;

  /// Përgjigja numerike
  final int answer;

  @override
  String toString() => '$prompt  →  $answer';
}
