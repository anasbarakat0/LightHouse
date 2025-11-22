import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:lighthouse/core/utils/task_notifier.dart';
import 'package:lighthouse/features/main_window/presentation/widget/custom_cart.dart';
import 'package:lighthouse/features/main_window/presentation/widget/details_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SummaryDetails extends StatefulWidget {
  final int visits;
  final int onGround;
  const SummaryDetails({
    super.key,
    required this.visits,
    required this.onGround,
  });

  @override
  State<SummaryDetails> createState() => _SummaryDetailsState();
}

class _SummaryDetailsState extends State<SummaryDetails> {
  late int capacity;
  @override
  void initState() {
    super.initState();
    capacity = memory.get<SharedPreferences>().getInt("capacity") ?? 100;
    capacityNotifier.addListener(_onCapacityChanged);
  }

  void _onCapacityChanged() {
    if (mounted) {
      setState(() {
        capacity = capacityNotifier.value;
      });
    }
  }

  @override
  void dispose() {
    capacityNotifier.removeListener(_onCapacityChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool row = MediaQuery.of(context).size.width > 1460;
    bool isDesktop = Responsive.isDesktop(context);
    bool isMobile = Responsive.isMobile(context);
    return CustomCard(
      color: lightGrey,
      child: isDesktop && !row
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DetailsWidget(label: 'on_ground'.tr(), value: widget.onGround),
                SizedBox(
                    width: 100, child: Divider(thickness: 1, color: orange)),
                DetailsWidget(label: 'visits'.tr(), value: widget.visits),
                SizedBox(
                    width: 100, child: Divider(thickness: 1, color: orange)),
                DetailsWidget(label: 'capacity1'.tr(), value: capacity),
              ],
            )
          : isMobile
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DetailsWidget(
                        label: 'on_ground'.tr(), value: widget.onGround),
                    SizedBox(
                        width: 100,
                        child: Divider(thickness: 1, color: orange)),
                    DetailsWidget(label: 'visits'.tr(), value: widget.visits),
                    SizedBox(
                        width: 100,
                        child: Divider(thickness: 1, color: orange)),
                    DetailsWidget(label: 'capacity1'.tr(), value: capacity),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DetailsWidget(
                        label: 'on_ground'.tr(), value: widget.onGround),
                    DetailsWidget(label: 'visits'.tr(), value: widget.visits),
                    DetailsWidget(label: 'capacity1'.tr(), value: capacity),
                  ],
                ),
    );
  }
}
