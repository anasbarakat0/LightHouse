part of 'finish_premium_session_bloc.dart';

@immutable
abstract class FinishPremiumSessionEvent {}

class FinishPreSession extends FinishPremiumSessionEvent {
  final String id;
  final String? discountCode;
  final double? manualDiscountAmount;
  final String? manualDiscountNote;
  FinishPreSession({
    required this.id,
    this.discountCode,
    this.manualDiscountAmount,
    this.manualDiscountNote,
  });
}
