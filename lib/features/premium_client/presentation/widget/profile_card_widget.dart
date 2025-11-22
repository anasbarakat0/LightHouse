import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/features/premium_client/data/models/get_all_premiumClient_response_model.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/qr_code_widget.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/print_function.dart';

class ProfileCardWidget extends StatelessWidget {
  final Body client;
  final String printerAddress;
  final String printerName;
  final VoidCallback? onEditTap;
  final VoidCallback? onDeleteTap;

  const ProfileCardWidget({
    super.key,
    required this.client,
    required this.printerAddress,
    required this.printerName,
    this.onEditTap,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.95),
            Colors.white.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: orange.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: isMobile ? _buildMobileProfile() : _buildDesktopProfile(),
    );
  }

  Widget _buildMobileProfile() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // QR Code Section
          _buildQRSection(),
          const SizedBox(height: 24),
          // Divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  grey.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Client Info
          _buildClientInfo(),
        ],
      ),
    );
  }

  Widget _buildDesktopProfile() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Client Info
          Expanded(
            flex: 2,
            child: _buildClientInfo(),
          ),
          const SizedBox(width: 40),
          // Vertical Divider
          Container(
            width: 1,
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  grey.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const SizedBox(width: 40),
          // QR Code Section
          _buildQRSection(),
        ],
      ),
    );
  }

  Widget _buildQRSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            orange.withOpacity(0.08),
            yellow.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: orange.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        children: [
          QrCodeWidget(qrData: client.qrCode.qrCode),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: orange,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: orange.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  await printPremiumQr(
                      "USB", printerAddress, printerName, client);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.print, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        "print_qr".tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${client.firstName} ${client.lastName}",
                    style: TextStyle(
                      color: navy,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Action Buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Edit Button
                Container(
                  decoration: BoxDecoration(
                    color: orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: orange.withOpacity(0.3), width: 1),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: onEditTap,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(Icons.edit, color: orange, size: 20),
                      ),
                    ),
                  ),
                ),
                if (onDeleteTap != null) ...[
                  const SizedBox(width: 12),
                  // Delete Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: onDeleteTap,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(Icons.delete_outline, color: Colors.red, size: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildInfoRow(Icons.email_outlined, "email".tr(), client.email),
        _buildInfoRow(Icons.phone_outlined, "phone".tr(), client.phoneNumber),
        _buildInfoRow(Icons.school_outlined, "study".tr(), client.study),
        _buildInfoRow(Icons.person_outline, "gender".tr(), client.gender),
        _buildInfoRow(Icons.cake_outlined, "birth_date".tr(), 
            client.birthDate is String ? client.birthDate : client.birthDate.toString()),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String labelKey, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: orange, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  labelKey,
                  style: TextStyle(
                    color: grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
