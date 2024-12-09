import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lighthouse_/core/resources/colors.dart';
import 'package:lighthouse_/features/mian_window/data/sources/menu_data.dart';

class SideMenuWidget extends StatefulWidget {
  final Function(int) changeindex;
  const SideMenuWidget({super.key, required this.changeindex});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  int selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    final data = SideMenuData();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      // color: navy,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [navy, darkNavy],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            width: MediaQuery.of(context).size.width / 8,
            context.locale.languageCode == "en"
                ? "assets/svg/en-logo.svg"
                : "assets/svg/ar-logo.svg",
          ),
          SizedBox(
            height: 50,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.menu.length,
              itemBuilder: (context, index) => buildMenuEntry(data, index),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuEntry(SideMenuData data, int index) {
    final isSelected = selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(6.0),
        ),
        color: isSelected ? lightGrey : Colors.transparent,
      ),
      child: InkWell(
        onTap: () => setState(() {
          widget.changeindex(index);
          selectedIndex = index;
        }),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              child: Icon(
                data.menu[index].icon,
                color: isSelected ? orange : lightGrey,
              ),
            ),
            Text(
              data.menu[index].title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? navy : lightGrey,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
