// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_product_bloc.dart';

@immutable
abstract class AddProductState {}

class AddProductInitial extends AddProductState {}

class ProductAdded extends AddProductState {
final String response;
  ProductAdded({
    required this.response,
  });
}

class ExceptionAddProduct extends AddProductState {
  final String message;
  ExceptionAddProduct({
    required this.message,
  });
}

class ForbiddenAddProduct extends AddProductState {
  final String message;
  ForbiddenAddProduct({
    required this.message,
  });
}

class LoadingAddProduct extends AddProductState {}
