import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/premium_client/data/models/get_premium_user_by_name_response.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/get_premium_user_by_name_service.dart';

class GetPremiumUserByNameRepo {
  final GetPremiumUserByNameService getPremiumUserByNameService;
  final NetworkConnection networkConnection;
  GetPremiumUserByNameRepo({
    required this.getPremiumUserByNameService,
    required this.networkConnection,
  });

  Future<Either<Failures, GetPremiumUserByNameResponse>>
      getPremiumUserByNameRepo(String name) async {
    if (await networkConnection.isConnected) {
      try {
        var data =
            await getPremiumUserByNameService.getPremiumUserByNameService(name);
        return Right(GetPremiumUserByNameResponse.fromMap(data.data));
      } on Forbidden {
        print("GetPremiumUserByNameRepo forbidden");
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        print("GetPremiumUserByNameRepo bad request");
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        print("GetPremiumUserByNameRepo DioException");
        print(e.response!.data);
        return Left(ServerFailure(message: e.response!.data.toString()));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
