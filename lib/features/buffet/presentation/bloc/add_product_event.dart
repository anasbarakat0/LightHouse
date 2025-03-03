// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_product_bloc.dart';

@immutable
abstract class AddProductEvent {}

class AddProduct extends AddProductEvent {
  final ProductModel product;
  AddProduct({
    required this.product,
  });
}
