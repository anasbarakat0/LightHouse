// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/setting/data/models/get_hourly_price_response_model.dart';
import 'package:lighthouse/features/setting/data/repository/edit_hourly_price_repo.dart';

class EditHourlyPriceUsecase {
  final EditHourlyPriceRepo editHourlyPriceRepo;
  EditHourlyPriceUsecase({
    required this.editHourlyPriceRepo,
  });

  Future<Either<Failures, GetHourlyPriceResponseModel>> call(
      double hourlyPrice) async {
    return await editHourlyPriceRepo.editHourlyPriceRepo(hourlyPrice);
  }
}
