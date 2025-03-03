// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/buffet/data/models/product_model.dart';
import 'package:lighthouse/features/buffet/data/repository/edit_product_repo.dart';

class EditProductUsecase {
  final EditProductRepo editProductRepo;
  EditProductUsecase({
    required this.editProductRepo,
  });

  Future<Either<Failures,String>> call(ProductModel product,String id)async{
    return await editProductRepo.editProductRepo(product, id);
  }
}
