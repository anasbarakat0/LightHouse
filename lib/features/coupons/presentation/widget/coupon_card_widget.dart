import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/coupons/data/models/coupon_model.dart';

class CouponCardWidget extends StatelessWidget {
  final CouponModel coupon;
  final VoidCallback? onDeactivate;
  final VoidCallback? onDelete;

  const CouponCardWidget({
    super.key,
    required this.coupon,
    this.onDeactivate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = coupon.active;
    final discountText = coupon.discountType == DiscountType.PERCENT
        ? "${coupon.discountValue.toStringAsFixed(0)}%"
        : "${coupon.discountValue.toStringAsFixed(0)} ${"S.P".tr()}";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isActive
              ? [
                  Colors.white.withOpacity(0.98),
                  Colors.white.withOpacity(0.95),
                ]
              : [
                  Colors.grey.shade100,
                  Colors.grey.shade50,
                ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color:
              isActive ? orange.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: (isActive ? orange : Colors.grey).withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background Pattern
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      (isActive ? orange : Colors.grey).withOpacity(0.03),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isActive
                                      ? [orange, orange.withOpacity(0.8)]
                                      : [
                                          Colors.grey.shade400,
                                          Colors.grey.shade500
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isActive ? orange : Colors.grey)
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.local_offer_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    coupon.code,
                                    style: TextStyle(
                                      color: darkNavy,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: isActive
                                            ? [
                                                Colors.green.shade400,
                                                Colors.green.shade600,
                                              ]
                                            : [
                                                Colors.red.shade300,
                                                Colors.red.shade400,
                                              ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: (isActive
                                                  ? Colors.green
                                                  : Colors.red)
                                              .withOpacity(0.3),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      isActive
                                          ? "Active".tr()
                                          : "Inactive".tr(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: navy.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: navy.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.copy_rounded, color: navy),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: coupon.code),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Coupon code copied to clipboard"
                                              .tr(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              },
                              tooltip: "Copy".tr(),
                            ),
                          ),
                          if (isActive && onDeactivate != null)
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.orange.shade200,
                                  width: 1.5,
                                ),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.block_rounded,
                                    color: Colors.orange.shade600),
                                onPressed: onDeactivate,
                                tooltip: "Deactivate".tr(),
                              ),
                            ),
                          if (onDelete != null)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.red.shade200,
                                  width: 1.5,
                                ),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.delete_forever_rounded,
                                    color: Colors.red.shade600),
                                onPressed: onDelete,
                                tooltip: "Delete".tr(),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Discount Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          yellow.withOpacity(0.15),
                          orange.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: orange.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.percent_rounded,
                            color: orange,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Discount".tr(),
                                style: TextStyle(
                                  color: grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                discountText,
                                style: TextStyle(
                                  color: darkNavy,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: navy.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getAppliesToText(coupon.appliesTo),
                            style: TextStyle(
                              color: navy,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          Icons.people_rounded,
                          "Used".tr(),
                          "${coupon.usedCount}/${coupon.maxUsesPerCode}",
                          Colors.blue.shade400,
                          Colors.blue.shade50,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          Icons.refresh_rounded,
                          "Remaining".tr(),
                          "${coupon.remainingUses}",
                          Colors.green.shade400,
                          Colors.green.shade50,
                        ),
                      ),
                    ],
                  ),
                  // Optional Fields
                  if (coupon.minBaseAmount != null) ...[
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.attach_money_rounded,
                      "Min Amount".tr(),
                      "${coupon.minBaseAmount!.toStringAsFixed(0)} ${"S.P".tr()}",
                      Colors.purple.shade400,
                    ),
                  ],
                  if (coupon.validFrom != null || coupon.validTo != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (coupon.validFrom != null)
                          Expanded(
                            child: _buildInfoRow(
                              Icons.calendar_today_rounded,
                              "From".tr(),
                              _formatDate(coupon.validFrom!),
                              Colors.teal.shade400,
                            ),
                          ),
                        if (coupon.validTo != null) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInfoRow(
                              Icons.event_rounded,
                              "To".tr(),
                              _formatDate(coupon.validTo!),
                              Colors.orange.shade400,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                  if (coupon.notes != null && coupon.notes!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: navy.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: navy.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.note_rounded,
                              color: navy.withOpacity(0.6), size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              coupon.notes!,
                              style: TextStyle(
                                color: darkNavy,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value,
      Color iconColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: iconColor.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: grey,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: darkNavy,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: iconColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: grey,
                    fontSize: 10,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: darkNavy,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getAppliesToText(AppliesTo appliesTo) {
    switch (appliesTo) {
      case AppliesTo.SESSION_INVOICE:
        return "Session".tr();
      case AppliesTo.BUFFET_INVOICE:
        return "Buffet".tr();
      case AppliesTo.TOTAL_INVOICE:
        return "Total".tr();
    }
  }

  String _formatDate(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return dateTime;
    }
  }
}
