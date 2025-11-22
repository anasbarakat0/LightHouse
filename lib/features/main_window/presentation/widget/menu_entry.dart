import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:lighthouse/features/main_window/data/sources/menu_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuEntry extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // Check if this is Sign Out (index 10, not 11!)
    final isSignOut = index == 10;

    return Opacity(
      opacity: ((memory.get<SharedPreferences>().getBool("MANAGER") ?? true)
                  ? false
                  : true) &&
              [2, 4, 5, 7, 8, 9].contains(index)
          ? 0.5
          : 1,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: isSignOut
              ? Colors.red
                  .withOpacity(0.15) // Always red background for Sign Out
              : (isSelected ? lightGrey : Colors.transparent),
          border: isSignOut
              ? Border.all(
                  color: Colors.red.shade600, // Stronger red border
                  width: 1.5,
                )
              : null,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                child: Icon(
                  data.menu[index].icon,
                  color: isSignOut
                      ? Colors.red.shade600 // Stronger red for icon
                      : (isSelected ? orange : lightGrey),
                ),
              ),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    data.menu[index].title,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: isSignOut
                              ? FontWeight.w700 // Bolder for Sign Out
                              : (isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400),
                          color: isSignOut
                              ? Colors.red.shade600 // Stronger red for text
                              : (isSelected ? navy : lightGrey),
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
