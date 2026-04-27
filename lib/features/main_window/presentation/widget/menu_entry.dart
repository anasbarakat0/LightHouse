import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:lighthouse/features/main_window/data/sources/menu_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuEntry extends StatefulWidget {
  final SideMenuData data;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const MenuEntry({
    super.key,
    required this.data,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<MenuEntry> createState() => _MenuEntryState();
}

class _MenuEntryState extends State<MenuEntry> {
  bool _isHovered = false;

  // Helper function to check if user has access to a specific page
  bool _hasAccessToPage(int index) {
    final role =
        memory.get<SharedPreferences>().getString("userRole") ?? "USER";

    // Pages accessible only to SuperAdmin and MANAGER
    final restrictedPages = [
      0,
      2,
      5,
      6,
      9
    ]; // Dashboard, Statistics, Packages, Coupons, Admin Management

    if (restrictedPages.contains(index)) {
      return role == "SuperAdmin" || role == "MANAGER";
    }

    // Pages accessible to SuperAdmin, MANAGER, and ADMIN
    return role == "SuperAdmin" || role == "MANAGER" || role == "ADMIN";
  }

  @override
  Widget build(BuildContext context) {
    final isSignOut = widget.index == widget.data.menu.length - 1;
    final hasAccess = isSignOut || _hasAccessToPage(widget.index);
    final hoverSurfaceColor =
        isSignOut ? Colors.red.withValues(alpha: 0.2) : const Color(0xFF173F62);
    final surfaceColor = isSignOut
        ? Colors.red.withValues(alpha: _isHovered ? 0.2 : 0.15)
        : widget.isSelected
            ? lightGrey
            : _isHovered
                ? hoverSurfaceColor
                : Colors.transparent;
    final iconColor = isSignOut
        ? Colors.red.shade600
        : widget.isSelected
            ? orange
            : _isHovered
                ? Colors.white
                : lightGrey;
    final textColor = isSignOut
        ? Colors.red.shade600
        : widget.isSelected
            ? navy
            : _isHovered
                ? Colors.white
                : lightGrey;
    final border = isSignOut
        ? Border.all(
            color: Colors.red.shade600,
            width: 1.5,
          )
        : _isHovered && !widget.isSelected
            ? Border.all(color: Colors.white.withValues(alpha: 0.14))
            : null;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Opacity(
        opacity: hasAccess ? 1 : 0.5,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            color: surfaceColor,
            border: border,
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.24),
                      blurRadius: 16,
                      offset: const Offset(0, 9),
                    ),
                    BoxShadow(
                      color: (isSignOut ? Colors.red : orange)
                          .withValues(alpha: 0.08),
                      blurRadius: 22,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                  child: Icon(
                    widget.data.menu[widget.index].icon,
                    color: iconColor,
                  ),
                ),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      widget.data.menu[widget.index].title,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: isSignOut
                                ? FontWeight.w700
                                : (widget.isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400),
                            color: textColor,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
