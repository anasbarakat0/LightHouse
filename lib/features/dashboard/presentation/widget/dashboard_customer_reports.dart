import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/dashboard/data/models/customer_birthday_reminders_response_model.dart';
import 'package:lighthouse/features/dashboard/presentation/bloc/customer_reports_bloc.dart';

class DashboardCustomerReports extends StatefulWidget {
  final bool isMobile;

  const DashboardCustomerReports({
    super.key,
    required this.isMobile,
  });

  @override
  State<DashboardCustomerReports> createState() =>
      _DashboardCustomerReportsState();
}

class _DashboardCustomerReportsState extends State<DashboardCustomerReports> {
  final TextEditingController _daysBeforeController =
      TextEditingController(text: '7');
  bool _includeNeverVisited = true;

  @override
  void dispose() {
    _daysBeforeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerReportsBloc, CustomerReportsState>(
      builder: (context, state) {
        final birthdayItems = state.birthdayReminders?.body ?? [];

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A2F4A),
                Color(0xFF0F1E2E),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: orange.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: widget.isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(birthdayItems.length),
                    const SizedBox(height: 18),
                    _buildExportActions(context, state),
                    const SizedBox(height: 18),
                    _buildBirthdayReminderPanel(context, state, birthdayItems),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(birthdayItems.length),
                          const SizedBox(height: 18),
                          _buildExportActions(context, state),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildBirthdayReminderPanel(
                        context,
                        state,
                        birthdayItems,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildHeader(int birthdayCount) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: orange.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: orange.withValues(alpha: 0.3)),
          ),
          child: const Icon(
            Icons.assessment_rounded,
            color: orange,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Customer Reports'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (birthdayCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.pinkAccent.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(999),
              border:
                  Border.all(color: Colors.pinkAccent.withValues(alpha: 0.35)),
            ),
            child: Text(
              '$birthdayCount',
              style: const TextStyle(
                color: Colors.pinkAccent,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildExportActions(
    BuildContext context,
    CustomerReportsState state,
  ) {
    final isBusy = state.isContactsExporting || state.isLastVisitsExporting;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildExportButton(
              label: 'Export Contacts'.tr(),
              icon: Icons.download_rounded,
              isLoading: state.isContactsExporting,
              onPressed: isBusy
                  ? null
                  : () {
                      context.read<CustomerReportsBloc>().add(
                            ExportCustomerContacts(),
                          );
                    },
            ),
            _buildExportButton(
              label: 'Export By Last Visit'.tr(),
              icon: Icons.history_rounded,
              isLoading: state.isLastVisitsExporting,
              onPressed: isBusy
                  ? null
                  : () {
                      context.read<CustomerReportsBloc>().add(
                            ExportCustomersByLastVisit(
                              includeNeverVisited: _includeNeverVisited,
                            ),
                          );
                    },
            ),
          ],
        ),
        const SizedBox(height: 12),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            setState(() {
              _includeNeverVisited = !_includeNeverVisited;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: _includeNeverVisited,
                activeColor: orange,
                checkColor: navy,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.45)),
                onChanged: (value) {
                  setState(() {
                    _includeNeverVisited = value ?? true;
                  });
                },
              ),
              Text(
                'Include never visited'.tr(),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExportButton({
    required String label,
    required IconData icon,
    required bool isLoading,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: orange,
        disabledBackgroundColor: orange.withValues(alpha: 0.35),
        foregroundColor: navy,
        disabledForegroundColor: navy.withValues(alpha: 0.6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
      ),
      onPressed: onPressed,
      icon: isLoading
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: navy.withValues(alpha: 0.8),
              ),
            )
          : Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildBirthdayReminderPanel(
    BuildContext context,
    CustomerReportsState state,
    List<CustomerBirthdayReminder> birthdayItems,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Birthday Reminders'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                width: 82,
                height: 38,
                child: TextField(
                  controller: _daysBeforeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    hintText: '7',
                    hintStyle:
                        TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                    filled: true,
                    fillColor: const Color(0xFF0F1E2E),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: orange),
                    ),
                  ),
                  onSubmitted: (_) => _fetchBirthdays(context),
                ),
              ),
              const SizedBox(width: 8),
              Tooltip(
                message: 'Refresh'.tr(),
                child: IconButton(
                  onPressed: state.isBirthdaysLoading
                      ? null
                      : () => _fetchBirthdays(context),
                  icon: state.isBirthdaysLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh_rounded),
                  color: orange,
                  splashRadius: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'daysBefore'.tr(),
            style: TextStyle(
              color: grey.withValues(alpha: 0.85),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          if (state.isBirthdaysLoading && state.birthdayReminders == null)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          else if (birthdayItems.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text(
                  'No birthday reminders'.tr(),
                  style: TextStyle(
                    color: grey.withValues(alpha: 0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: birthdayItems.length > 4 ? 4 : birthdayItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return _buildBirthdayItem(birthdayItems[index]);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBirthdayItem(CustomerBirthdayReminder reminder) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.pinkAccent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.pinkAccent.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.cake_rounded,
            color: Colors.pinkAccent,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${reminder.phoneNumber} - ${reminder.nextBirthday}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: grey.withValues(alpha: 0.85),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${reminder.daysUntilBirthday} ${'days'.tr()}',
            style: const TextStyle(
              color: Colors.pinkAccent,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  void _fetchBirthdays(BuildContext context) {
    final rawDaysBefore = int.tryParse(_daysBeforeController.text) ?? 7;
    final daysBefore = rawDaysBefore.clamp(0, 366);
    _daysBeforeController.text = daysBefore.toString();
    context.read<CustomerReportsBloc>().add(
          GetCustomerBirthdayReminders(daysBefore: daysBefore),
        );
  }
}
