import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/common/widget/my_button.dart';
import 'package:lighthouse/common/widget/text_field_widget.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/buffet/data/models/product_model.dart';

void editProductDialog(
    BuildContext context, Function(ProductModel) edit, ProductModel product) {
  TextEditingController name = TextEditingController();
  TextEditingController costPrice = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController consumptionPrice = TextEditingController();
  TextEditingController barCode = TextEditingController();

  showDialog(
      context: context,
      builder: (BuildContext context) {
        name.text = product.name;
        costPrice.text = product.costPrice.toString();
        quantity.text = product.quantity.toString();
        consumptionPrice.text = product.consumptionPrice.toString();
        barCode.text = product.barCode;
        return AlertDialog(
          title: Text(
            "edit_product".tr(),
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: darkNavy),
          ),
          backgroundColor: Colors.white,
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextFieldDialog(
                  controller: name,
                  labelText: "product_name".tr(),
                  isPassword: false,
                ),
                MyTextFieldDialog(
                  controller: costPrice,
                  labelText: "cost_price".tr(),
                  isPassword: false,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*$')),
                  ],
                ),
                MyTextFieldDialog(
                  controller: quantity,
                  labelText: "quantity".tr(),
                  isPassword: false,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                MyTextFieldDialog(
                  controller: consumptionPrice,
                  labelText: "consumption_price".tr(),
                  isPassword: false,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*$')),
                  ],
                ),
                MyTextFieldDialog(
                  controller: barCode,
                  labelText: "barcode".tr(),
                  isPassword: false,
                  onSubmitted: (barcode) {
                    edit(
                      ProductModel(
                        name: name.text,
                        costPrice: double.parse(costPrice.text),
                        quantity: int.parse(quantity.text),
                        consumptionPrice: double.parse(consumptionPrice.text),
                        barCode: barcode,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: [
            MyButton(
              onPressed: () {
                edit(
                  ProductModel(
                    name: name.text,
                    costPrice: double.parse(costPrice.text),
                    quantity: int.parse(quantity.text),
                    consumptionPrice: double.parse(consumptionPrice.text),
                    barCode: barCode.text,
                  ),
                );
                Navigator.of(context).pop();
              },
              child: Text("edit".tr(),
                  style: Theme.of(context).textTheme.labelLarge),
            ),
          ],
        );
      });
}
