// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:dartz/dartz.dart';
// import 'package:lighthouse_/core/error/failure.dart';
// import 'package:lighthouse_/core/network/network_connection.dart';
// import 'package:lighthouse_/features/dashboard/data/sources/remote/get_todays_sessions_service.dart';

// class GetTodaysSessionsRepo {
//   final GetTodaysSessionsService getTodaysSessionsService;
//   final NetworkConnection networkConnection;
//   GetTodaysSessionsRepo({
//     required this.getTodaysSessionsService,
//     required this.networkConnection,
//   });

//   Future<Either<Failures,>> getTodaysSessionsRepo(int page, int size) async {
//     if (await networkConnection.isConnected) {
//       try {
//         var data = await getTodaysSessionsService.getTodaysSessionsService(page,size);
//       } catch (e) {
//         //
//       }
//     }else{
//       //
//     }
//   }
// }
