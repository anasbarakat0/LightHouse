import 'package:flutter/material.dart';

// Intent classes for keyboard shortcuts
class NavigateToHomeIntent extends Intent {
  const NavigateToHomeIntent();
}

class NavigateToClientsIntent extends Intent {
  const NavigateToClientsIntent();
}

class EndPremiumSessionByQrIntent extends Intent {
  const EndPremiumSessionByQrIntent();
}

// Global shortcuts configuration (for MainScreen)
Map<LogicalKeySet, Intent> getGlobalShortcuts() {
  return {
    // All shortcuts disabled
    // LogicalKeySet(LogicalKeyboardKey.keyH): const NavigateToHomeIntent(),
    // LogicalKeySet(LogicalKeyboardKey.keyF): const NavigateToClientsIntent(),
  };
}

// Home screen shortcuts configuration (for HomeScreen only)
Map<ShortcutActivator, Intent> getHomeScreenShortcuts() {
  return {
    // All shortcuts disabled
  };
}
