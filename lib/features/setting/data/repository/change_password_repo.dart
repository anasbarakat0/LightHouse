import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/setting/data/models/change_password_model.dart';
import 'package:lighthouse/features/setting/data/source/change_password_service.dart';

class ChangePasswordRepo {
  final ChangePasswordService changePasswordService;
  final NetworkConnection networkConnection;

  ChangePasswordRepo({
    required this.changePasswordService,
    required this.networkConnection,
  });

  Future<Either<Failures, String>> changePasswordRepo(
      ChangePasswordModel changePasswordModel) async {
    if (await networkConnection.isConnected) {
      try {
        var data = await changePasswordService.changePassword(changePasswordModel);
        // Handle both JSON and plain text responses
        String message;
        if (data.data is String) {
          // Plain text response
          message = data.data as String;
        } else if (data.data is Map<String, dynamic>) {
          // JSON response
          message = data.data['message'] as String? ?? 'Password changed successfully';
        } else {
          message = 'Password changed successfully';
        }
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

