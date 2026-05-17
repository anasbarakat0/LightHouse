import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/main_scaffold_key.dart';
import 'package:lighthouse/core/utils/responsive.dart';

class HeaderWidget extends StatefulWidget {
  final String title;
  final Color foregroundColor;

  const HeaderWidget({
    super.key,
    required this.title,
    this.foregroundColor = navy,
  });

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  TextEditingController searchController = TextEditingController();

  void _openDrawer() {
    final mainScaffoldState = mainScaffoldKey.currentState;
    if (mainScaffoldState != null) {
      mainScaffoldState.openDrawer();
      return;
    }

    Scaffold.maybeOf(context)?.openDrawer();
  }

  void _openEndDrawer() {
    final mainScaffoldState = mainScaffoldKey.currentState;
    if (mainScaffoldState != null) {
      mainScaffoldState.openEndDrawer();
      return;
    }

    Scaffold.maybeOf(context)?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: Icon(
              Icons.menu,
              color: widget.foregroundColor,
              size: 25,
            ),
            onPressed: _openDrawer,
          ),
        if (!Responsive.isDesktop(context))
          Expanded(
            child: Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: widget.foregroundColor),
            ),
          ),
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: SvgPicture.asset(
              "assets/svg/summary_chart.svg",
              width: 23,
              height: 23,
              colorFilter: ColorFilter.mode(
                widget.foregroundColor,
                BlendMode.srcIn,
              ),
            ),
            onPressed: _openEndDrawer,
          ),
      ],
    );
  }
}
