// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'edit_product_bloc.dart';

@immutable
abstract class EditProductEvent {}

class EditProduct extends EditProductEvent {
  final ProductModel product;
  final String id;
  EditProduct({
    required this.product,
    required this.id,
  });
}
