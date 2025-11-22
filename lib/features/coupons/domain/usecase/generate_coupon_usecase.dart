import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/coupons/data/models/generate_coupon_request_model.dart';
import 'package:lighthouse/features/coupons/data/models/generate_coupon_response_model.dart';
import 'package:lighthouse/features/coupons/data/repository/generate_coupon_repo.dart';

class GenerateCouponUsecase {
  final GenerateCouponRepo generateCouponRepo;

  GenerateCouponUsecase({required this.generateCouponRepo});

  Future<Either<Failures, GenerateCouponResponseModel>> call(
      GenerateCouponRequestModel request) {
    return generateCouponRepo.generateCouponRepo(request);
  }
}

