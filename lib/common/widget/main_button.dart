// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lighthouse_/core/resources/colors.dart';

// ignore: must_be_immutable
class MainButton extends StatelessWidget {
  final String title;
  void Function() onTap;
  MainButton({
    super.key,
    required this.onTap, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 69,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: primaryColor,
          ),
          child: FittedBox(
            child: Row(
              children: [
                const Icon(Icons.person_add_sharp),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
