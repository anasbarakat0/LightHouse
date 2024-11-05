// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/features/premium_client/data/models/get_all_premiumClient_response_model.dart';
import 'package:lighthouse_/features/premium_client/data/repository/get_all_premium_clients_repo.dart';

class GetPremiumClientsUsecase {
  final GetAllPremiumClientsRepo getAllPremiumClientsRepo;
  GetPremiumClientsUsecase({
    required this.getAllPremiumClientsRepo,
  });

  Future<Either<Failures, GetAllPremiumclientResponseModel>> call(int page, int size) async {
    return await getAllPremiumClientsRepo.getAllPremiumClientsRepo(page, size);
  }
}
