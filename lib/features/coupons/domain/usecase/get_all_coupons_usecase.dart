import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/coupons/data/models/get_all_coupons_response_model.dart';
import 'package:lighthouse/features/coupons/data/repository/get_all_coupons_repo.dart';

class GetAllCouponsUsecase {
  final GetAllCouponsRepo getAllCouponsRepo;

  GetAllCouponsUsecase({required this.getAllCouponsRepo});

  Future<Either<Failures, GetAllCouponsResponseModel>> call({
    int? page,
    int? size,
    bool? active,
    String? discountType,
    String? appliesTo,
    String? codeSubstring,
    String? sort,
  }) {
    return getAllCouponsRepo.getAllCouponsRepo(
      page: page,
      size: size,
      active: active,
      discountType: discountType,
      appliesTo: appliesTo,
      codeSubstring: codeSubstring,
      sort: sort,
    );
  }
}

