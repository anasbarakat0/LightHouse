// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/buffet/data/models/get_all_products_response_model.dart';
import 'package:lighthouse/features/buffet/data/repository/get_all_products_repo.dart';

class GetAllProductsUsecase {
  final GetAllProductsRepo getAllProductsRepo;
  GetAllProductsUsecase({
    required this.getAllProductsRepo,
  });

  Future<Either<Failures, GetAllProductsResponseModel>> call(
      int page, int size) async {
    return await getAllProductsRepo.getAllProductsRepo(page, size);
  }
}
