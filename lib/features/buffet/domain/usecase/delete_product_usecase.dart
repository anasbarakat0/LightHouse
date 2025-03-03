// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/buffet/data/repository/delete_product_repo.dart';

class DeleteProductUsecase {
  final DeleteProductRepo deleteProductRepo;
  DeleteProductUsecase({
    required this.deleteProductRepo,
  });

  Future<Either<Failures,String>> call(String id)async{
    return await deleteProductRepo.deleteProductRepo(id);
  }
}
