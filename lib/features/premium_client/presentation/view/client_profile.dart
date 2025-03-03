import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse/common/widget/gradient_scaffold.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/core/utils/scroll_behavior.dart';
import 'package:lighthouse/features/premium_client/data/models/get_all_premiumClient_response_model.dart';
import 'package:lighthouse/features/premium_client/data/repository/admin_by_id_repo.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/admin_by_id_service.dart';
import 'package:lighthouse/features/premium_client/domain/usecase/admin_by_id_usecase.dart';
import 'package:lighthouse/features/premium_client/presentation/bloc/admin_by_id_bloc.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/client_info_widget.dart';
import 'package:image/image.dart' as img;
import 'package:lighthouse/features/premium_client/presentation/widget/package_card_widget.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/qr_code_widget.dart';
import '../../../../core/utils/platform_service/platform_service.dart';

enum PrintMode { USB, NETWORK }

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
  late String printerName = "XP-80C (copy 1)";
  late String printerAddress = "192.168.123.100";
  late PrintMode mode = PrintMode.USB;
  late TextEditingController printNameCtrl =
      TextEditingController(text: printerName);
  late TextEditingController printAddressCtrl =
      TextEditingController(text: printerAddress);

  // Sample package data – this could come from an API call or passed as a prop
  final List<Map<String, dynamic>> userPackages = [
    {
      "id": "e43b830d-2280-4e5d-aa87-563f4011fc4f",
      "userId": "d39743d1-d4b3-43af-bc1e-c22c6e3879cf",
      "packageId": "23e1d078-a1da-473b-bc68-9543945db064",
      "consumedHours": 0,
      "startDate": "2025-02-12",
      "endDate": null,
      "remainingDays": 13,
      "active": true
    },
    {
      "id": "e43b830d-2280-4e5d-aa87-563f4011fc4f",
      "userId": "d39743d1-d4b3-43af-bc1e-c22c6e3879cf",
      "packageId": "23e1d078-a1da-473b-bc68-9543945db064",
      "consumedHours": 0,
      "startDate": "2025-02-12",
      "endDate": null,
      "remainingDays": 13,
      "active": false
    },
    {
      "id": "e43b830d-2280-4e5d-aa87-563f4011fc4f",
      "userId": "d39743d1-d4b3-43af-bc1e-c22c6e3879cf",
      "packageId": "23e1d078-a1da-473b-bc68-9543945db064",
      "consumedHours": 0,
      "startDate": "2025-02-12",
      "endDate": null,
      "remainingDays": 13,
      "active": true
    },
    {
      "id": "e43b830d-2280-4e5d-aa87-563f4011fc4f",
      "userId": "d39743d1-d4b3-43af-bc1e-c22c6e3879cf",
      "packageId": "23e1d078-a1da-473b-bc68-9543945db064",
      "consumedHours": 0,
      "startDate": "2025-02-12",
      "endDate": null,
      "remainingDays": 13,
      "active": true
    },
  ];

  @override
  void initState() {
    color = orange;
    super.initState();
  }

  @override
  void dispose() {
    printNameCtrl.dispose();
    printAddressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminByIdBloc(
        AdminByIdUsecase(
          adminByIdRepo: AdminByIdRepo(
            adminByIdService: AdminByIdService(dio: Dio()),
            networkConnection: NetworkConnection(
              internetConnectionChecker: InternetConnectionChecker.instance,
            ),
          ),
        ),
      )..add(GetAdminById(id: widget.client.addedBy)),
      child: Builder(builder: (context) {
        return GradientScaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    BackButton(color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 25),
                // Client Name (with capitalized first letters)
                Text(
                  "${widget.client.firstName.replaceFirst(widget.client.firstName[0], widget.client.firstName[0].toUpperCase())} ${widget.client.lastName.replaceFirst(widget.client.lastName[0], widget.client.lastName[0].toUpperCase())}",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 40),
                // Container for Client Details and QR Code
                LayoutBuilder(builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth * 0.9,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          offset: Offset(7, 7),
                          color: Color.fromARGB(139, 0, 0, 0),
                        ),
                      ],
                      gradient: const LinearGradient(
                        colors: [lightGrey, grey],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: !Responsive.isMobile(context)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 50, horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 20),
                                    child: ClientInfoWidget(
                                      uuid: widget.client.uuid,
                                      email: widget.client.email,
                                      phoneNumber: widget.client.phoneNumber,
                                      study: widget.client.study,
                                      gender: widget.client.gender,
                                      birthDate: widget.client.birthDate,
                                      color: color,
                                    ),
                                  ),
                                ),
                                QrCodeWidget(
                                    qrData: widget.client.qrCode.qrCode),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 8),
                                  child: ClientInfoWidget(
                                    uuid: widget.client.uuid,
                                    email: widget.client.email,
                                    phoneNumber: widget.client.phoneNumber,
                                    study: widget.client.study,
                                    gender: widget.client.gender,
                                    birthDate: widget.client.birthDate,
                                    color: color,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                QrCodeWidget(
                                  qrData: widget.client.qrCode.qrCode,
                                ),
                              ],
                            ),
                          ),
                  );
                }),

                const SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 25,
                      horizontal: MediaQuery.of(context).size.width * 0.1),
                  child: const Divider(thickness: 0.5),
                ),
                const SizedBox(height: 20),
                // New Section: Display Package UI
                Text(
                  "Packages",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: color),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  height: 200,
                  child: ScrollConfiguration(
                    
                    behavior: MyCustomScrollBehavior(),
                    child: ListView.builder(
                       scrollDirection: Axis.horizontal,
                        itemCount: userPackages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal:
                                    8.0), 
                            child: UserPackageCard(
                                packageData: userPackages[index], color: color),
                          );
                        }),
                  ),
                ),

                const SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 25,
                      horizontal: MediaQuery.of(context).size.width * 0.1),
                  child: const Divider(thickness: 0.5),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("added_by".tr(),
                            style: TextStyle(fontSize: 18.0, color: color)),
                        const SizedBox(height: 20),
                        Text("adding_time".tr(),
                            style: TextStyle(fontSize: 18.0, color: color)),
                        const SizedBox(height: 20),
                        Text("lastModifiedBy".tr(),
                            style: TextStyle(fontSize: 18.0, color: color)),
                        const SizedBox(height: 20),
                        Text("updatedAt".tr(),
                            style: TextStyle(fontSize: 18.0, color: color)),
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
                                    color: Colors.white),
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
                              color: Colors.white),
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
                            : Text(
                                widget.client.qrCode.lastModifiedBy,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                        const SizedBox(height: 20),
                        Text(
                          DateFormat('yyyy/MM/dd').format(DateTime.parse(
                                      widget.client.qrCode.updatedAt)) ==
                                  DateFormat('yyyy/MM/dd').format(
                                      DateTime.parse(
                                          widget.client.addingDateTime))
                              ? "Null"
                              : DateFormat('yyyy/MM/dd').format(
                                  DateTime.parse(
                                    widget.client.qrCode.updatedAt,
                                  ),
                                ),
                          style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                InkWell(
                  onTap: () async {
                    final ByteData data =
                        await rootBundle.load('assets/images/logo_print.png');
                    final Uint8List pngBytes = data.buffer.asUint8List();

                    // Decode PNG to Image
                    final img.Image logo = img.decodeImage(pngBytes)!;
                    final img.Image resizedLogo =
                        img.copyResize(logo, width: 400);
                    final profile = await CapabilityProfile.load();
                    final generator = Generator(PaperSize.mm80, profile);
                    List<int> bytes = [];

                    bytes +=
                        generator.image(resizedLogo, align: PosAlign.center);
                    bytes += generator.feed(1);
                    bytes += generator.text('Premium Client',
                        styles: PosStyles(
                            bold: true,
                            fontType: PosFontType.fontA,
                            underline: true));
                    bytes += generator.text('User Id: ${widget.client.uuid}');
                    bytes += generator.feed(1);
                    bytes += generator.qrcode(widget.client.qrCode.qrCode,
                        size: QRSize.size8);
                    bytes += generator.feed(3);
                    bytes += generator.cut(mode: PosCutMode.full);

                    debugPrint("start print ====================",
                        wrapWidth: 20);
                    final service = PlatformService();
                    try {
                      if (mode == PrintMode.NETWORK) {
                        // Uncomment and implement network print logic
                        // service.printSocket(host: printerAddress, port: 9100, bytes: bytes);
                      } else {
                        service.printDirectWindows(
                            printerName: printerName, bytes: bytes);
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                    }
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
                            Icon(Icons.receipt_long, color: darkNavy),

                            // Text(
                            //   "Print QR Code",
                            //   style: TextStyle(
                            //     fontSize: 20.0,
                            //     fontWeight: FontWeight.w600,
                            //     color: darkNavy,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }
}

