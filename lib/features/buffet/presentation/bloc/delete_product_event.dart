// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'delete_product_bloc.dart';

@immutable
abstract class DeleteProductEvent {}

class DeleteProduct extends DeleteProductEvent {
  final String id;
  DeleteProduct({
    required this.id,
  });
}
