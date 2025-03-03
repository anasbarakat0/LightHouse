import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/buffet/data/models/product_model.dart';
import 'package:lighthouse/features/buffet/data/repository/add_product_repo.dart';

class AddProductUsecase {
  final AddProductRepo addProductRepo;

  AddProductUsecase({required this.addProductRepo});

  Future<Either<Failures,String>>call(ProductModel product)async{
    return await addProductRepo.addProductRepo(product);
  }
}
