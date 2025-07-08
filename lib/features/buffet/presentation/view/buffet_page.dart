import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse/common/widget/header.dart';
import 'package:lighthouse/common/widget/pagination.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/features/admin_management/presentation/widget/error_messages.dart';
import 'package:lighthouse/features/buffet/data/models/product_model.dart';
import 'package:lighthouse/features/buffet/data/repository/add_product_repo.dart';
import 'package:lighthouse/features/buffet/data/repository/delete_product_repo.dart';
import 'package:lighthouse/features/buffet/data/repository/edit_product_repo.dart';
import 'package:lighthouse/features/buffet/data/repository/get_all_products_repo.dart';
import 'package:lighthouse/features/buffet/data/source/remote/add_product_service.dart';
import 'package:lighthouse/features/buffet/data/source/remote/delete_product_service.dart';
import 'package:lighthouse/features/buffet/data/source/remote/edit_product_service.dart';
import 'package:lighthouse/features/buffet/data/source/remote/get_all_products_service.dart';
import 'package:lighthouse/features/buffet/domain/usecase/add_product_usecase.dart';
import 'package:lighthouse/features/buffet/domain/usecase/delete_product_usecase.dart';
import 'package:lighthouse/features/buffet/domain/usecase/edit_product_usecase.dart';
import 'package:lighthouse/features/buffet/domain/usecase/get_all_products_usecase.dart';
import 'package:lighthouse/features/buffet/presentation/bloc/add_product_bloc.dart';
import 'package:lighthouse/features/buffet/presentation/bloc/delete_product_bloc.dart';
import 'package:lighthouse/features/buffet/presentation/bloc/edit_product_bloc.dart';
import 'package:lighthouse/features/buffet/presentation/bloc/get_all_products_bloc.dart';
import 'package:lighthouse/features/buffet/presentation/widget/add_product_dialog.dart';
import 'package:lighthouse/features/buffet/presentation/widget/product_card_widget.dart';
import 'package:lighthouse/features/login/presentation/view/login.dart';

class BuffetPage extends StatefulWidget {
  const BuffetPage({super.key});

  @override
  State<BuffetPage> createState() => _BuffetPageState();
}

