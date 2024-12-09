// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/core/network/network_connection.dart';
import 'package:lighthouse_/features/home/data/models/finish_express_session_response_model.dart';
import 'package:lighthouse_/features/home/data/source/remote/finish_express_sessions_service.dart';

class FinishExpressSessionsRepo {
  final FinishExpressSessionsService finishExpressSessionsService;
  final NetworkConnection networkConnection;
  FinishExpressSessionsRepo({
    required this.finishExpressSessionsService,
    required this.networkConnection,
  });

  Future<Either<Failures,FinishExpressSessionResponseModel>> finishExpressSessionsRepo(){}
}
