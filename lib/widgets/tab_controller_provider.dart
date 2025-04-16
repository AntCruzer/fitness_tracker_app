// IMPORTS CORE FLUTTER MATERIAL WIDGETS
import 'package:flutter/material.dart';


// DEFINES A CUSTOM INHERITED WIDGET TO EXPOSE TAB SWITCHING LOGIC TO DESCENDANTS
class TabControllerProvider extends InheritedWidget {

  // FUNCTION TO SET THE CURRENT TAB INDEX IN THE SHELL
  final void Function(int index) setTab;

  // CONSTRUCTOR TO INITIALIZE THE PROVIDER AND PASS CHILD WIDGET
  const TabControllerProvider({
    super.key,             // OPTIONAL KEY FOR THE WIDGET TREE
    required this.setTab,  // FUNCTION REQUIRED TO CONTROL TABS
    required super.child,  // REQUIRED CHILD WIDGET TO BE WRAPPED
  });

  // STATIC METHOD TO ACCESS THIS PROVIDER FROM ANY DESCENDANT WIDGET IN THE TREE
  static TabControllerProvider of(BuildContext context) {
    
    // LOOKS UP THE NEAREST INSTANCE OF THIS PROVIDER IN THE WIDGET TREE
    final result = context.dependOnInheritedWidgetOfExactType<TabControllerProvider>();

    // ASSERTS THAT A PROVIDER INSTANCE EXISTS, OTHERWISE THROWS ERROR
    assert(result != null, 'No TabControllerProvider found in context');

    // RETURNS THE INSTANCE OF THE PROVIDER
    return result!;
  }

  // DEFINES WHETHER THE WIDGET SHOULD NOTIFY ITS DEPENDENTS ON UPDATE
  // RETURNING FALSE INDICATES IT NEVER NEEDS TO TRIGGER A REBUILD
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}