import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/delete_premium_client_service.dart';

class DeletePremiumClientRepo {
  final DeletePremiumClientService deletePremiumClientService;
  final NetworkConnection networkConnection;

  DeletePremiumClientRepo({
    required this.deletePremiumClientService,
    required this.networkConnection,
  });

  Future<Either<Failures, String>> deletePremiumClientRepo(
      String userId) async {
    if (await networkConnection.isConnected) {
      try {
        var data =
            await deletePremiumClientService.deletePremiumClientService(userId);
        // Extract message from response
        final message = data.data['message'] as String? ?? 'User deleted successfully';
        return Right(message);
      } on Forbidden {
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        return Left(ServerFailure(
            message: e.response?.data.toString() ?? "Unknown error"));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

