import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  int perPage = 18;
  int currentPage = 1;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetAllProductsBloc(
            GetAllProductsUsecase(
              getAllProductsRepo: GetAllProductsRepo(
                getAllProductsService: GetAllProductsService(dio: Dio()),
                networkConnection: NetworkConnection.createDefault(),
              ),
            ),
          )..add(GetAllProducts(page: 0, size: 10000)),
        ),
        BlocProvider(
          create: (context) => DeleteProductBloc(
            DeleteProductUsecase(
              deleteProductRepo: DeleteProductRepo(
                deleteProductService: DeleteProductService(dio: Dio()),
                networkConnection: NetworkConnection.createDefault(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => EditProductBloc(
            EditProductUsecase(
              editProductRepo: EditProductRepo(
                editProductService: EditProductService(dio: Dio()),
                networkConnection: NetworkConnection.createDefault(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => AddProductBloc(
            AddProductUsecase(
              addProductRepo: AddProductRepo(
                addProductService: AddProductService(dio: Dio()),
                networkConnection: NetworkConnection.createDefault(),
              ),
            ),
          ),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<DeleteProductBloc, DeleteProductState>(
            listener: (context, state) {
              if (state is ProductDeleted) {
                context
                    .read<GetAllProductsBloc>()
                    .add(GetAllProducts(page: currentPage - 1, size: perPage));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      state.response,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                );
              } else if (state is ExceptionDeleteProduct) {
                errorMessage(context, "error".tr(), [state.message]);
              } else if (state is ForbiddenDeleteProduct) {
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
          BlocListener<EditProductBloc, EditProductState>(
            listener: (context, state) {
              switch (state) {
                case ProductEdited():
                  context.read<GetAllProductsBloc>().add(
                      GetAllProducts(page: currentPage - 1, size: perPage));
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
          BlocListener<AddProductBloc, AddProductState>(
            listener: (context, state) {
              if (state case ProductAdded()) {
                context
                    .read<GetAllProductsBloc>()
                    .add(GetAllProducts(page: currentPage - 1, size: perPage));
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
          final isMobile = Responsive.isMobile(context);

          return Scaffold(
            backgroundColor: darkNavy,
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Desktop Title
                      if (Responsive.isDesktop(context))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      yellow.withOpacity(0.25),
                                      yellow.withOpacity(0.15),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: yellow.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.restaurant_menu,
                                  color: yellow,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                "buffet".tr(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Search bar + Add product button
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: navy,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (value) => setState(
                                      () => _searchQuery = value.trim()),
                                  decoration: InputDecoration(
                                    hintText: 'search_by_name_or_qr'.tr(),
                                    hintStyle: TextStyle(
                                      color: lightGrey,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search_rounded,
                                      color: lightGrey,
                                      size: 22,
                                    ),
                                    suffixIcon: _searchQuery.isNotEmpty
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.close_rounded,
                                              color: lightGrey,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              _searchController.clear();
                                              setState(() => _searchQuery = '');
                                            },
                                            splashRadius: 20,
                                          )
                                        : null,
                                    filled: true,
                                    fillColor: darkNavy,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: orange,
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: Colors.white.withOpacity(0.15),
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: const BorderSide(
                                        color: orange,
                                        width: 1,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 16,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  foregroundColor: orange,
                                  backgroundColor: yellow,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () {
                                  addProductDialog(context, (product) {
                                    context
                                        .read<AddProductBloc>()
                                        .add(AddProduct(product: product));
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Icon(
                                    Icons.add_rounded,
                                    color: navy,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Products Grid
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
                            final query = _searchQuery.trim().toLowerCase();
                            final filteredList = query.isEmpty
                                ? state.response.body
                                : state.response.body.where((p) {
                                    final nameMatch =
                                        p.name.toLowerCase().contains(query);
                                    final barcodeMatch =
                                        p.barCode.toLowerCase().contains(query);
                                    return nameMatch || barcodeMatch;
                                  }).toList();
                            final sortedProducts = [
                              ...filteredList.where((p) => p.quantity == 0),
                              ...filteredList.where((p) => p.quantity != 0),
                            ];
                            if (filteredList.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(40),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFF1A2F4A),
                                      const Color(0xFF0F1E2E),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.restaurant_outlined,
                                      size: 64,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "No products found".tr(),
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Add your first product to get started"
                                          .tr(),
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Column(
                              children: [
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: Responsive.isDesktop(
                                            context)
                                        ? (MediaQuery.of(context).size.width >
                                                1630
                                            ? 4
                                            : MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    1250
                                                ? 3
                                                : 2)
                                        : (MediaQuery.of(context).size.width >
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
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    // Product cards contain multiple stacked sections,
                                    // so they need a stable height instead of square cells.
                                    // mainAxisExtent: 380,
                                    mainAxisExtent: 384,
                                  ),
                                  itemCount: sortedProducts.length,
                                  itemBuilder: (context, index) {
                                    final item = sortedProducts[index];
                                    var product =
                                        ProductModel.fromMap(item.toMap());
                                    return ProductCardWidget(
                                      product: product,
                                      delete: () {
                                        context.read<DeleteProductBloc>().add(
                                              DeleteProduct(id: item.id),
                                            );
                                      },
                                      edit: (p) {
                                        context.read<EditProductBloc>().add(
                                              EditProduct(
                                                product: p,
                                                id: item.id,
                                              ),
                                            );
                                      },
                                    );
                                  },
                                ),
                                // const SizedBox(height: 24),
                                // PaginationWidget(
                                //   currentPage: currentPage,
                                //   totalPages: (state.response.pageable.total /
                                //           perPage)
                                //       .ceil(),
                                //   onPageChanged: (page) {
                                //     context.read<GetAllProductsBloc>().add(
                                //         GetAllProducts(
                                //             page: page - 1, size: perPage));
                                //     setState(() {
                                //       currentPage = page;
                                //     });
                                //   },
                                // ),
                              ],
                            );
                          } else if (state case LoadingGetProducts()) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
