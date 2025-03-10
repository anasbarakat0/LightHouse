import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/icon_text_widget.dart';

class ClientInfoWidget extends StatelessWidget {
  final String uuid;
  final String email;
  final String phoneNumber;
  final String study;
  final String gender;
  final String? birthDate;
  final Color color;

  const ClientInfoWidget({
    super.key,
    required this.uuid,
    required this.email,
    required this.phoneNumber,
    required this.study,
    required this.gender,
    required this.birthDate,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(child: IconTextWidget(icon: "ID", text: uuid, color: color)),
          const SizedBox(height: 5),
          IconTextWidget(icon: "email", text: email, color: color),
          const SizedBox(height: 5),
          IconTextWidget(icon: "mobile", text: phoneNumber, color: color),
          const SizedBox(height: 5),
          IconTextWidget(icon: "study", text: study, color: color),
          const SizedBox(height: 5),
          Row(
            children: [
              SvgPicture.asset("assets/svg/gender.svg",
                  width: 23, height: 23, color: color),
              const SizedBox(width: 10),
              Text(gender.toLowerCase().tr(),
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 5),
          IconTextWidget(
            icon: "birth_date",
            text: DateFormat('yyyy/MM/dd').format(
              DateTime.parse(birthDate ?? "2024-10-30T18:16:35.808397918"),
            ),
            color: color,
          ),
        ],
      ),
    );
  }
}
