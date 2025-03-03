// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/premium_client/data/models/new_premium_client_response.dart';
import 'package:lighthouse/features/premium_client/data/models/premium_client_model.dart';
import 'package:lighthouse/features/premium_client/data/repository/add_premium_client_repo.dart';

class AddPremiumClientUsecase {
  final AddPremiumClientRepo addPremiumClientRepo;
  AddPremiumClientUsecase({
    required this.addPremiumClientRepo,
  });

  Future <Either<Failures, NewPremiumClientResponseModel>> call (PremiumClient client)async{
    return await addPremiumClientRepo.addPremiumClientRepo(client);
  }
}
