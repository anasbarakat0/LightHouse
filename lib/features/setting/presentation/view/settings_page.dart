import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse/common/widget/header.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:lighthouse/core/utils/task_notifier.dart';
import 'package:lighthouse/features/login/presentation/view/login.dart';
import 'package:lighthouse/features/setting/data/repository/edit_hourly_price_repo.dart';
import 'package:lighthouse/features/setting/data/repository/get_hourly_price_repo.dart';
import 'package:lighthouse/features/setting/data/source/edit_hourly_price_service.dart';
import 'package:lighthouse/features/setting/data/source/get_hourly_price_service.dart';
import 'package:lighthouse/features/setting/domain/usecase/edit_hourly_price_usecase.dart';
import 'package:lighthouse/features/setting/domain/usecase/get_hourly_price_usecase.dart';
import 'package:lighthouse/features/setting/presentation/bloc/edit_hourly_price_bloc.dart';
import 'package:lighthouse/features/setting/presentation/bloc/get_hourly_price_bloc.dart';
import 'package:lighthouse/features/setting/presentation/widget/language_drop_down_switcher.dart';
import 'package:lighthouse/features/setting/presentation/widget/settings_text_field_widget.dart';
import 'package:lighthouse/features/setting/presentation/widget/submit_editing_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController hourlyPrice = TextEditingController();
  TextEditingController capacity = TextEditingController();
  bool readOnly = false;

  @override
  void initState() {
    super.initState();
    capacity.text =
        "${memory.get<SharedPreferences>().getInt("capacity") ?? 50}";
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetHourlyPriceBloc(
            GetHourlyPriceUsecase(
              getHourlyPriceRepo: GetHourlyPriceRepo(
                getHourlyPriceService: GetHourlyPriceService(
                  dio: Dio(),
                ),
                networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker.createInstance(
                    addresses: [
                      AddressCheckOption(
                        uri: Uri.parse("https://www.google.com"),
                        timeout: Duration(seconds: 3),
                      ),
AddressCheckOption(
                        uri: Uri.parse("https://1.1.1.1"),
                        timeout: Duration(seconds: 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )..add(GetHourlyPrice()),
        ),
        BlocProvider(
          create: (context) => EditHourlyPriceBloc(
            EditHourlyPriceUsecase(
              editHourlyPriceRepo: EditHourlyPriceRepo(
                editHourlyPriceService: EditHourlyPriceService(
                  dio: Dio(),
                ),
                networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker.createInstance(
                    addresses: [
                      AddressCheckOption(
                        uri: Uri.parse("https://www.google.com"),
                        timeout: Duration(seconds: 3),
                      ),
AddressCheckOption(
                        uri: Uri.parse("https://1.1.1.1"),
                        timeout: Duration(seconds: 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        BlocListener<EditHourlyPriceBloc, EditHourlyPriceState>(
            listener: (BuildContext context, state) {
          if (state is SuccessEditingPrice) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green[800],
                content: Text(state.message,style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)),
              ),
            );
          } else {
            if (state is ErrorEditingPrice) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.redAccent[700],
                  content: Text(state.message,style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)),
                ),
              );
            } else if (state is OfflineEditingPrice) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.redAccent[700],
                  content: Text(state.message,style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)),
                ),
              );
            } else if (state is ForbiddenEditing) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.redAccent[700],
                  content: Text(state.message,style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)),
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginWindows(),
                ),
              );
            }
            context.read<GetHourlyPriceBloc>().add(GetHourlyPrice());
          }
        }),
        BlocListener<GetHourlyPriceBloc, GetHourlyPriceState>(
            listener: (BuildContext context, state) {
          if (state is SuccessGettingPrice) {
            hourlyPrice.text = state.price.toString();
          } else if (state is ErrorGettingPrice) {
            hourlyPrice.text = state.message;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent[700],
                content: Text(state.message,style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)),
              ),
            );
            readOnly = true;
          } else if (state is OfflineGettingPrice) {
            hourlyPrice.text = state.message;
            readOnly = true;
          } else if (state is Forbidden) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent[700],
                content: Text(state.message,style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)),
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginWindows(),
              ),
            );
          }
        })
      ],
      child: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              HeaderWidget(title: "settings".tr()),
              const SizedBox(height: 25),
              if (Responsive.isDesktop(context))
                Text(
                  "settings".tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              if (Responsive.isDesktop(context)) const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LanguageDropdownSwitcher(),
                  const SizedBox(height: 10),
                  SettingsTextFieldWidget(
                    controller: hourlyPrice,
                    label: "Hourly_Price",
                    suffix: SvgPicture.asset(
                      "assets/svg/hourly_price.svg",
                      width: 28,
                      height: 28,
                      color: orange,
                    ),
                    onSubmitted: (string) {
                      submitEditingDialog(context, () {
                        context.read<EditHourlyPriceBloc>().add(
                              EditHourlyPrice(
                                hourlyPrice: double.parse(hourlyPrice.text),
                              ),
                            );
                      }, () {
                        context
                            .read<GetHourlyPriceBloc>()
                            .add(GetHourlyPrice());
                      });
                    },
                    readOnly: readOnly,
                  ),
                  const SizedBox(height: 10),
                  SettingsTextFieldWidget(
                    controller: capacity,
                    readOnly: false,
                    label: "capacity",
                    suffix: Icon(Icons.people_alt_outlined,
                      color: orange,),
                    onSubmitted: (p0) {
                      memory
                          .get<SharedPreferences>()
                          .setInt("capacity", int.parse(p0));
                          capacityNotifier.value = int.parse(p0);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
