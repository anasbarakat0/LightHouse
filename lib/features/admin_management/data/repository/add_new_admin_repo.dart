// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/admin_management/data/models/new_admin_model.dart';
import 'package:lighthouse/features/admin_management/data/models/new_admin_response_model.dart';
import 'package:lighthouse/features/admin_management/data/source/add_new_admin_service.dart';

class AddNewAdminRepo {
  final NetworkConnection networkConnection;
  final AddNewAdminService addNewAdminService;
  AddNewAdminRepo({
    required this.networkConnection,
    required this.addNewAdminService,
  });

  Future<Either<Failures, NewAdminResponseModel>> addNewAdminRepo(
      NewAdminModel admin) async {
    if (await networkConnection.isConnected) {
      try {
        var data = await addNewAdminService.addNewAdminService(admin);


        return right(NewAdminResponseModel.fromMap(data.data));
      } on DioException catch (e) {
        if (e.response!.data["status"] == "BAD_REQUEST") {

          return left(
              AddNewAdminFailure(messages: [e.response!.data["message"]]));
        } else if (e.response!.data["status"] == "TOO_MANY_REQUESTS") {
          return left(
              AddNewAdminFailure(messages: [e.response!.data["message"]]));
        } else {

          return left(ServerFailure(message: e.response!.data.toString()));
        }
      }
    } else {
      return left(OfflineFailure());
    }
  }
}
