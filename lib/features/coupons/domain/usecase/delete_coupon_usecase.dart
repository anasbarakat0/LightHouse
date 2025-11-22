import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/coupons/data/models/delete_coupon_response_model.dart';
import 'package:lighthouse/features/coupons/data/repository/delete_coupon_repo.dart';

class DeleteCouponUsecase {
  final DeleteCouponRepo deleteCouponRepo;

  DeleteCouponUsecase({required this.deleteCouponRepo});

  Future<Either<Failures, DeleteCouponResponseModel>> call(
      String couponId) {
    return deleteCouponRepo.deleteCouponRepo(couponId);
  }
}

