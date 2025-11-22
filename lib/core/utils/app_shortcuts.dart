import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Intent classes for keyboard shortcuts
class NavigateToHomeIntent extends Intent {
  const NavigateToHomeIntent();
}

class NavigateToClientsIntent extends Intent {
  const NavigateToClientsIntent();
}

class StartExpressSessionIntent extends Intent {
  const StartExpressSessionIntent();
}

class EndPremiumSessionByQrIntent extends Intent {
  const EndPremiumSessionByQrIntent();
}

class EndExpressSessionByQrIntent extends Intent {
  const EndExpressSessionByQrIntent();
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
    // Command+N on Mac (meta key)
    SingleActivator(LogicalKeyboardKey.keyN, meta: true): const StartExpressSessionIntent(),
    // Ctrl+N on Windows/Linux (control key)
    SingleActivator(LogicalKeyboardKey.keyN, control: true): const StartExpressSessionIntent(),
  };
}
