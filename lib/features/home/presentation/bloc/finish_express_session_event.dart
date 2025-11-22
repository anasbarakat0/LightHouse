// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'finish_express_session_bloc.dart';

@immutable
abstract class FinishExpressSessionEvent {}

class FinishExpSession extends FinishExpressSessionEvent {
  final String id;
  final String? discountCode;
  final double? manualDiscountAmount;
  final String? manualDiscountNote;
  FinishExpSession({
    required this.id,
    this.discountCode,
    this.manualDiscountAmount,
    this.manualDiscountNote,
  });
}
