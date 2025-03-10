import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:lighthouse/features/main_window/data/sources/menu_data.dart';
import 'package:lighthouse/features/main_window/presentation/widget/menu_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenuWidget extends StatefulWidget {
  final Function(int) changeindex;
  const SideMenuWidget({super.key, required this.changeindex});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  late int selectedIndex;
  @override
  void initState() {
    selectedIndex = memory.get<SharedPreferences>().getInt("index") ?? 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = SideMenuData();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [navy, darkNavy],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            width: Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width / 8
                : MediaQuery.of(context).size.width / 3,
            context.locale.languageCode == "en"
                ? "assets/svg/en-logo.svg"
                : "assets/svg/ar-logo.svg",
          ),
          SizedBox(
            height: Responsive.isDesktop(context) ? 50 : 30,
          ),
          Expanded(
            child: ListView.builder(
              
              itemCount: data.menu.length,
              itemBuilder: (context, index) => MenuEntry(
                data: data,
                index: index,
                isSelected: selectedIndex == index,
                onTap: () => setState(() {
                  widget.changeindex(index);
                  selectedIndex = index;
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
