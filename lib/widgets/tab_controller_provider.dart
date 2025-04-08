import 'package:flutter/material.dart';

class TabControllerProvider extends InheritedWidget {
  final void Function(int index) setTab;

  const TabControllerProvider({
  super.key,
  required this.setTab,
  required super.child, // ✅ Dart 3 super parameter
});


  static TabControllerProvider of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<TabControllerProvider>();
    assert(result != null, 'No TabControllerProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
