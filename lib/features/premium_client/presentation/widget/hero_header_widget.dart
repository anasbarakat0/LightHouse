import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/premium_client/data/models/get_all_premiumClient_response_model.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/print_function.dart';

class HeroHeaderWidget extends StatelessWidget {
  final Body client;
  final bool isMobile;
  final String printerAddress;
  final String printerName;

  const HeroHeaderWidget({
    super.key,
    required this.client,
    required this.isMobile,
    required this.printerAddress,
    required this.printerName,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: isMobile ? 180 : 220,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: navy,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: orange.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: orange.withOpacity(0.3)),
          ),
          child: IconButton(
            icon: const Icon(Icons.print, color: orange, size: 20),
            onPressed: () async {
              await printPremiumQr("USB", printerAddress, printerName, client);
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Gradient Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [navy, darkNavy, navy],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            // Decorative circles
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: orange.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: yellow.withOpacity(0.08),
                ),
              ),
            ),
            // Content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, isMobile ? 80 : 100, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Premium Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: yellow.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: yellow.withOpacity(0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: yellow, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            "premium_member".tr(),
                            style: TextStyle(
                              color: yellow,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Client Name
                    Text(
                      "${client.firstName[0].toUpperCase()}${client.firstName.substring(1)} ${client.lastName[0].toUpperCase()}${client.lastName.substring(1)}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 24 : 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        height: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Client ID
                    Row(
                      children: [
                        Icon(Icons.badge_outlined,
                            color: Colors.white.withOpacity(0.7), size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "ID: ${client.uuid}",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
