import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:lighthouse/core/utils/task_notifier.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/main_window/presentation/widget/pie_chart.dart';
import 'package:lighthouse/features/main_window/presentation/widget/summary_details.dart';
import 'package:lighthouse/features/main_window/presentation/widget/task_display_tile.dart';
import 'package:lighthouse/features/statistics/data/repository/get_occupancy_repo.dart';
import 'package:lighthouse/features/statistics/data/source/remote/get_occupancy_service.dart';
import 'package:lighthouse/features/statistics/domain/usecase/get_occupancy_usecase.dart';
import 'package:lighthouse/features/statistics/presentation/bloc/get_occupancy_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SummaryWidget extends StatefulWidget {
  const SummaryWidget({super.key});

  @override
  State<SummaryWidget> createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  late int visits;
  late int onGround;
  late int capacity;
  late bool language;

  Timer? _refreshTimer;
  late final GetOccupancyBloc _occupancyBloc;

  @override
  void initState() {
    super.initState();

    _loadTasks();

    // Fallback values from SharedPreferences
    final prefs = memory.get<SharedPreferences>();
    onGround = prefs.getInt("onGround") ?? 0;
    visits = prefs.getInt("visits") ?? 0;
    capacity = prefs.getInt("capacity") ?? 100;

    // إذا عندك language محفوظة أو عندك notifier جاهز
    // عدّل المفتاح حسب مشروعك (مثلاً: "lang" أو "isArabic" ...)
    language = prefs.getBool("language") ?? false;

    // Listeners
    capacityNotifier.addListener(_onCapacityChanged);
    languageNotifier.addListener(_onLanguageChanged);
    activeSessionsNotifier.addListener(_onActiveSessionsChanged);

    // Create bloc ONCE
    _occupancyBloc = GetOccupancyBloc(
      getOccupancyUsecase: GetOccupancyUsecase(
        getOccupancyRepo: GetOccupancyRepo(
          getOccupancyService: GetOccupancyService(dio: Dio()),
          networkConnection: NetworkConnection.createDefault(),
        ),
      ),
    )..add(GetOccupancy());

    // Periodic refresh every 30s (بدون context.read)
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted && !_occupancyBloc.isClosed) {
        _occupancyBloc.add(GetOccupancy());
      }
    });
  }

  void _onCapacityChanged() {
    if (!mounted) return;
    setState(() => capacity = capacityNotifier.value);
  }

  void _onLanguageChanged() {
    if (!mounted) return;
    setState(() => language = languageNotifier.value);
  }

  void _onActiveSessionsChanged() {
    if (!mounted) return;
    setState(() => onGround = activeSessionsNotifier.value);
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();

    capacityNotifier.removeListener(_onCapacityChanged);
    languageNotifier.removeListener(_onLanguageChanged);
    activeSessionsNotifier.removeListener(_onActiveSessionsChanged);

    _occupancyBloc.close(); // مهم جداً
    super.dispose();
  }

  Future<void> _loadTasks() async {
    final prefs = memory.get<SharedPreferences>();
    final String? taskData = prefs.getString('tasks');

    if (taskData != null) {
      final List<Map<String, dynamic>> allTasks =
          List<Map<String, dynamic>>.from(json.decode(taskData));

      Future.microtask(() {
        if (!mounted) return;
        taskNotifier.value =
            allTasks.where((task) => !(task['completed'] ?? true)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _occupancyBloc,
      child: BlocListener<GetOccupancyBloc, GetOccupancyState>(
        listener: (context, state) {
          if (state is SuccessOccupancy) {
            final prefs = memory.get<SharedPreferences>();

            // Save to prefs
            prefs.setInt("capacity", state.capacity);
            prefs.setInt("onGround", state.onGround);
            prefs.setInt("visits", state.visits);

            // Update notifiers
            capacityNotifier.value = state.capacity;
            activeSessionsNotifier.value = state.onGround;

            // Update UI
            if (!mounted) return;
            setState(() {
              capacity = state.capacity;
              onGround = state.onGround;
              visits = state.visits;
            });
          }
        },
        child: Drawer(
          backgroundColor: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [navy, darkNavy],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SingleChildScrollView(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Chart(onGround: onGround),
                        const SizedBox(height: 20),
                        Text(
                          'summary'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        SummaryDetails(
                          visits: visits,
                          onGround: onGround,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: const Divider(thickness: 0.5),
                        ),
                        ValueListenableBuilder<List<Map<String, dynamic>>>(
                          valueListenable: taskNotifier,
                          builder: (context, tasks, _) {
                            return tasks.isNotEmpty
                                ? Column(
                                    children: [
                                      const SizedBox(height: 16),
                                      Text(
                                        'Pending_Tasks'.tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: lightGrey),
                                      ),
                                      const SizedBox(height: 16),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: tasks.length,
                                        itemBuilder: (context, index) {
                                          final task = tasks[index];
                                          return TaskDisplayTile(
                                            title: task['title'] ?? "No Title",
                                            dateTime: task['dateTime'] ??
                                                DateTime.now().toIso8601String(),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                : Text(
                                    "No_pending_tasks!".tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.white),
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}