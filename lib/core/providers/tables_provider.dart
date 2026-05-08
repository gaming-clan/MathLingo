import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------
class TablesState {
  const TablesState({
    this.selectedTable = 1,
    this.selectedOperationIndex = 0,
  });

  final int selectedTable;
  final int selectedOperationIndex;

  TablesState copyWith({int? selectedTable, int? selectedOperationIndex}) {
    return TablesState(
      selectedTable: selectedTable ?? this.selectedTable,
      selectedOperationIndex:
          selectedOperationIndex ?? this.selectedOperationIndex,
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
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------
final tablesProvider =
    StateNotifierProvider<TablesNotifier, TablesState>(
  (ref) => TablesNotifier(),
);
