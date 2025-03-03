// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/setting/data/models/get_hourly_price_response_model.dart';
import 'package:lighthouse/features/setting/data/repository/get_hourly_price_repo.dart';

class GetHourlyPriceUsecase {
  final GetHourlyPriceRepo getHourlyPriceRepo;
  GetHourlyPriceUsecase({
    required this.getHourlyPriceRepo,
  });

  Future<Either<Failures, GetHourlyPriceResponseModel>> call ()async{
    return await getHourlyPriceRepo.getHourlyPriceRepo();
  }
}
