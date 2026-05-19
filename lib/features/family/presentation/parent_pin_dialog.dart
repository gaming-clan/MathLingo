import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../core/services/family_profile_service.dart';

/// Dialog për verifikimin e PIN-it prindëror.
///
/// Kthen `true` nëse PIN-i është i saktë (ose nuk ekziston PIN).
/// Kthen `false` nëse përdoruesi anuloi ose PIN-i ishte i gabuar 3 herë.
class ParentPinDialog extends StatefulWidget {
  const ParentPinDialog({super.key});

  @override
  State<ParentPinDialog> createState() => _ParentPinDialogState();

  /// Metoda statike për thirrje të lehtë.
  static Future<bool> verify(BuildContext context) async {
    if (!FamilyProfileService.hasParentPin) return true;
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ParentPinDialog(),
    );
    return result ?? false;
  }
}

class _ParentPinDialogState extends State<ParentPinDialog> {
  final _controller = TextEditingController();
  String? _errorText;
  int _attempts = 0;
  static const _maxAttempts = 3;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onConfirm() {
    final pin = _controller.text.trim();
    if (FamilyProfileService.verifyParentPin(pin)) {
      Navigator.of(context).pop(true);
    } else {
      _attempts++;
      if (_attempts >= _maxAttempts) {
        Navigator.of(context).pop(false);
        return;
      }
      setState(() {
        _errorText =
            'PIN i gabuar. Mbeten ${_maxAttempts - _attempts} tentativa.';
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CosmicColors.surface,
      title: Text(
        'PIN-i prindëror',
        style: TextStyle(
          color: CosmicColors.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Vendos PIN-in për të vazhduar.',
            style: TextStyle(color: CosmicColors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 4,
            onSubmitted: (_) => _onConfirm(),
            decoration: InputDecoration(
              hintText: '• • • •',
              hintStyle: const TextStyle(
                color: Colors.white38,
                fontSize: 24,
                letterSpacing: 8,
              ),
              errorText: _errorText,
              counterText: '',
              filled: true,
              fillColor: CosmicColors.surfaceLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(
              color: CosmicColors.onSurface,
              fontSize: 24,
              letterSpacing: 8,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Anulo',
            style: TextStyle(color: CosmicColors.onSurfaceVariant),
          ),
        ),
        FilledButton(
          onPressed: _onConfirm,
          style: FilledButton.styleFrom(
            backgroundColor: CosmicColors.primaryContainer,
          ),
          child: const Text('Konfirmo'),
        ),
      ],
    );
  }
}

/// Dialog për vendosjen e PIN-it prindëror (here e parë / ndryshim).
class SetParentPinDialog extends StatefulWidget {
  const SetParentPinDialog({super.key});

  @override
  State<SetParentPinDialog> createState() => _SetParentPinDialogState();

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => const SetParentPinDialog(),
    );
    return result ?? false;
  }
}

class _SetParentPinDialogState extends State<SetParentPinDialog> {
  final _pin1 = TextEditingController();
  final _pin2 = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _pin1.dispose();
    _pin2.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final p1 = _pin1.text.trim();
    final p2 = _pin2.text.trim();
    if (p1.length != 4 || !RegExp(r'^\d{4}$').hasMatch(p1)) {
      setState(() => _errorText = 'PIN duhet të jetë 4 shifra.');
      return;
    }
    if (p1 != p2) {
      setState(() => _errorText = 'PIN-et nuk përputhen.');
      return;
    }
    await FamilyProfileService.setParentPin(p1);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CosmicColors.surface,
      title: Text(
        'Vendos PIN-in prindëror',
        style: TextStyle(
          color: CosmicColors.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'PIN-i mbron veprimet administrative (shto ose fshi fëmijë).',
            style: TextStyle(color: CosmicColors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          _PinField(controller: _pin1, hint: 'PIN i ri (4 shifra)'),
          const SizedBox(height: 12),
          _PinField(
            controller: _pin2,
            hint: 'Konfirmo PIN-in',
            onSubmitted: (_) => _onSave(),
          ),
          if (_errorText != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorText!,
              style: TextStyle(color: CosmicColors.error, fontSize: 12),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Anulo',
            style: TextStyle(color: CosmicColors.onSurfaceVariant),
          ),
        ),
        FilledButton(
          onPressed: _onSave,
          style: FilledButton.styleFrom(
            backgroundColor: CosmicColors.primaryContainer,
          ),
          child: const Text('Ruaj'),
        ),
      ],
    );
  }
}

class _PinField extends StatelessWidget {
  const _PinField({
    required this.controller,
    required this.hint,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      obscureText: true,
      maxLength: 4,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.white38,
          fontSize: 20,
          letterSpacing: 6,
        ),
        counterText: '',
        filled: true,
        fillColor: CosmicColors.surfaceLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(
        color: CosmicColors.onSurface,
        fontSize: 20,
        letterSpacing: 6,
      ),
      textAlign: TextAlign.center,
    );
  }
}
