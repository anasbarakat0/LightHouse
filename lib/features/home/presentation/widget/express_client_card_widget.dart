// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/home/data/models/active_sessions_response_model.dart';

// ignore: must_be_immutable
class ExpressClientCardWidget extends StatelessWidget {
  BuildContext context;
  ActiveExpressSession expressSession;
  Function() onTap;
  Function() onPressed;
  ExpressClientCardWidget({
    super.key,
    required this.context,
    required this.expressSession,
    required this.onTap,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        InkWell(
          onTap: onTap,
          child: Card(
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
                          expressSession.fullName,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(overflow: TextOverflow.ellipsis),
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${'started_at'.tr()}: ${expressSession.startTime}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: grey, overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 178,
                        child: Text(
                          '${'created_by'.tr()}: ${expressSession.createdBy.firstName} ${expressSession.createdBy.lastName}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: grey, overflow: TextOverflow.ellipsis),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.rocket_launch,
                    color: orange,
                  ),
                ],
              ),
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
            Icons.logout,
          ),
        ),
      ],
    );
  }
}
