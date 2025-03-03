// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/admin_management/data/models/admin_info_model.dart';
import 'package:lighthouse/features/admin_management/presentation/widget/admin_info.dart';

// ignore: must_be_immutable
class AdminCard extends StatelessWidget {
  final AdminInfoModel adminInfoModel;
  void Function(BuildContext) onPressedDelete;
  void Function(BuildContext) onPressedEdit;
  AdminCard({
    super.key,
    required this.adminInfoModel,
    required this.onPressedDelete,
    required this.onPressedEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: onPressedDelete,
              label: "Delete",
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              icon: Icons.delete,
              backgroundColor: const Color.fromRGBO(198, 40, 40, 1),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: onPressedEdit,
              label: "Edit Password",
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              icon: Icons.edit,
              backgroundColor: const Color.fromRGBO(255, 111, 0, 1),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => showAdminInfo(context, adminInfoModel),
          child: SizedBox(
            height: 69,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: yellow),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 15, left: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      adminInfoModel.firstName,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(width: 15),
                    Container(
                      height: 40,
                      width: 120,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: adminInfoModel.role == "SuperAdmin"
                            ? orange
                            : adminInfoModel.role == "MANAGER"
                                ? yellow
                                : navy,
                      ),
                      child: Text(
                        adminInfoModel.role == "SuperAdmin"
                            ? "supper_admin".tr()
                            : adminInfoModel.role == "MANAGER"
                                ? "manager".tr()
                                : "admin".tr(),
                        style: Theme.of(context).textTheme.labelSmall,
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
}
