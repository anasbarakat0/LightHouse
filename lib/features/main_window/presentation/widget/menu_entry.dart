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

  // Helper function to check if user has access to a specific page
  bool _hasAccessToPage(int index) {
    final role = memory.get<SharedPreferences>().getString("userRole") ?? "USER";
    
    // Pages accessible only to SuperAdmin and MANAGER
    final restrictedPages = [0, 2, 4, 5, 8]; // Dashboard, Statistics, Packages, Coupons, Admin Management
    
    if (restrictedPages.contains(index)) {
      return role == "SuperAdmin" || role == "MANAGER";
    }
    
    // Pages accessible to SuperAdmin, MANAGER, and ADMIN
    return role == "SuperAdmin" || role == "MANAGER" || role == "ADMIN";
  }

  @override
  Widget build(BuildContext context) {
    // Check if this is Sign Out (index 10, not 11!)
    final isSignOut = index == 10;
    final hasAccess = _hasAccessToPage(index);

    return Opacity(
      opacity: hasAccess ? 1 : 0.5,
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
