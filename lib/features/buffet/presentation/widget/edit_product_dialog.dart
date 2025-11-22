import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/buffet/data/models/product_model.dart';
import 'package:lighthouse/common/widget/text_field_widget.dart';

void editProductDialog(
    BuildContext context, Function(ProductModel) edit, ProductModel product) {
  final nameController = TextEditingController();
  final costPriceController = TextEditingController();
  final quantityController = TextEditingController();
  final consumptionPriceController = TextEditingController();
  final barCodeController = TextEditingController();
  String shortCut = product.shortCut;

  nameController.text = product.name;
  costPriceController.text = product.costPrice.toString();
  quantityController.text = product.quantity.toString();
  consumptionPriceController.text = product.consumptionPrice.toString();
  barCodeController.text = product.barCode;

  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
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
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                orange.withOpacity(0.25),
                                orange.withOpacity(0.15),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: orange.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: orange,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            "edit_product".tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.close,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MyTextFieldDialog(
                            controller: nameController,
                            labelText: "product_name".tr(),
                            isPassword: false,
                          ),
                          const SizedBox(height: 16),
                          MyTextFieldDialog(
                            controller: costPriceController,
                            labelText: "cost_price".tr(),
                            isPassword: false,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[0-9.]*$')),
                            ],
                          ),
                          const SizedBox(height: 16),
                          MyTextFieldDialog(
                            controller: quantityController,
                            labelText: "quantity".tr(),
                            isPassword: false,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          const SizedBox(height: 16),
                          MyTextFieldDialog(
                            controller: consumptionPriceController,
                            labelText: "consumption_price".tr(),
                            isPassword: false,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[0-9.]*$')),
                            ],
                          ),
                          const SizedBox(height: 16),
                          MyTextFieldDialog(
                            controller: barCodeController,
                            labelText: "barcode".tr(),
                            isPassword: false,
                            onSubmitted: (barcode) {
                              if (nameController.text.isNotEmpty &&
                                  costPriceController.text.isNotEmpty &&
                                  quantityController.text.isNotEmpty &&
                                  consumptionPriceController.text.isNotEmpty &&
                                  barCodeController.text.isNotEmpty) {
                                edit(
                                  ProductModel(
                                    name: nameController.text,
                                    costPrice:
                                        double.parse(costPriceController.text),
                                    quantity: int.parse(quantityController.text),
                                    consumptionPrice: double.parse(
                                        consumptionPriceController.text),
                                    barCode: barCodeController.text,
                                    shortCut: shortCut,
                                  ),
                                );
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: shortCut == "true",
                                  onChanged: (value) {
                                    setState(() {
                                      shortCut = value.toString();
                                    });
                                  },
                                  activeColor: orange,
                                  checkColor: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Shortcut".tr(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Actions
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            "cancel".tr(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                orange.withOpacity(0.8),
                                orange.withOpacity(0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: orange.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (nameController.text.isNotEmpty &&
                                    costPriceController.text.isNotEmpty &&
                                    quantityController.text.isNotEmpty &&
                                    consumptionPriceController.text.isNotEmpty &&
                                    barCodeController.text.isNotEmpty) {
                                  edit(
                                    ProductModel(
                                      name: nameController.text,
                                      costPrice: double.parse(
                                          costPriceController.text),
                                      quantity:
                                          int.parse(quantityController.text),
                                      consumptionPrice: double.parse(
                                          consumptionPriceController.text),
                                      barCode: barCodeController.text,
                                      shortCut: shortCut,
                                    ),
                                  );
                                  Navigator.of(context).pop();
                                }
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "edit".tr(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
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
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
