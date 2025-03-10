// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:barcode_widget/barcode_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lighthouse/common/widget/my_button.dart';

import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/admin_management/presentation/widget/delete_dialog.dart';
import 'package:lighthouse/features/buffet/data/models/product_model.dart';
import 'package:lighthouse/features/buffet/presentation/widget/edit_product_dialog.dart';

// ignore: must_be_immutable
class ProductCardWidget extends StatelessWidget {
  final ProductModel product;
  void Function() delete;
  void Function(ProductModel) edit;
  ProductCardWidget({
    super.key,
    required this.product,
    required this.delete,
    required this.edit,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Opacity(
                  opacity: (product.quantity == 0) ? 0.7 : 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FittedBox(
                        child: Text(
                          product.name,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Cost: \$${product.costPrice.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: grey),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Qty: ${product.quantity}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: navy),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Consumption: \$${product.consumptionPrice.toStringAsFixed(0)}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: orange),
                      ),
                      const Spacer(),
                      BarcodeWidget(
                        height: 75,
                        data: product.barCode,
                        barcode: Barcode.ean13(drawEndChar: true),
                        drawText: true,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyButton(
                            onPressed: () {
                              deleteMessage(context, delete,
                                  "delete_product_messgae".tr());
                            },
                            color: const Color.fromRGBO(183, 28, 28, 1),
                            child: Text(
                              "delete".tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                          MyButton(
                            onPressed: () {
                              editProductDialog(context, (product) {
                                edit(product);
                              }, product);
                            },
                            color: Colors.white,
                            side: const BorderSide(
                              width: 1.5,
                              color: orange,
                            ),
                            child: Text(
                              "edit".tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: orange),
                            ),
                          ),
                          
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (product.quantity == 0)
            Positioned(
              top: 50,
              child: SvgPicture.asset(
                "assets/svg/out_of_stock.svg",
                width: 200,
                color: Colors.red[800],
              ),
            ),
        ],
      ),
    );
  }
}
