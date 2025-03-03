// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/home/data/models/active_sessions_response_model.dart';

// ignore: must_be_immutable
class PremiumClientCardWidget extends StatelessWidget {
  BuildContext context;
  ActivePremiumSession premiumSession;
  Function() onPressed;
  PremiumClientCardWidget({
    super.key,
    required this.context,
    required this.premiumSession,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Card(
          color: lightGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        "${premiumSession.firstName} ${premiumSession.lastName}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${'started_at'.tr()}: ${premiumSession.startTime}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const Spacer(),
                    Text(
                      '${'created_by'.tr()}: ${premiumSession.createdBy.firstName} ${premiumSession.createdBy.lastName}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const Icon(
                  Icons.stars_sharp,
                  color: yellow,
                ),
              ],
            ),
          ),
        ),
        FloatingActionButton.small(
          onPressed: onPressed,
          shape: const CircleBorder(),
          elevation: 10,
          foregroundColor: navy,
          backgroundColor: orange,
          child: const Icon(
            Icons.info_outline,
          ),
          
        ),
      ],
    );
  }
}