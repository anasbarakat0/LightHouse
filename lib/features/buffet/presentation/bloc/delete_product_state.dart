part of 'delete_product_bloc.dart';

@immutable
abstract class DeleteProductState {}

class DeleteProductInitial extends DeleteProductState {}

class ProductDeleted extends DeleteProductState {
final String response;
  ProductDeleted({
    required this.response,
  });
}

class ExceptionDeleteProduct extends DeleteProductState {
  final String message;
  ExceptionDeleteProduct({
    required this.message,
  });
}

class ForbiddenDeleteProduct extends DeleteProductState {
  final String message;
  ForbiddenDeleteProduct({
    required this.message,
  });
}

class LoadingDeleteProduct extends DeleteProductState {}