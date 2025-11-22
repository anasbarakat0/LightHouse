import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/coupons/data/models/deactivate_coupon_response_model.dart';
import 'package:lighthouse/features/coupons/data/repository/deactivate_coupon_repo.dart';

class DeactivateCouponUsecase {
  final DeactivateCouponRepo deactivateCouponRepo;

  DeactivateCouponUsecase({required this.deactivateCouponRepo});

  Future<Either<Failures, DeactivateCouponResponseModel>> call(
      String couponId) {
    return deactivateCouponRepo.deactivateCouponRepo(couponId);
  }
}

