import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse_/core/network/network_connection.dart';
import 'package:lighthouse_/features/packages/data/repository/get_all_active_packages_repo.dart';
import 'package:lighthouse_/features/packages/data/source/remote/get_all_active_packages_service.dart';
import 'package:lighthouse_/features/packages/domain/usecase/get_all_active_packages_usecase.dart';
import 'package:lighthouse_/features/packages/presentation/bloc/get_all_active_packages_bloc.dart';

class PackagesPage extends StatefulWidget {
  const PackagesPage({super.key});

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetAllActivePackagesBloc(
            GetAllActivePackagesUsecase(
              getAllActivePackagesRepo: GetAllActivePackagesRepo(
                getAllActivePackagesService:
                    GetAllActivePackagesService(dio: Dio()),
                networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker(),
                ),
              ),
            ),
          )..add(GetAllActivePackages(page: 1, size: 20)),
        )
      ],
      child: Builder(builder: (context) {
        return Column(
          children: [
            //
          ],
        );
      }),
    );
  }
}
