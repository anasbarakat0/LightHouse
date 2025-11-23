// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/buffet/data/source/remote/delete_product_service.dart';

class DeleteProductRepo {
  final DeleteProductService deleteProductService;
  final NetworkConnection networkConnection;
  DeleteProductRepo({
    required this.deleteProductService,
    required this.networkConnection,
  });

  Future<Either<Failures,String>> deleteProductRepo(String id)async{
    if (await networkConnection.isConnected) {
      try {
        var data = await deleteProductService.deleteProductService(id);
        // Handle both Map and String response types
        String message;
        if (data.data is Map) {
          message = data.data['message'] as String? ?? 'Product deleted successfully';
        } else if (data.data is String) {
          message = data.data as String;
        } else {
          message = 'Product deleted successfully';
        }
        return Right(message);
      } on Forbidden {
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        return Left(
          ServerFailure(
            message: e.response?.data.toString() ?? "Unknown error",
          ),
        );
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
