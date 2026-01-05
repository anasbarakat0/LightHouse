import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:lighthouse/features/setting/presentation/widget/change_password_dialog.dart';
import 'package:lighthouse/features/setting/data/repository/change_password_repo.dart';
import 'package:lighthouse/features/setting/data/source/change_password_service.dart';
import 'package:lighthouse/features/setting/domain/usecase/change_password_usecase.dart';
import 'package:lighthouse/features/setting/presentation/bloc/change_password_bloc.dart';
import 'package:lighthouse/features/statistics/data/repository/get_occupancy_repo.dart';
import 'package:lighthouse/features/statistics/data/repository/update_capacity_repo.dart';
import 'package:lighthouse/features/statistics/data/source/remote/get_occupancy_service.dart';
import 'package:lighthouse/features/statistics/data/source/remote/update_capacity_service.dart';
import 'package:lighthouse/features/statistics/domain/usecase/get_occupancy_usecase.dart';
import 'package:lighthouse/features/statistics/domain/usecase/update_capacity_usecase.dart';
import 'package:lighthouse/features/statistics/presentation/bloc/get_occupancy_bloc.dart';
import 'package:lighthouse/features/statistics/presentation/bloc/update_capacity_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lighthouse/core/utils/platform_service/platform_service.dart';

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
    // قراءة القيمة من SharedPreferences كـ fallback
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
                networkConnection: NetworkConnection.createDefault(),
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
                networkConnection: NetworkConnection.createDefault(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ChangePasswordBloc(
            ChangePasswordUsecase(
              changePasswordRepo: ChangePasswordRepo(
                changePasswordService: ChangePasswordService(dio: Dio()),
                networkConnection: NetworkConnection.createDefault(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => GetOccupancyBloc(
            getOccupancyUsecase: GetOccupancyUsecase(
              getOccupancyRepo: GetOccupancyRepo(
                getOccupancyService: GetOccupancyService(dio: Dio()),
                networkConnection: NetworkConnection.createDefault(),
              ),
            ),
          )..add(GetOccupancy()),
        ),
        BlocProvider(
          create: (context) => UpdateCapacityBloc(
            updateCapacityUsecase: UpdateCapacityUsecase(
              updateCapacityRepo: UpdateCapacityRepo(
                updateCapacityService: UpdateCapacityService(dio: Dio()),
                networkConnection: NetworkConnection.createDefault(),
              ),
            ),
          ),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<EditHourlyPriceBloc, EditHourlyPriceState>(
            listener: (BuildContext context, state) {
              if (state is SuccessEditingPrice) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green[800],
                    content: Text(state.message,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white)),
                  ),
                );
              } else {
                if (state is ErrorEditingPrice) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent[700],
                      content: Text(state.message,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white)),
                    ),
                  );
                } else if (state is OfflineEditingPrice) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent[700],
                      content: Text(state.message,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white)),
                    ),
                  );
                } else if (state is ForbiddenEditing) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent[700],
                      content: Text(state.message,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white)),
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
            },
          ),
          BlocListener<GetHourlyPriceBloc, GetHourlyPriceState>(
            listener: (BuildContext context, state) {
              if (state is SuccessGettingPrice) {
                hourlyPrice.text = state.price.toString();
              } else if (state is ErrorGettingPrice) {
                hourlyPrice.text = state.message;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.redAccent[700],
                    content: Text(state.message,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white)),
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
                    content: Text(state.message,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white)),
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginWindows(),
                  ),
                );
              }
            },
          ),
          BlocListener<GetOccupancyBloc, GetOccupancyState>(
            listener: (BuildContext context, state) {
              if (state is SuccessOccupancy) {
                // تحديث text field بالقيمة من API
                capacity.text = state.capacity.toString();
                // حفظ في SharedPreferences
                memory.get<SharedPreferences>().setInt("capacity", state.capacity);
                capacityNotifier.value = state.capacity;
              }
            },
          ),
          BlocListener<UpdateCapacityBloc, UpdateCapacityState>(
            listener: (BuildContext context, state) {
              if (state is SuccessCapacity) {
                // حفظ في SharedPreferences
                memory.get<SharedPreferences>().setInt("capacity", state.capacity);
                capacityNotifier.value = state.capacity;
                
                // إعادة جلب البيانات المحدثة
                context.read<GetOccupancyBloc>().add(GetOccupancy());
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green[800],
                    content: Text(state.message,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white)),
                  ),
                );
              } else if (state is ErrorCapacity) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.redAccent[700],
                    content: Text(state.message,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white)),
                  ),
                );
              } else if (state is OfflineCapacity) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.redAccent[700],
                    content: Text(state.message,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white)),
                  ),
                );
              } else if (state is ForbiddenCapacity) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.redAccent[700],
                    content: Text(state.message,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white)),
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginWindows(),
                  ),
                );
              }
            },
          ),
        ],
        child: Builder(builder: (context) {
          final isMobile = Responsive.isMobile(context);

          return Scaffold(
            backgroundColor: darkNavy,
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Desktop Title
                      if (Responsive.isDesktop(context))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32),
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
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: orange.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  Icons.settings,
                                  color: orange,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                "settings".tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Settings Cards
                      _buildSettingsCard(
                        context,
                        "Language".tr(),
                        Icons.language,
                        Colors.blue,
                        const LanguageDropdownSwitcher(),
                        isMobile,
                      ),
                      const SizedBox(height: 16),

                      _buildSettingsCard(
                        context,
                        "Hourly_Price".tr(),
                        Icons.attach_money,
                        Colors.green,
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
                                      hourlyPrice:
                                          double.parse(hourlyPrice.text),
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
                        isMobile,
                      ),
                      const SizedBox(height: 16),

                      _buildSettingsCard(
                        context,
                        "capacity".tr(),
                        Icons.people_alt_outlined,
                        Colors.purple,
                        SettingsTextFieldWidget(
                          controller: capacity,
                          readOnly: false,
                          label: "capacity",
                          suffix: Icon(
                            Icons.people_alt_outlined,
                            color: orange,
                          ),
                          onSubmitted: (p0) {
                            // التحقق من أن القيمة رقم صحيح
                            final capacityValue = int.tryParse(p0);
                            if (capacityValue == null || capacityValue <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.redAccent[700],
                                  content: Text(
                                    "Please enter a valid positive number".tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                              );
                              return;
                            }
                            
                            submitEditingDialog(
                              context,
                              () {
                                context.read<UpdateCapacityBloc>().add(
                                      UpdateCapacity(capacity: capacityValue),
                                    );
                              },
                              () {
                                // إعادة جلب القيمة الحالية من API
                                context.read<GetOccupancyBloc>().add(GetOccupancy());
                              },
                            );
                          },
                        ),
                        isMobile,
                      ),
                      const SizedBox(height: 16),

                      // Printer Settings Card
                      _buildPrinterSettingsCard(context, isMobile),

                      const SizedBox(height: 16),

                      // Change Password Card
                      _buildChangePasswordCard(context, isMobile),
                    ]),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context,
    String title,
    IconData icon,
    Color iconColor,
    Widget child,
    bool isMobile,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A2F4A),
            const Color(0xFF0F1E2E),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: iconColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: iconColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      iconColor.withOpacity(0.25),
                      iconColor.withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: iconColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildPrinterSettingsCard(BuildContext context, bool isMobile) {
    final prefs = memory.get<SharedPreferences>();
    final selectedPrinter = prefs.getString('selected_printer') ?? 'XP-80C (copy 1)';
    final service = PlatformService();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A2F4A),
            const Color(0xFF0F1E2E),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: orange.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: orange.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      orange.withOpacity(0.25),
                      orange.withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: orange.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(Icons.print, color: orange, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                "Printer_Settings".tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<String>>(
            future: Future.value(service.getAvailablePrinters()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          snapshot.hasError
                              ? "Error loading printers: ${snapshot.error}"
                              : "No printers found",
                          style: TextStyle(
                            color: Colors.red[300],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final printers = snapshot.data!;
              final currentIndex = printers.indexOf(selectedPrinter);
              final selectedIndex = currentIndex >= 0 ? currentIndex : 0;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                child: DropdownButton<String>(
                  value: selectedIndex < printers.length ? printers[selectedIndex] : printers.first,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF1A2F4A),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  icon: Icon(Icons.arrow_drop_down, color: orange),
                  underline: const SizedBox(),
                  items: printers.map((String printer) {
                    return DropdownMenuItem<String>(
                      value: printer,
                      child: Row(
                        children: [
                          Icon(Icons.print, color: orange, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              printer,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      prefs.setString('selected_printer', newValue);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green[800],
                          content: Text(
                            "Printer selected: $newValue",
                            style: const TextStyle(color: Colors.white),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      setState(() {});
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChangePasswordCard(BuildContext context, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A2F4A),
            const Color(0xFF0F1E2E),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.withOpacity(0.25),
                      Colors.blue.withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.lock_reset,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Security".tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                showChangePasswordDialog(context);
              },
              icon: const Icon(Icons.lock_reset, color: Colors.white, size: 20),
              label: Text(
                "change_password".tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
