import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------
class TablesState {
  const TablesState({
    this.selectedTable = 1,
    this.selectedOperationIndex = 0,
    this.isInverseMode = false,
  });

  final int selectedTable;
  final int selectedOperationIndex;

  /// Kur true: zbritja shfaqet si "? + b = a", pjesëtimi si "? × b = a"
  final bool isInverseMode;

  TablesState copyWith({
    int? selectedTable,
    int? selectedOperationIndex,
    bool? isInverseMode,
  }) {
    return TablesState(
      selectedTable: selectedTable ?? this.selectedTable,
      selectedOperationIndex:
          selectedOperationIndex ?? this.selectedOperationIndex,
      isInverseMode: isInverseMode ?? this.isInverseMode,
    );
  }
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------
class TablesNotifier extends StateNotifier<TablesState> {
  TablesNotifier() : super(const TablesState());

  void selectTable(int table) {
    state = state.copyWith(selectedTable: table);
  }

  void selectOperation(int index) {
    state = state.copyWith(selectedOperationIndex: index);
  }

  void toggleInverseMode() {
    state = state.copyWith(isInverseMode: !state.isInverseMode);
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------
final tablesProvider =
    StateNotifierProvider<TablesNotifier, TablesState>(
  (ref) => TablesNotifier(),
);
