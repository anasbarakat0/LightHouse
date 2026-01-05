import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/home/data/models/finish_premium_session_response_model.dart';
import 'package:lighthouse/features/home/presentation/widget/detail_row.dart';
import 'package:lighthouse/features/home/presentation/widget/product_detail_row.dart';

/// Format hours to display with proper precision (removes trailing zeros)
String _formatHours(double hours) {
  // Use toStringAsFixed(4) to ensure we capture all decimal places
  // Then remove trailing zeros properly
  String formatted = hours.toStringAsFixed(4);
  
  // Remove trailing zeros only from the decimal part
  if (formatted.contains('.')) {
    // Find the position of the decimal point
    int dotIndex = formatted.indexOf('.');
    String integerPart = formatted.substring(0, dotIndex);
    String decimalPart = formatted.substring(dotIndex + 1);
    
    // Remove trailing zeros from decimal part
    decimalPart = decimalPart.replaceAll(RegExp(r'0+$'), '');
    
    // Reconstruct the number
    if (decimalPart.isEmpty) {
      formatted = integerPart;
    } else {
      formatted = '$integerPart.$decimalPart';
    }
  }
  
  return "$formatted ${"hrs".tr()}";
}

void endSessionDialog(BuildContext context, Body sessionData) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1A2F4A),
                const Color(0xFF0F1E2E),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 30,
                offset: const Offset(0, 10),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      yellow.withOpacity(0.2),
                      yellow.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: yellow.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            yellow.withOpacity(0.3),
                            yellow.withOpacity(0.15),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: yellow.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.stars_rounded,
                        color: yellow,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'session_info'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
              DetailRow(
                title: "${"date".tr()}: ",
                value: sessionData.date,
              ),
              DetailRow(
                title: "${"started_at".tr()}: ",
                value: sessionData.startTime,
              ),
              DetailRow(
                title: "${"first_name".tr()}: ",
                value: sessionData.firstName,
              ),
              DetailRow(
                title: "${"last_name".tr()}: ",
                value: sessionData.lastName,
              ),
              // DetailRow(
              //   title: "${"created_by".tr()}: ",
              //   value: sessionData.createdBy.firstName,
              // ),
              DetailRow(
                title: "${"num_of_hours".tr()}: ",
                value: _formatHours(sessionData.sessionInvoice.hoursAmount),
              ),
              DetailRow(
                title: "${"sessionInvoicePrice".tr()}: ",
                value:  
                    "${(sessionData.summaryInvoice?.sessionInvoicePrice ?? (sessionData.sessionInvoice.hoursAmount * sessionData.sessionInvoice.hourlyPrice)).toStringAsFixed(2)} ${"s.p".tr()}",
              ),
              DetailRow(
                title: "${"buffetInvoicePrice".tr()}: ",
                value:  
                    "${sessionData.buffetInvoicePrice.toString()} ${"s.p".tr()}",
              ),
                      const SizedBox(height: 16),
                      Divider(
                        thickness: 1,
                        color: Colors.white.withOpacity(0.1),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.restaurant_menu_rounded,
                            color: orange,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "buffet_invoice".tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (sessionData.buffetInvoices.isNotEmpty)
                        ...sessionData.buffetInvoices.map((invoice) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.08),
                                    Colors.white.withOpacity(0.03),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...invoice.orders.map((order) {
                                    return ProductDetailRow(
                                      productName: order.productName,
                                      quantity: order.quantity,
                                      price: order.price,
                                    );
                                  }).toList(),
                                  const SizedBox(height: 12),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "invoice_price".tr(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "${invoice.totalPrice} ${"s.p".tr()}",
                                        style: const TextStyle(
                                          color: orange,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList()
                      else
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white.withOpacity(0.05),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.restaurant_menu_outlined,
                                  size: 48,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "No buffet items".tr(),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      // Discount Details Section
                      if (sessionData.summaryInvoice != null &&
                          (sessionData.summaryInvoice!.totalInvoiceBeforeDiscount != null ||
                          sessionData.summaryInvoice!.discountAmount != null ||
                          sessionData.summaryInvoice!.manualDiscountAmount != null))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Discount Details".tr(),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            if (sessionData.summaryInvoice!.totalInvoiceBeforeDiscount != null)
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Before Discount".tr(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "${sessionData.summaryInvoice!.totalInvoiceBeforeDiscount} ${"s.p".tr()}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (sessionData.summaryInvoice!.discountAmount != null) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.withOpacity(0.15),
                                      Colors.green.withOpacity(0.08),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.green.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.local_offer_rounded,
                                          color: Colors.green.shade400,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Coupon Discount".tr(),
                                          style: TextStyle(
                                            color: Colors.green.shade300,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "-${sessionData.summaryInvoice!.discountAmount} ${"s.p".tr()}",
                                      style: TextStyle(
                                        color: Colors.green.shade300,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (sessionData.summaryInvoice!.totalInvoiceAfterDiscount != null &&
                                sessionData.summaryInvoice!.discountAmount != null) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total After Coupon".tr(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "${sessionData.summaryInvoice!.totalInvoiceAfterDiscount} ${"s.p".tr()}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (sessionData.summaryInvoice!.manualDiscountAmount != null) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.withOpacity(0.15),
                                      Colors.blue.withOpacity(0.08),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.blue.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.edit_rounded,
                                              color: Colors.blue.shade300,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Manual Discount".tr(),
                                              style: TextStyle(
                                                color: Colors.blue.shade300,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "-${sessionData.summaryInvoice!.manualDiscountAmount} ${"s.p".tr()}",
                                          style: TextStyle(
                                            color: Colors.blue.shade300,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (sessionData.summaryInvoice!.manualDiscountNote != null &&
                                        sessionData.summaryInvoice!.manualDiscountNote!.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.05),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          sessionData.summaryInvoice!.manualDiscountNote!,
                                          style: TextStyle(
                                            color: Colors.blue.shade200,
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                          ],
                        ),
                      // Final Total Price
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              orange.withOpacity(0.2),
                              orange.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: orange.withOpacity(0.4),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: orange.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Final Total".tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "${sessionData.summaryInvoice?.finalTotalAfterAllDiscounts ?? sessionData.totalPrice} ${"s.p".tr()}",
                              style: const TextStyle(
                                color: orange,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Footer Button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              orange.withOpacity(0.3),
                              orange.withOpacity(0.2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: orange.withOpacity(0.5),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: orange.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: orange,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "done".tr(),
                              style: const TextStyle(
                                color: orange,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
