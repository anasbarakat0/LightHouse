// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/buffet/data/models/product_model.dart';
import 'package:lighthouse/features/buffet/data/source/remote/edit_product_service.dart';

class EditProductRepo {
  final EditProductService editProductService;
  final NetworkConnection networkConnection;
  EditProductRepo({
    required this.editProductService,
    required this.networkConnection,
  });

  Future<Either<Failures,String>> editProductRepo(ProductModel product,String id)async{
    if (await networkConnection.isConnected) {
      try {
        var data =await editProductService.editProductService(product, id);
        return Right(data.data["message"]);
      } on Forbidden {
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        return Left(
          ServerFailure(
            message: e.response!.data.toString(),
          ),
        );
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
