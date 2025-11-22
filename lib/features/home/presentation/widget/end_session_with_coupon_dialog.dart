import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';

void showEndSessionWithCouponDialog(
  BuildContext context,
  String sessionId,
  void Function(
    String sessionId,
    String? discountCode,
    double? manualDiscountAmount,
    String? manualDiscountNote,
  ) onConfirm,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return _EndSessionWithCouponDialog(
        sessionId: sessionId,
        onConfirm: onConfirm,
      );
    },
  );
}

class _EndSessionWithCouponDialog extends StatefulWidget {
  final String sessionId;
  final void Function(
    String sessionId,
    String? discountCode,
    double? manualDiscountAmount,
    String? manualDiscountNote,
  ) onConfirm;

  const _EndSessionWithCouponDialog({
    required this.sessionId,
    required this.onConfirm,
  });

  @override
  State<_EndSessionWithCouponDialog> createState() =>
      _EndSessionWithCouponDialogState();
}

class _EndSessionWithCouponDialogState
    extends State<_EndSessionWithCouponDialog> {
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _manualDiscountAmountController = TextEditingController();
  final TextEditingController _manualDiscountNoteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _couponController.dispose();
    _manualDiscountAmountController.dispose();
    _manualDiscountNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
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
                        border: Border(
                          bottom: BorderSide(
                            color: orange.withOpacity(0.3),
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
                                  orange.withOpacity(0.3),
                                  orange.withOpacity(0.15),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: orange.withOpacity(0.4),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.local_offer_rounded,
                              color: orange,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              "end_session".tr(),
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
                    const SizedBox(height: 20),
                    // Message
                    Text(
                      "end_session_message".tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Coupon Code Field
                    Row(
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          color: orange,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Discount Code (Optional)".tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _couponController,
                builder: (context, value, child) {
                  return TextFormField(
                    controller: _couponController,
                    decoration: InputDecoration(
                      hintText: "Enter coupon code".tr(),
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.local_offer_rounded,
                          color: orange,
                          size: 20,
                        ),
                      ),
                      suffixIcon: value.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear_rounded, color: Colors.white.withOpacity(0.6)),
                              onPressed: () {
                                _couponController.clear();
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: orange.withOpacity(0.5), width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textCapitalization: TextCapitalization.characters,
                  );
                },
              ),
                    const SizedBox(height: 20),
                    // Manual Discount Amount Field
                    Row(
                      children: [
                        Icon(
                          Icons.percent_outlined,
                          color: orange,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Manual Discount Amount (Optional)".tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _manualDiscountAmountController,
                builder: (context, value, child) {
                  return TextFormField(
                    controller: _manualDiscountAmountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: "Enter discount amount".tr(),
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.percent_rounded,
                          color: orange,
                          size: 20,
                        ),
                      ),
                      suffixIcon: value.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear_rounded, color: Colors.white.withOpacity(0.6)),
                              onPressed: () {
                                _manualDiscountAmountController.clear();
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: orange.withOpacity(0.5), width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final amount = double.tryParse(value);
                        if (amount == null) {
                          return "Please enter a valid number".tr();
                        }
                        if (amount < 0) {
                          return "Discount amount cannot be negative".tr();
                        }
                      }
                      return null;
                    },
                  );
                },
              ),
                    const SizedBox(height: 20),
                    // Manual Discount Note Field
                    Row(
                      children: [
                        Icon(
                          Icons.note_outlined,
                          color: orange,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Manual Discount Note (Optional)".tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _manualDiscountNoteController,
                builder: (context, value, child) {
                  return TextFormField(
                    controller: _manualDiscountNoteController,
                    maxLength: 500,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Enter discount note".tr(),
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.note_rounded,
                          color: orange,
                          size: 20,
                        ),
                      ),
                      suffixIcon: value.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear_rounded, color: Colors.white.withOpacity(0.6)),
                              onPressed: () {
                                _manualDiscountNoteController.clear();
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: orange.withOpacity(0.5), width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      counterText: "${value.text.length}/500",
                      counterStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    validator: (value) {
                      if (value != null && value.length > 500) {
                        return "Note cannot exceed 500 characters".tr();
                      }
                      return null;
                    },
                  );
                },
              ),
                    const SizedBox(height: 24),
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "back".tr(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  final discountCode = _couponController.text.trim();
                                  final manualDiscountAmountText = _manualDiscountAmountController.text.trim();
                                  final manualDiscountNote = _manualDiscountNoteController.text.trim();
                                  
                                  double? manualDiscountAmount;
                                  if (manualDiscountAmountText.isNotEmpty) {
                                    manualDiscountAmount = double.tryParse(manualDiscountAmountText);
                                  }
                                  
                                  widget.onConfirm(
                                    widget.sessionId,
                                    discountCode.isEmpty ? null : discountCode,
                                    manualDiscountAmount,
                                    manualDiscountNote.isEmpty ? null : manualDiscountNote,
                                  );
                                  Navigator.of(context).pop();
                                }
                              },
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
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
                                child: Center(
                                  child: Text(
                                    "end".tr(),
                                    style: const TextStyle(
                                      color: orange,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

