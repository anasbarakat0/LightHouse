import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/coupons/data/models/get_coupon_response_model.dart';
import 'package:lighthouse/features/coupons/data/repository/get_coupon_repo.dart';

class GetCouponUsecase {
  final GetCouponRepo getCouponRepo;

  GetCouponUsecase({required this.getCouponRepo});

  Future<Either<Failures, GetCouponResponseModel>> call(String codeOrId) {
    return getCouponRepo.getCouponRepo(codeOrId);
  }
}

