// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/packages/data/models/edit_package_model.dart';

// ignore: must_be_immutable
class PackageCard extends StatefulWidget {
  final PackageModel package;
  // dynamic Function(bool) onChanged;
  void Function() onTap;
  void Function() onPressed;
  PackageCard({
    super.key,
    required this.package,
    required this.onTap,
    required this.onPressed,
  });

  @override
  State<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          decoration: BoxDecoration(
            color: navy,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Premium Package",
                    style: TextStyle(
                        fontSize: 18,
                        color: lightGrey,
                        fontWeight: FontWeight.w900),
                  ),
                  const Spacer(),
                  // Switch(
                  //   title: Text(widget.package.active? "Active":"Inactive"),
                  //   value: widget.package.active,
                  //   onChanged: widget.onChanged,
                  //   activeColor: Colors.green,
                  //   inactiveTrackColor: Colors.red,
                  // ),
                  // LiteRollingSwitch(
                  //   animationDuration: Duration.zero,
                  //   value: widget.package.active,
                  //   colorOn: Colors.green,
                  //   colorOff: Colors.red,
                  //   textOn: 'Active',
                  //   textOff: 'Inactive',
                  //   textOnColor: Colors.white,
                  //   iconOn: Icons.check_circle,
                  //   iconOff: Icons.cancel,
                  //   onTap: () {},
                  //   onDoubleTap: () {},
                  //   onSwipe: () {},
                  //   onChanged: widget.onChanged,
                  // ),
                  FloatingActionButton.small(
                    onPressed: widget.onPressed,
                    backgroundColor: darkNavy,
                    child: const Icon(Icons.edit),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: widget.onTap,
                    child: Container(
                      height: 40,
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: widget.package.active ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      // padding: const EdgeInsets.symmetric(
                      //     vertical: 10, horizontal: 16),
                      child: Text(
                        widget.package.active ? 'Active' : 'Inactive',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ),
                  
                  
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.package.description,
                style: const TextStyle(fontSize: 14, color: grey),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hours".tr(),
                        style: const TextStyle(fontSize: 12, color: orange),
                      ),
                      Text(
                        "${widget.package.numOfHours} ${"hrs".tr()}",
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Price".tr(),
                        style: const TextStyle(fontSize: 12, color: orange),
                      ),
                      Text(
                        "${widget.package.price} ${"S.P".tr()}",
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Duration".tr(),
                        style: const TextStyle(fontSize: 12, color: orange),
                      ),
                      Text(
                        "${widget.package.packageDurationInDays} ${"days".tr()}",
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