class _BuffetPageState extends State<BuffetPage> {
  int perPage = 16;
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetAllProductsBloc(
            GetAllProductsUsecase(
              getAllProductsRepo: GetAllProductsRepo(
                getAllProductsService: GetAllProductsService(dio: Dio()),
                networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker.createInstance(
                    addresses: [
                      AddressCheckOption(
                        uri: Uri.parse("https://www.google.com"),
                        timeout: Duration(seconds: 3),
                      ),
AddressCheckOption(
                        uri: Uri.parse("https://1.1.1.1"),
                        timeout: Duration(seconds: 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )..add(GetAllProducts(page: currentPage, size: perPage)),
        ),
        BlocProvider(
          create: (context) => DeleteProductBloc(
            DeleteProductUsecase(
              deleteProductRepo: DeleteProductRepo(
                deleteProductService: DeleteProductService(dio: Dio()),
                networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker.createInstance(
                    addresses: [
                      AddressCheckOption(
                        uri: Uri.parse("https://www.google.com"),
                        timeout: Duration(seconds: 3),
                      ),
AddressCheckOption(
                        uri: Uri.parse("https://1.1.1.1"),
                        timeout: Duration(seconds: 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => EditProductBloc(
            EditProductUsecase(
              editProductRepo: EditProductRepo(
                editProductService: EditProductService(dio: Dio()),
                networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker.createInstance(
                    addresses: [
                      AddressCheckOption(
                        uri: Uri.parse("https://www.google.com"),
                        timeout: Duration(seconds: 3),
                      ),
AddressCheckOption(
                        uri: Uri.parse("https://1.1.1.1"),
                        timeout: Duration(seconds: 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        BlocListener<EditProductBloc, EditProductState>(
          listener: (context, state) {
            switch (state) {
              case ProductEdited():
                context
                    .read<GetAllProductsBloc>()
                    .add(GetAllProducts(page: currentPage, size: perPage));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(state.response,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white)),
                  ),
                );

                break;
              case ExceptionEditProduct():
                return errorMessage(context, "error".tr(), [state.message]);
              case ForbiddenEditProduct():
                errorMessage(context, "unauthorized".tr(), [state.message]);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginWindows(),
                  ),
                );
              default:
            }
          },
        ),
        BlocProvider(
          create: (context) => AddProductBloc(
            AddProductUsecase(
              addProductRepo: AddProductRepo(
                addProductService: AddProductService(dio: Dio()),
                networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker.createInstance(
                    addresses: [
                      AddressCheckOption(
                        uri: Uri.parse("https://www.google.com"),
                        timeout: Duration(seconds: 3),
                      ),
AddressCheckOption(
                        uri: Uri.parse("https://1.1.1.1"),
                        timeout: Duration(seconds: 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        BlocListener<AddProductBloc, AddProductState>(
          listener: (context, state) {
            if (state case ProductAdded()) {
              context
                  .read<GetAllProductsBloc>()
                  .add(GetAllProducts(page: currentPage, size: perPage));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(state.response,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white)),
                ),
              );
              context
                  .read<GetAllProductsBloc>()
                  .add(GetAllProducts(page: currentPage, size: perPage));
            } else if (state case ExceptionAddProduct()) {
              return errorMessage(context, "error".tr(), [state.message]);
            } else if (state case ForbiddenAddProduct()) {
              errorMessage(context, "unauthorized".tr(), [state.message]);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginWindows(),
                ),
              );
            }
          },
        ),
      ],
      child: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Column(
                children: [
                  HeaderWidget(title: "buffet".tr()),
                  const SizedBox(height: 25),
                  if (Responsive.isDesktop(context))
                    Text(
                      "buffet".tr(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  if (Responsive.isDesktop(context)) const SizedBox(height: 40),
                  Expanded(
                    child:
                        BlocConsumer<GetAllProductsBloc, GetAllProductsState>(
                      listener: (context, state) {
                        if (state is ForbiddenGetProducts) {
                          errorMessage(
                              context, "unauthorized".tr(), [state.message]);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginWindows(),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state case SuccessGettingProducts()) {
                          return Column(
                            children: [
                              Expanded(
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: Responsive.isDesktop(
                                                  context)
                                              ? (MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      1630
                                                  ? 4
                                                  : MediaQuery.of(context)
                                                              .size
                                                              .width >
                                                          1250
                                                      ? 3
                                                      : 2)
                                              : (MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      946
                                                  ? 4
                                                  : MediaQuery.of(context)
                                                              .size
                                                              .width >
                                                          719
                                                      ? 3
                                                      : MediaQuery.of(context)
                                                                  .size
                                                                  .width >
                                                              494
                                                          ? 2
                                                          : 1),
                                          crossAxisSpacing: 0,
                                          mainAxisSpacing: 8,
                                          mainAxisExtent: 262),
                                  itemCount: state.response.body.length,
                                  itemBuilder: (context, index) {
                                    var product = ProductModel.fromMap(
                                        state.response.body[index].toMap());
                                    return ProductCardWidget(
                                      product: product,
                                      delete: () {
                                        context.read<DeleteProductBloc>().add(
                                              DeleteProduct(
                                                id: state
                                                    .response.body[index].id,
                                              ),
                                            );
                                      },
                                      edit: (p) {
                                        context.read<EditProductBloc>().add(
                                              EditProduct(
                                                product: p,
                                                id: state
                                                    .response.body[index].id,
                                              ),
                                            );
                                      },
                                    );
                                  },
                                ),
                              ),
                              PaginationWidget(
                                  currentPage: currentPage,
                                  totalPages:
                                      (state.response.pageable.total / perPage)
                                          .ceil(),
                                  onPageChanged: (page) {
                                    context.read<GetAllProductsBloc>().add(
                                        GetAllProducts(
                                            page: page, size: perPage));
                                    setState(() {
                                      currentPage = page;
                                    });
                                  })
                            ],
                          );
                        } else if (state case LoadingGetProducts()) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Loading...",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.white),
                              ),
                              SizedBox(height: 20),
                              CircularProgressIndicator(),
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Loading...",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.white),
                              ),
                              SizedBox(height: 20),
                              CircularProgressIndicator(),
                            ],
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 0,
                child: Responsive.isMobile(context)
                    ? FloatingActionButton(
                        onPressed: () {
                          addProductDialog(context, (product) {
                            context
                                .read<AddProductBloc>()
                                .add(AddProduct(product: product));
                          });
                        },
                        backgroundColor: Colors.white,
                        foregroundColor: navy,
                        child: const Icon(
                          Icons.add_box,
                          color: orange,
                        ),
                      )
                    : FloatingActionButton.extended(
                        onPressed: () {
                          addProductDialog(context, (product) {
                            context
                                .read<AddProductBloc>()
                                .add(AddProduct(product: product));
                          });
                        },
                        icon: const Icon(
                          Icons.add_box,
                          color: orange,
                        ),
                        label: Text(
                          "add_product".tr(),
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: navy,
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
