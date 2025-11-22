import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/coupons/data/models/coupon_model.dart';

class CouponsTableWidget extends StatelessWidget {
  final List<CouponModel> coupons;
  final Function(CouponModel)? onDeactivate;
  final Function(CouponModel)? onDelete;

  const CouponsTableWidget({
    super.key,
    required this.coupons,
    this.onDeactivate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(
              navy.withOpacity(0.1),
            ),
            headingTextStyle: TextStyle(
              color: darkNavy,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            dataRowMinHeight: 50,
            dataRowMaxHeight: 50,
            columnSpacing: 8,
            columns: [
              DataColumn(
                label: SizedBox(
                  width: 120,
                  child: Text("Code".tr()),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: 80,
                  child: Text("Status".tr()),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: 90,
                  child: Text("Discount".tr()),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: 90,
                  child: Text("Applies To".tr()),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: 70,
                  child: Text("Used".tr()),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: 80,
                  child: Text("Remaining".tr()),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: 100,
                  child: Text("Valid From".tr()),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: 100,
                  child: Text("Valid To".tr()),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: 90,
                  child: Text("Actions".tr()),
                ),
              ),
            ],
            rows: coupons.map((coupon) {
              final isActive = coupon.active;
              final discountText = coupon.discountType == DiscountType.PERCENT
                  ? "${coupon.discountValue.toStringAsFixed(0)}%"
                  : "${coupon.discountValue.toStringAsFixed(0)} ${"S.P".tr()}";

              return DataRow(
                cells: [
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            coupon.code,
                            style: TextStyle(
                              color: darkNavy,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Tooltip(
                          message: "Copy".tr(),
                          child: InkWell(
                            onTap: () {
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
                                        "Coupon code copied to clipboard".tr(),
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
                            child: Icon(
                              Icons.copy_rounded,
                              size: 16,
                              color: navy,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isActive ? "Active".tr() : "Inactive".tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      discountText,
                      style: TextStyle(
                        color: darkNavy,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: navy.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: navy.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _getAppliesToText(coupon.appliesTo),
                        style: TextStyle(
                          color: navy,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      "${coupon.usedCount}/${coupon.maxUsesPerCode}",
                      style: TextStyle(
                        color: darkNavy,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      "${coupon.remainingUses}",
                      style: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      coupon.validFrom != null
                          ? _formatDate(coupon.validFrom!)
                          : "-",
                      style: TextStyle(
                        color: grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      coupon.validTo != null
                          ? _formatDate(coupon.validTo!)
                          : "-",
                      style: TextStyle(
                        color: grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isActive && onDeactivate != null)
                          Tooltip(
                            message: "Deactivate".tr(),
                            child: Container(
                              margin: const EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.orange.shade200,
                                  width: 1,
                                ),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.block_rounded,
                                  color: Colors.orange.shade600,
                                  size: 18,
                                ),
                                onPressed: () => onDeactivate!(coupon),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 28,
                                  minHeight: 28,
                                ),
                              ),
                            ),
                          ),
                        if (onDelete != null)
                          Tooltip(
                            message: "Delete".tr(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.red.shade200,
                                  width: 1,
                                ),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete_forever_rounded,
                                  color: Colors.red.shade600,
                                  size: 18,
                                ),
                                onPressed: () => onDelete!(coupon),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 28,
                                  minHeight: 28,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
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
