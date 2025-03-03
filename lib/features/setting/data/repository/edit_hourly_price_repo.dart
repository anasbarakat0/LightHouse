// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/setting/data/models/get_hourly_price_response_model.dart';
import 'package:lighthouse/features/setting/data/source/edit_hourly_price_service.dart';

class EditHourlyPriceRepo {
  final EditHourlyPriceService editHourlyPriceService;
  final NetworkConnection networkConnection;
  EditHourlyPriceRepo({
    required this.editHourlyPriceService,
    required this.networkConnection,
  });

  Future<Either<Failures, GetHourlyPriceResponseModel>> editHourlyPriceRepo(
      double hourlyPrice) async {
    if (await networkConnection.isConnected) {
      try {
        var data = await editHourlyPriceService.editHourlyPrice(hourlyPrice);
        var response = GetHourlyPriceResponseModel.fromMap(data.data);
        return Right(response);
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on Forbidden {
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on DioException catch (e) {
        return Left(ServerFailure(message: e.response!.data.toString()));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
