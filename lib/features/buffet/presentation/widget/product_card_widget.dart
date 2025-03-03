// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:barcode_widget/barcode_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Cost: \$${product.costPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Qty: ${product.quantity}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: navy,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Consumption: \$${product.consumptionPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (product.quantity == 0)
                  SvgPicture.asset(
                    "assets/svg/out_of_stock.svg",
                    width: 200,
                    color: Colors.red[800],
                  ),
                if (product.quantity != 0)
                  BarcodeWidget(
                    height: 75,
                    data: product.barCode,
                    barcode: Barcode.isbn(drawEndChar: true, drawIsbn: false),
                    drawText: true,
                  ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        deleteMessage(
                            context, delete, "delete_product_messgae".tr());
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: Colors.red[900],
                        foregroundColor: Colors.white,
                      ),
                      child: Text("delete".tr()),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        editProductDialog(context, (product) {
                          edit(product);
                        }, product);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: const BorderSide(
                            width: 1.5,
                            color: orange,
                          ),
                        ),
                        foregroundColor: orange,
                        backgroundColor: Colors.white,
                      ),
                      child: Text("edit".tr()),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
