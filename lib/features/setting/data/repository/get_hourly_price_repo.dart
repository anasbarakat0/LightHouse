import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/setting/data/models/get_hourly_price_response_model.dart';
import 'package:lighthouse/features/setting/data/source/get_hourly_price_service.dart';

class GetHourlyPriceRepo {
  final GetHourlyPriceService getHourlyPriceService;
  final NetworkConnection networkConnection;

  GetHourlyPriceRepo({
    required this.getHourlyPriceService,
    required this.networkConnection,
  });

  Future<Either<Failures, GetHourlyPriceResponseModel>>
      getHourlyPriceRepo() async {
    if (await networkConnection.isConnected) {
      try {
        print(159546);
        var data = await getHourlyPriceService.getHourlyPriceService();
        print(942571);
        var hourlyPrice = GetHourlyPriceResponseModel.fromMap(data.data);
        return Right(hourlyPrice);
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
