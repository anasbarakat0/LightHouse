import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/coupons/data/models/coupon_model.dart';
import 'package:lighthouse/features/coupons/data/models/generate_coupon_request_model.dart';
import 'package:lighthouse/features/coupons/presentation/bloc/generate_coupon_bloc.dart';

void showGenerateCouponDialog(BuildContext context) {
  // Get the bloc from the parent context
  final generateCouponBloc = context.read<GenerateCouponBloc>();

  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (BuildContext dialogContext) {
      return BlocProvider.value(
        value: generateCouponBloc,
        child: _GenerateCouponDialogContent(),
      );
    },
  );
}

class _GenerateCouponDialogContent extends StatefulWidget {
  @override
  State<_GenerateCouponDialogContent> createState() =>
      _GenerateCouponDialogContentState();
}

class _GenerateCouponDialogContentState
    extends State<_GenerateCouponDialogContent>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  CodeMode _codeMode = CodeMode.RANDOM;
  DiscountType _discountType = DiscountType.PERCENT;
  AppliesTo _appliesTo = AppliesTo.TOTAL_INVOICE;

  final TextEditingController _countController =
      TextEditingController(text: "1");
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _prefixController = TextEditingController();
  final TextEditingController _discountValueController =
      TextEditingController();
  final TextEditingController _maxUsesPerCodeController =
      TextEditingController();
  final TextEditingController _maxUsesPerUserController =
      TextEditingController();
  final TextEditingController _minBaseAmountController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime? _validFrom;
  DateTime? _validTo;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _countController.dispose();
    _codeController.dispose();
    _prefixController.dispose();
    _discountValueController.dispose();
    _maxUsesPerCodeController.dispose();
    _maxUsesPerUserController.dispose();
    _minBaseAmountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GenerateCouponBloc, GenerateCouponState>(
      listener: (context, state) {
        if (state is SuccessGenerateCoupon) {
          Navigator.of(context).pop();
        }
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 700, maxHeight: 900),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: navy.withOpacity(0.15),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Enhanced Header
                    Container(
                      padding: const EdgeInsets.fromLTRB(28, 28, 20, 28),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [navy, darkNavy],
                          stops: const [0.0, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: navy.withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  orange.withOpacity(0.3),
                                  orange.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: orange.withOpacity(0.3),
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
                            child: const Icon(
                              Icons.local_offer_rounded,
                              color: orange,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Generate Coupon".tr(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Create discount coupons for your customers"
                                      .tr(),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => Navigator.of(context).pop(),
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Content
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white,
                              lightGrey.withOpacity(0.3),
                            ],
                          ),
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(28),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Code Mode
                                _buildSectionTitle(
                                  "Code Mode".tr(),
                                  Icons.qr_code_rounded,
                                ),
                                const SizedBox(height: 14),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: lightGrey,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: grey.withOpacity(0.2),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _buildModeOption(
                                          CodeMode.RANDOM,
                                          "Random".tr(),
                                          Icons.shuffle_rounded,
                                        ),
                                      ),
                                      Expanded(
                                        child: _buildModeOption(
                                          CodeMode.MANUAL,
                                          "Manual".tr(),
                                          Icons.edit_rounded,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 28),
                                // Code fields based on mode
                                if (_codeMode == CodeMode.RANDOM) ...[
                                  _buildEnhancedTextField(
                                    controller: _countController,
                                    label: "Count".tr(),
                                    icon: Icons.numbers_rounded,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Required".tr();
                                      }
                                      if (int.tryParse(value) == null ||
                                          int.parse(value) < 1) {
                                        return "Must be at least 1".tr();
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 18),
                                  _buildEnhancedTextField(
                                    controller: _prefixController,
                                    label: "Prefix (Optional)".tr(),
                                    icon: Icons.text_fields_rounded,
                                  ),
                                ] else ...[
                                  _buildEnhancedTextField(
                                    controller: _codeController,
                                    label: "Code".tr(),
                                    icon: Icons.tag_rounded,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Required".tr();
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                                const SizedBox(height: 28),
                                // Discount Type
                                _buildSectionTitle(
                                  "Discount Type".tr(),
                                  Icons.percent_rounded,
                                ),
                                const SizedBox(height: 14),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: lightGrey,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: grey.withOpacity(0.2),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _buildDiscountTypeOption(
                                          DiscountType.AMOUNT,
                                          "Amount".tr(),
                                          Icons.attach_money_rounded,
                                        ),
                                      ),
                                      Expanded(
                                        child: _buildDiscountTypeOption(
                                          DiscountType.PERCENT,
                                          "Percent".tr(),
                                          Icons.percent_rounded,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 28),
                                _buildEnhancedTextField(
                                  controller: _discountValueController,
                                  label: _discountType == DiscountType.PERCENT
                                      ? "Discount Percent".tr()
                                      : "Discount Amount".tr(),
                                  icon: _discountType == DiscountType.PERCENT
                                      ? Icons.percent_rounded
                                      : Icons.attach_money_rounded,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}')),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Required".tr();
                                    }
                                    final num = double.tryParse(value);
                                    if (num == null || num <= 0) {
                                      return "Must be greater than 0".tr();
                                    }
                                    if (_discountType == DiscountType.PERCENT &&
                                        num > 100) {
                                      return "Must be between 0 and 100".tr();
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 28),
                                // Applies To
                                _buildSectionTitle(
                                  "Applies To".tr(),
                                  Icons.category_rounded,
                                ),
                                const SizedBox(height: 14),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: orange.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: orange.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: DropdownButtonFormField<AppliesTo>(
                                    value: _appliesTo,
                                    decoration: InputDecoration(
                                      prefixIcon: Container(
                                        margin: const EdgeInsets.all(8),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: orange.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                          Icons.category_rounded,
                                          color: orange,
                                          size: 20,
                                        ),
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 18),
                                    ),
                                    items: AppliesTo.values.map((type) {
                                      String label;
                                      IconData icon;
                                      switch (type) {
                                        case AppliesTo.SESSION_INVOICE:
                                          label = "Session Invoice".tr();
                                          icon = Icons.access_time_rounded;
                                          break;
                                        case AppliesTo.BUFFET_INVOICE:
                                          label = "Buffet Invoice".tr();
                                          icon = Icons.restaurant_rounded;
                                          break;
                                        case AppliesTo.TOTAL_INVOICE:
                                          label = "Total Invoice".tr();
                                          icon = Icons.receipt_long_rounded;
                                          break;
                                      }
                                      return DropdownMenuItem(
                                        value: type,
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: navy.withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(icon,
                                                  size: 18, color: navy),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              label,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() => _appliesTo = value!);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 28),
                                _buildEnhancedTextField(
                                  controller: _maxUsesPerCodeController,
                                  label: "Max Uses Per Code".tr(),
                                  icon: Icons.repeat_rounded,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Required".tr();
                                    }
                                    if (int.tryParse(value) == null ||
                                        int.parse(value) < 1) {
                                      return "Must be at least 1".tr();
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 18),
                                _buildEnhancedTextField(
                                  controller: _maxUsesPerUserController,
                                  label: "Max Uses Per User (Optional)".tr(),
                                  icon: Icons.person_rounded,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                                const SizedBox(height: 18),
                                _buildEnhancedTextField(
                                  controller: _minBaseAmountController,
                                  label: "Min Base Amount (Optional)".tr(),
                                  icon: Icons.attach_money_rounded,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}')),
                                  ],
                                ),
                                const SizedBox(height: 28),
                                // Validity dates
                                _buildSectionTitle(
                                  "Validity Period (Optional)".tr(),
                                  Icons.calendar_today_rounded,
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDatePicker(
                                        label: "Valid From".tr(),
                                        icon: Icons.calendar_today_rounded,
                                        date: _validFrom,
                                        onTap: () async {
                                          final date = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.now().add(
                                                const Duration(days: 3650)),
                                            builder: (context, child) {
                                              return Theme(
                                                data:
                                                    Theme.of(context).copyWith(
                                                  colorScheme:
                                                      ColorScheme.light(
                                                    primary: orange,
                                                    onPrimary: Colors.white,
                                                    surface: Colors.white,
                                                    onSurface: darkNavy,
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );
                                          if (date != null) {
                                            setState(() => _validFrom = date);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 18),
                                    Expanded(
                                      child: _buildDatePicker(
                                        label: "Valid To".tr(),
                                        icon: Icons.event_rounded,
                                        date: _validTo,
                                        onTap: () async {
                                          final date = await showDatePicker(
                                            context: context,
                                            initialDate:
                                                _validFrom ?? DateTime.now(),
                                            firstDate:
                                                _validFrom ?? DateTime.now(),
                                            lastDate: DateTime.now().add(
                                                const Duration(days: 3650)),
                                            builder: (context, child) {
                                              return Theme(
                                                data:
                                                    Theme.of(context).copyWith(
                                                  colorScheme:
                                                      ColorScheme.light(
                                                    primary: orange,
                                                    onPrimary: Colors.white,
                                                    surface: Colors.white,
                                                    onSurface: darkNavy,
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );
                                          if (date != null) {
                                            setState(() => _validTo = date);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 28),
                                _buildEnhancedTextField(
                                  controller: _notesController,
                                  label: "Notes (Optional)".tr(),
                                  icon: Icons.note_rounded,
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Enhanced Actions
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            lightGrey.withOpacity(0.5),
                            lightGrey,
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(28),
                          bottomRight: Radius.circular(28),
                        ),
                        border: Border(
                          top: BorderSide(
                            color: grey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                      ),
                      child:
                          BlocBuilder<GenerateCouponBloc, GenerateCouponState>(
                        builder: (context, state) {
                          final isLoading = state is LoadingGenerateCoupon;
                          return Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: navy.withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(18),
                                      onTap: isLoading
                                          ? null
                                          : () => Navigator.of(context).pop(),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 18),
                                        child: Center(
                                          child: Text(
                                            "Cancel".tr(),
                                            style: TextStyle(
                                              color: navy,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        orange,
                                        orange.withOpacity(0.85)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                        color: orange.withOpacity(0.5),
                                        blurRadius: 15,
                                        offset: const Offset(0, 6),
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: AbsorbPointer(
                                    absorbing: isLoading,
                                    child: Opacity(
                                      opacity: isLoading ? 0.7 : 1.0,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          onTap: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              final request =
                                                  GenerateCouponRequestModel(
                                                codeMode: _codeMode,
                                                count: _codeMode ==
                                                        CodeMode.RANDOM
                                                    ? int.parse(
                                                        _countController.text)
                                                    : null,
                                                code:
                                                    _codeMode == CodeMode.MANUAL
                                                        ? _codeController.text
                                                            .toUpperCase()
                                                        : null,
                                                prefix: _prefixController
                                                        .text.isEmpty
                                                    ? null
                                                    : _prefixController.text
                                                        .toUpperCase(),
                                                discountType: _discountType,
                                                discountValue: double.parse(
                                                    _discountValueController
                                                        .text),
                                                maxUsesPerCode: int.parse(
                                                    _maxUsesPerCodeController
                                                        .text),
                                                maxUsesPerUser:
                                                    _maxUsesPerUserController
                                                            .text.isEmpty
                                                        ? null
                                                        : int.parse(
                                                            _maxUsesPerUserController
                                                                .text),
                                                minBaseAmount:
                                                    _minBaseAmountController
                                                            .text.isEmpty
                                                        ? null
                                                        : double.parse(
                                                            _minBaseAmountController
                                                                .text),
                                                validFrom: _validFrom != null
                                                    ? "${_validFrom!.toIso8601String().substring(0, 19)}"
                                                    : null,
                                                validTo: _validTo != null
                                                    ? "${_validTo!.toIso8601String().substring(0, 19)}"
                                                    : null,
                                                appliesTo: _appliesTo,
                                                notes: _notesController
                                                        .text.isEmpty
                                                    ? null
                                                    : _notesController.text,
                                              );
                                              context
                                                  .read<GenerateCouponBloc>()
                                                  .add(GenerateCoupon(
                                                      request: request));
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 18),
                                            child: Center(
                                              child: isLoading
                                                  ? const SizedBox(
                                                      height: 22,
                                                      width: 22,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2.5,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                Colors.white),
                                                      ),
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(6),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: const Icon(
                                                            Icons
                                                                .check_circle_rounded,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Text(
                                                          "Generate".tr(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 0.8,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                orange.withOpacity(0.15),
                orange.withOpacity(0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: orange.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(icon, color: orange, size: 22),
        ),
        const SizedBox(width: 14),
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: darkNavy,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        maxLines: maxLines,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: darkNavy,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: orange, size: 20),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: grey.withOpacity(0.2), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: grey.withOpacity(0.2), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: orange, width: 2.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildModeOption(CodeMode mode, String label, IconData icon) {
    final isSelected = _codeMode == mode;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _codeMode = mode),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [orange, orange.withOpacity(0.85)],
                    )
                  : null,
              color: isSelected ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: orange.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : grey,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : darkNavy,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountTypeOption(
      DiscountType type, String label, IconData icon) {
    final isSelected = _discountType == type;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _discountType = type),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [orange, orange.withOpacity(0.85)],
                    )
                  : null,
              color: isSelected ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: orange.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : grey,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : darkNavy,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required IconData icon,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: date == null
                  ? grey.withOpacity(0.2)
                  : orange.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (date == null
                      ? grey.withOpacity(0.1)
                      : orange.withOpacity(0.15)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: date == null ? grey : orange,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      date == null
                          ? "Select date".tr()
                          : DateFormat('yyyy-MM-dd').format(date),
                      style: TextStyle(
                        color: date == null ? grey : darkNavy,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: date == null ? grey : orange,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
