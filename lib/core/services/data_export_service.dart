import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/child_profile.dart';
import '../services/family_profile_service.dart';
import '../../shared/utils/user_progress_storage.dart';

/// P-03 — Eksporti i të dhënave sipas GDPR Neni 20 (portabilitet).
///
/// Prodhon skedar JSON: `mathlingo_data_[date].json`
/// dhe e ndan me Share Sheet.
class DataExportService {
  DataExportService._();

  /// Ndërton dhe ndan JSON-in e plotë. Tregon SnackBar nëse dështon.
  static Future<void> export(BuildContext context) async {
    try {
      final json = await _buildExportJson();
      final jsonString =
          const JsonEncoder.withIndent('  ').convert(json);

      // Shkruaj në direktorinë e temp-it
      final tmpDir = await getTemporaryDirectory();
      final dateStr = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .substring(0, 19);
      final file = File('${tmpDir.path}/mathlingo_data_$dateStr.json');
      await file.writeAsString(jsonString, encoding: utf8);

      // Nda me Share Sheet
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/json')],
          subject: 'MathLingo — Eksporti i të Dhënave',
          text: 'Të dhënat e MathLingo — $dateStr',
        ),
      );
    } on Object catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Eksporti dështoi: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  // --------------------------------------------------------------------------
  // Build JSON
  // --------------------------------------------------------------------------

  static Future<Map<String, dynamic>> _buildExportJson() async {
    final family = FamilyProfileService.loadFamily();
    final exportDate = DateTime.now().toIso8601String();

    final childrenData = <Map<String, dynamic>>[];
    if (family != null) {
      for (final child in family.children) {
        final progress = await UserProgressStorage.load(childId: child.id);
        childrenData.add({
          'profili': _childJson(child),
          'progresi': {
            'totalPike': progress.totalPoints,
            'saktesiaMesatare': progress.averageAccuracy,
            'sesonetKompletuar': progress.moduleSessions.values
                .fold(0, (a, b) => a + b),
            'modulet': progress.moduleSessions,
            'sesonetFundit': progress.recentSessions
                .map((s) => {
                      'pike': s.points,
                      'saktesia': s.accuracy,
                      'moduli': s.moduleKey,
                      'data': s.timestamp.toIso8601String(),
                    })
                .toList(),
          },
        });
      }
    }

    return {
      'aplikacioni': 'MathLingo',
      'versioniEksportit': '1.0',
      'dataEksportit': exportDate,
      'familja': family == null
          ? null
          : {
              'id': family.id,
              'krijuarMe': family.createdAt.toIso8601String(),
              'numriFemijeve': family.children.length,
            },
      'femijët': childrenData,
      'shenim':
          'Të dhënat eksportuara sipas GDPR Neni 20 — Portabilitet i të Dhënave.',
    };
  }

  static Map<String, dynamic> _childJson(ChildProfile child) {
    return {
      'id': child.id,
      'pseudonimi': child.pseudonym,
      'avatarIndex': child.avatarIndex,
      'totalPike': child.totalPoints,
      'saktesiaMesatare': child.totalAccuracy,
      'sesonetKompletuar': child.completedSessions,
      'moduletHistori': child.moduleHistory,
    };
  }
}
