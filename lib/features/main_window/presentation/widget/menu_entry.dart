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
    return Opacity(
      opacity: ((memory.get<SharedPreferences>().getBool("MANAGER") ?? true)? false:true) &&
              [0, 2, 4, 5, 7, 8, 9].contains(index)
          ? 0.5
          : 1,
      child: Container(
        // alignment: Al,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          color: isSelected ? lightGrey : Colors.transparent,
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                child: Icon(
                  data.menu[index].icon,
                  color: isSelected ? orange : lightGrey,
                ),
              ),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    data.menu[index].title,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? navy : lightGrey,
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
