import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse_/common/widget/header.dart';
import 'package:lighthouse_/core/network/network_connection.dart';
import 'package:lighthouse_/features/login/presentation/view/login.dart';
import 'package:lighthouse_/features/setting/data/repository/edit_hourly_price_repo.dart';
import 'package:lighthouse_/features/setting/data/repository/get_hourly_price_repo.dart';
import 'package:lighthouse_/features/setting/data/source/edit_hourly_price_service.dart';
import 'package:lighthouse_/features/setting/data/source/get_hourly_price_service.dart';
import 'package:lighthouse_/features/setting/domain/usecase/edit_hourly_price_usecase.dart';
import 'package:lighthouse_/features/setting/domain/usecase/get_hourly_price_usecase.dart';
import 'package:lighthouse_/features/setting/presentation/bloc/edit_hourly_price_bloc.dart';
import 'package:lighthouse_/features/setting/presentation/bloc/get_hourly_price_bloc.dart';
import 'package:lighthouse_/features/setting/presentation/widget/language_drop_down_switcher.dart';
import 'package:lighthouse_/features/setting/presentation/widget/settings_text_field_widget.dart';
import 'package:lighthouse_/features/setting/presentation/widget/submit_editing_dialog.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController hourlyPrice = TextEditingController();
  bool readOnly = false;
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
                  internetConnectionChecker: InternetConnectionChecker(),
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
                  internetConnectionChecker: InternetConnectionChecker(),
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
                content: Text(state.message),
              ),
            );
          } else {
            if (state is ErrorEditingPrice) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red[800],
                  content: Text(state.message),
                ),
              );
            } else if (state is OfflineEditingPrice) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red[800],
                  content: Text(state.message),
                ),
              );
            } else if (state is ForbiddenEditing) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red[800],
                  content: Text(state.message),
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
                backgroundColor: Colors.red[800],
                content: Text(state.message),
              ),
            );
            readOnly = true;
          } else if (state is OfflineGettingPrice) {
            hourlyPrice.text = state.message;
            readOnly = true;
          } else if (state is Forbidden) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red[800],
                content: Text(state.message),
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
              const SizedBox(height: 18),
              const HeaderWidget(),
              const SizedBox(height: 25),
              Text(
                "settings".tr(),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LanguageDropdownSwitcher(),
                  const SizedBox(height: 10),
                  SettingsTextFieldWidget(
                    controller: hourlyPrice,
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
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
