import 'package:custom_qr_generator/colors/color.dart';
import 'package:custom_qr_generator/options/colors.dart';
import 'package:custom_qr_generator/options/options.dart';
import 'package:custom_qr_generator/qr_painter.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse_/common/widget/gradient_scaffold.dart';
import 'package:lighthouse_/core/network/network_connection.dart';
import 'package:lighthouse_/core/resources/colors.dart';
import 'package:lighthouse_/features/premium_client/data/models/get_all_premiumClient_response_model.dart';
import 'package:lighthouse_/features/premium_client/data/repository/admin_by_id_repo.dart';
import 'package:lighthouse_/features/premium_client/data/source/remote/admin_by_id_service.dart';
import 'package:lighthouse_/features/premium_client/domain/usecase/admin_by_id_usecase.dart';
import 'package:lighthouse_/features/premium_client/presentation/bloc/admin_by_id_bloc.dart';
import 'package:lighthouse_/features/premium_client/presentation/widget/icon_text_widget.dart';
import 'package:lighthouse_/features/premium_client/presentation/widget/printing_commands.dart';

class ClientProfile extends StatefulWidget {
  final Body client;
  const ClientProfile({
    super.key,
    required this.client,
  });

  @override
  State<ClientProfile> createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  late Color color;

  @override
  void initState() {
    color = orange;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminByIdBloc(
        AdminByIdUsecase(
          adminByIdRepo: AdminByIdRepo(
            adminByIdService: AdminByIdService(dio: Dio()),
            networkConnection: NetworkConnection(
              internetConnectionChecker: InternetConnectionChecker(),
            ),
          ),
        ),
      )
        ..add(GetAdminById(id: widget.client.addedBy))
        ..add(GetAdminById(id: widget.client.addedBy)),
      child: Builder(builder: (context) {
        return GradientScaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 18),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BackButton(
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Text(
                  "${widget.client.firstName.replaceFirst(widget.client.firstName[0], widget.client.firstName[0].toUpperCase())} ${widget.client.lastName.replaceFirst(widget.client.lastName[0], widget.client.lastName[0].toUpperCase())}",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 80),
                Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10
                          ,
                          offset: Offset(7  ,7),
                          color: const Color.fromARGB(139, 0, 0, 0)
                        ),
                      ],
                      gradient: const LinearGradient(
                        colors: [lightGrey, grey],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 50, horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   "${widget.client.firstName.replaceFirst(widget.client.firstName[0], widget.client.firstName[0].toUpperCase())} ${widget.client.lastName.replaceFirst(widget.client.lastName[0], widget.client.lastName[0].toUpperCase())}",
                              //   style: TextStyle(
                              //     fontSize: 32.0,
                              //     fontWeight: FontWeight.bold,
                              //     color: color,
                              //   ),
                              // ),
                              // const SizedBox(height: 20),
                              IconTextWidget(
                                icon: "ID",
                                text: widget.client.uuid,
                                color: color,
                              ),
                              const SizedBox(height: 5),
                              IconTextWidget(
                                icon: "email",
                                text: widget.client.email,
                                color: color,
                              ),
                              const SizedBox(height: 5),
                              IconTextWidget(
                                icon: "mobile",
                                text: widget.client.phoneNumber,
                                color: color,
                              ),
                              const SizedBox(height: 5),
                              IconTextWidget(
                                icon: "study",
                                text: widget.client.study,
                                color: color,
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  SvgPicture.asset("assets/svg/gender.svg",
                                      width: 23, height: 23, color: color),
                                  const SizedBox(width: 10),
                                  Text(
                                    widget.client.gender.toLowerCase().tr(),
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      color: navy,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              IconTextWidget(
                                icon: "birth_date",
                                text: DateFormat('yyyy/MM/dd').format(
                                    DateTime.parse(widget.client.birthDate ??
                                        "2024-10-30T18:16:35.808397918")),
                                color: color,
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                        CustomPaint(
                          painter: QrPainter(
                            data: widget.client.qrCode.qrCode,
                            options: const QrOptions(
                              colors: QrColors(
                                  dark: QrColorSolid(navy),
                                  background: QrColorSolid(Colors.transparent)),
                            ),
                          ),
                          size: const Size(200, 200),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Divider(
                    thickness: 0.5,
                    indent: (MediaQuery.of(context).size.width / 10),
                    endIndent: (MediaQuery.of(context).size.width / 10),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "added_by".tr(),
                          style: TextStyle(
                            fontSize: 18.0,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "adding_time".tr(),
                          style: TextStyle(
                            fontSize: 18.0,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "lastModifiedBy".tr(),
                          style: TextStyle(
                            fontSize: 18.0,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "updatedAt".tr(),
                          style: TextStyle(
                            fontSize: 18.0,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        BlocBuilder<AdminByIdBloc, AdminByIdState>(
                          builder: (context, state) {
                            if (state is SuccessGettingAdmin) {
                              return Text(
                                "${state.response.body.firstName} ${state.response.body.lastName}",
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              );
                            } else {
                              return const Text("Waiting...");
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          DateFormat('yyyy/MM/dd').format(
                              DateTime.parse(widget.client.addingDateTime)),
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        widget.client.qrCode.lastModifiedBy == null
                            ? const Text(
                                "Null",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 20),
                        Text(
                          DateFormat('yyyy/MM/dd').format(DateTime.parse(
                                      widget.client.qrCode.updatedAt)) ==
                                  DateFormat('yyyy/MM/dd').format(
                                      DateTime.parse(
                                          widget.client.addingDateTime))
                              ? "Null"
                              : DateFormat('yyyy/MM/dd').format(DateTime.parse(
                                  widget.client.qrCode.updatedAt)),
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Expanded(child: SizedBox()),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WindowsPrintScreen()));
                  },
                  child: SizedBox(
                    height: 69,
                    width: MediaQuery.of(context).size.width / 4,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: color,
                      ),
                      child: const FittedBox(
                        child: Row(
                          children: [
                            Icon(
                              Icons.receipt_long,
                              color: darkNavy,
                            ),
                            SizedBox(width: 15),
                            Text(
                              "Print QR Code",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                                color: darkNavy,
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
        );
      }),
    );
  }
}
