part of 'edit_product_bloc.dart';

@immutable
abstract class EditProductState {}

class EditProductInitial extends EditProductState {}

class ProductEdited extends EditProductState {
final String response;
  ProductEdited({
    required this.response,
  });
}

class ExceptionEditProduct extends EditProductState {
  final String message;
  ExceptionEditProduct({
    required this.message,
  });
}

class ForbiddenEditProduct extends EditProductState {
  final String message;
  ForbiddenEditProduct({
    required this.message,
  });
}

class LoadingEditProduct extends EditProductState {}