import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse/common/widget/header.dart';
import 'package:lighthouse/common/widget/pagination.dart';
import 'package:lighthouse/common/widget/my_button.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/features/coupons/data/models/coupon_model.dart';
import 'package:lighthouse/features/coupons/data/repository/deactivate_coupon_repo.dart';
import 'package:lighthouse/features/coupons/data/repository/delete_coupon_repo.dart';
import 'package:lighthouse/features/coupons/data/repository/generate_coupon_repo.dart';
import 'package:lighthouse/features/coupons/data/repository/get_all_coupons_repo.dart';
import 'package:lighthouse/features/coupons/data/source/remote/deactivate_coupon_service.dart';
import 'package:lighthouse/features/coupons/data/source/remote/delete_coupon_service.dart';
import 'package:lighthouse/features/coupons/data/source/remote/generate_coupon_service.dart';
import 'package:lighthouse/features/coupons/data/source/remote/get_all_coupons_service.dart';
import 'package:lighthouse/features/coupons/domain/usecase/deactivate_coupon_usecase.dart';
import 'package:lighthouse/features/coupons/domain/usecase/delete_coupon_usecase.dart';
import 'package:lighthouse/features/coupons/domain/usecase/generate_coupon_usecase.dart';
import 'package:lighthouse/features/coupons/domain/usecase/get_all_coupons_usecase.dart';
import 'package:lighthouse/features/coupons/presentation/bloc/deactivate_coupon_bloc.dart';
import 'package:lighthouse/features/coupons/presentation/bloc/delete_coupon_bloc.dart';
import 'package:lighthouse/features/coupons/presentation/bloc/generate_coupon_bloc.dart';
import 'package:lighthouse/features/coupons/presentation/bloc/get_all_coupons_bloc.dart';
import 'package:lighthouse/features/coupons/presentation/widget/coupon_card_widget.dart';
import 'package:lighthouse/features/coupons/presentation/widget/coupons_table_widget.dart';
import 'package:lighthouse/features/coupons/presentation/widget/generate_coupon_dialog.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  int currentPage = 0;
  int perPage = 10;
  int totalPages = 1;
  bool? activeFilter;
  String? discountTypeFilter;
  String? appliesToFilter;
  String? codeSubstringFilter;
  final TextEditingController _searchController = TextEditingController();
  bool _isTableView = false; // false = cards view, true = table view

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
          create: (context) => GetAllCouponsBloc(
            GetAllCouponsUsecase(
              getAllCouponsRepo: GetAllCouponsRepo(
                getAllCouponsService: GetAllCouponsService(dio: Dio()),
                networkConnection: NetworkConnection(
                  internetConnectionChecker:
                      InternetConnectionChecker.createInstance(
                    addresses: [
                      AddressCheckOption(
                        uri: Uri.parse("https://www.google.com"),
                        timeout: const Duration(seconds: 3),
                      ),
                      AddressCheckOption(
                        uri: Uri.parse("https://1.1.1.1"),
                        timeout: const Duration(seconds: 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )..add(GetAllCoupons(
              page: currentPage,
              size: perPage,
              active: activeFilter,
              discountType: discountTypeFilter,
              appliesTo: appliesToFilter,
              codeSubstring: codeSubstringFilter,
            )),
        ),
        BlocProvider(
          create: (context) => GenerateCouponBloc(
            GenerateCouponUsecase(
              generateCouponRepo: GenerateCouponRepo(
                generateCouponService: GenerateCouponService(dio: Dio()),
                networkConnection: NetworkConnection(
                  internetConnectionChecker:
                      InternetConnectionChecker.createInstance(
                    addresses: [
                      AddressCheckOption(
                        uri: Uri.parse("https://www.google.com"),
                        timeout: const Duration(seconds: 3),
                      ),
                      AddressCheckOption(
                        uri: Uri.parse("https://1.1.1.1"),
                        timeout: const Duration(seconds: 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => DeactivateCouponBloc(
            DeactivateCouponUsecase(
              deactivateCouponRepo: DeactivateCouponRepo(
                deactivateCouponService: DeactivateCouponService(dio: Dio()),
                networkConnection: NetworkConnection(
                  internetConnectionChecker:
                      InternetConnectionChecker.createInstance(
                    addresses: [
                      AddressCheckOption(
                        uri: Uri.parse("https://www.google.com"),
                        timeout: const Duration(seconds: 3),
                      ),
                      AddressCheckOption(
                        uri: Uri.parse("https://1.1.1.1"),
                        timeout: const Duration(seconds: 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => DeleteCouponBloc(
            DeleteCouponUsecase(
              deleteCouponRepo: DeleteCouponRepo(
                deleteCouponService: DeleteCouponService(dio: Dio()),
                networkConnection: NetworkConnection(
                  internetConnectionChecker:
                      InternetConnectionChecker.createInstance(
                    addresses: [
                      AddressCheckOption(
                        uri: Uri.parse("https://www.google.com"),
                        timeout: const Duration(seconds: 3),
                      ),
                      AddressCheckOption(
                        uri: Uri.parse("https://1.1.1.1"),
                        timeout: const Duration(seconds: 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<GenerateCouponBloc, GenerateCouponState>(
            listener: (context, state) {
              if (state is SuccessGenerateCoupon) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      "Coupons generated successfully".tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
                context.read<GetAllCouponsBloc>().add(GetAllCoupons(
                      page: currentPage,
                      size: perPage,
                      active: activeFilter,
                      discountType: discountTypeFilter,
                      appliesTo: appliesToFilter,
                      codeSubstring: codeSubstringFilter,
                    ));
              } else if (state is ExceptionGenerateCoupon) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      state.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              } else if (state is OfflineFailureGenerateCoupon) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.orange,
                    content: Text(
                      state.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }
            },
          ),
          BlocListener<DeactivateCouponBloc, DeactivateCouponState>(
            listener: (context, state) {
              if (state is SuccessDeactivateCoupon) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      "Coupon deactivated successfully".tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
                context.read<GetAllCouponsBloc>().add(GetAllCoupons(
                      page: currentPage,
                      size: perPage,
                      active: activeFilter,
                      discountType: discountTypeFilter,
                      appliesTo: appliesToFilter,
                      codeSubstring: codeSubstringFilter,
                    ));
              } else if (state is ExceptionDeactivateCoupon) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      state.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              } else if (state is OfflineFailureDeactivateCoupon) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.orange,
                    content: Text(
                      state.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }
            },
          ),
          BlocListener<DeleteCouponBloc, DeleteCouponState>(
            listener: (context, state) {
              if (state is SuccessDeleteCoupon) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      "Coupon deleted successfully".tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
                context.read<GetAllCouponsBloc>().add(GetAllCoupons(
                      page: currentPage,
                      size: perPage,
                      active: activeFilter,
                      discountType: discountTypeFilter,
                      appliesTo: appliesToFilter,
                      codeSubstring: codeSubstringFilter,
                    ));
              } else if (state is ExceptionDeleteCoupon) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      state.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              } else if (state is OfflineFailureDeleteCoupon) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.orange,
                    content: Text(
                      state.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }
            },
          ),
        ],
        child: Builder(
          builder: (context) {
            return Scaffold(
              body: SafeArea(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          HeaderWidget(
                            title: "Coupons".tr(),
                          ),
                          const SizedBox(height: 25),
                          if (Responsive.isDesktop(context))
                            Text(
                              "Coupons".tr(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          if (Responsive.isDesktop(context))
                            const SizedBox(height: 40),
                        ],
                      ),
                    ),
                    // Filters Section
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Filter Chips Row
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isNarrow = constraints.maxWidth < 600;
                                if (isNarrow) {
                                  return Column(
                                    children: [
                                      _buildFilterChips(context),
                                      const SizedBox(height: 12),
                                      // View Toggle
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: grey.withOpacity(0.2),
                                            width: 1.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.03),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Expanded(
                                              child: _buildViewToggleButton(
                                                icon: Icons.view_module_rounded,
                                                isSelected: !_isTableView,
                                                onTap: () {
                                                  setState(() {
                                                    _isTableView = false;
                                                    perPage = 10;
                                                    currentPage = 0;
                                                  });
                                                  _refreshCoupons(context);
                                                },
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              height: 30,
                                              color: grey.withOpacity(0.2),
                                            ),
                                            Expanded(
                                              child: _buildViewToggleButton(
                                                icon: Icons.table_chart_rounded,
                                                isSelected: _isTableView,
                                                onTap: () {
                                                  setState(() {
                                                    _isTableView = true;
                                                    perPage = 50;
                                                    currentPage = 0;
                                                  });
                                                  _refreshCoupons(context);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              orange,
                                              orange.withOpacity(0.8)
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: orange.withOpacity(0.4),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: MyButton(
                                          onPressed: () {
                                            showGenerateCouponDialog(context);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.add_rounded,
                                                  color: Colors.white,
                                                  size: 22),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Generate Coupon".tr(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildFilterChips(context),
                                    // View Toggle
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: grey.withOpacity(0.2),
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.03),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildViewToggleButton(
                                            icon: Icons.view_module_rounded,
                                            isSelected: !_isTableView,
                                            onTap: () {
                                              setState(() {
                                                _isTableView = false;
                                                perPage = 10;
                                                currentPage = 0;
                                              });
                                              _refreshCoupons(context);
                                            },
                                          ),
                                          Container(
                                            width: 1,
                                            height: 30,
                                            color: grey.withOpacity(0.2),
                                          ),
                                          _buildViewToggleButton(
                                            icon: Icons.table_chart_rounded,
                                            isSelected: _isTableView,
                                            onTap: () {
                                              setState(() {
                                                _isTableView = true;
                                                perPage = 50;
                                                currentPage = 0;
                                              });
                                              _refreshCoupons(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            orange,
                                            orange.withOpacity(0.8)
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: orange.withOpacity(0.4),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: MyButton(
                                        onPressed: () {
                                          showGenerateCouponDialog(context);
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.add_rounded,
                                                color: Colors.white, size: 22),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Generate Coupon".tr(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            // Search Bar
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: grey.withOpacity(0.2),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ValueListenableBuilder<TextEditingValue>(
                                valueListenable: _searchController,
                                builder: (context, value, child) {
                                  return TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      hintText: "Search by coupon code...".tr(),
                                      prefixIcon: Container(
                                        margin: const EdgeInsets.all(10),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: orange.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                          Icons.search_rounded,
                                          color: orange,
                                          size: 20,
                                        ),
                                      ),
                                      suffixIcon: value.text.isNotEmpty
                                          ? IconButton(
                                              icon: const Icon(
                                                  Icons.clear_rounded,
                                                  color: grey),
                                              onPressed: () {
                                                setState(() {
                                                  _searchController.clear();
                                                  codeSubstringFilter = null;
                                                });
                                                _refreshCoupons(context);
                                              },
                                            )
                                          : null,
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 16),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: darkNavy,
                                    ),
                                    onChanged: (text) {
                                      setState(() {
                                        codeSubstringFilter =
                                            text.isEmpty ? null : text;
                                      });
                                      // Debounce search - refresh after user stops typing
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        if (_searchController.text == text) {
                                          _refreshCoupons(context);
                                        }
                                      });
                                    },
                                    onSubmitted: (_) {
                                      _refreshCoupons(context);
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Additional Filters
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isNarrow = constraints.maxWidth < 600;
                                if (isNarrow) {
                                  return Column(
                                    children: [
                                      _buildDiscountTypeFilters(context),
                                      const SizedBox(height: 12),
                                      _buildAppliesToFilters(context),
                                    ],
                                  );
                                }
                                return Row(
                                  children: [
                                    Expanded(
                                      child: _buildDiscountTypeFilters(context),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildAppliesToFilters(context),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Coupons List
                    BlocBuilder<GetAllCouponsBloc, GetAllCouponsState>(
                      builder: (context, state) {
                        if (state is LoadingGetAllCoupons) {
                          return SliverFillRemaining(
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (state is SuccessGetAllCoupons) {
                          final coupons = state.response.body;
                          final total = state.response.pageable.total;
                          totalPages = total > 0 ? (total / perPage).ceil() : 1;

                          if (coupons.isEmpty) {
                            return SliverFillRemaining(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.local_offer_outlined,
                                        size: 64,
                                        color: grey,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      "No coupons found".tr(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: darkNavy,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Generate your first coupon to get started"
                                          .tr(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index == coupons.length) {
                                  // Pagination widget
                                  if (totalPages > 1) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: PaginationWidget(
                                        currentPage: currentPage + 1,
                                        totalPages: totalPages,
                                        onPageChanged: (page) {
                                          setState(() {
                                            currentPage = page - 1;
                                          });
                                          context.read<GetAllCouponsBloc>().add(
                                                GetAllCoupons(
                                                  page: currentPage,
                                                  size: perPage,
                                                  active: activeFilter,
                                                  discountType:
                                                      discountTypeFilter,
                                                  appliesTo: appliesToFilter,
                                                  codeSubstring:
                                                      codeSubstringFilter,
                                                ),
                                              );
                                        },
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                }

                                if (_isTableView) {
                                  // Table view - show all in one widget
                                  if (index == 0) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: CouponsTableWidget(
                                        coupons: coupons,
                                        onDeactivate: (coupon) {
                                          if (coupon.active) {
                                            _showDeactivateDialog(
                                                context, coupon);
                                          }
                                        },
                                        onDelete: (coupon) {
                                          if (coupon.usedCount == 0) {
                                            _showDeleteDialog(context, coupon);
                                          }
                                        },
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                } else {
                                  // Cards view
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: CouponCardWidget(
                                      coupon: coupons[index],
                                      onDeactivate: coupons[index].active
                                          ? () {
                                              _showDeactivateDialog(
                                                  context, coupons[index]);
                                            }
                                          : null,
                                      onDelete: coupons[index].usedCount == 0
                                          ? () {
                                              _showDeleteDialog(
                                                  context, coupons[index]);
                                            }
                                          : null,
                                    ),
                                  );
                                }
                              },
                              childCount: _isTableView
                                  ? (totalPages > 1 ? 2 : 1)
                                  : coupons.length + (totalPages > 1 ? 1 : 0),
                            ),
                          );
                        } else if (state is NoCouponsToShow) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.local_offer_outlined,
                                    size: 64,
                                    color: grey,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    state.message,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (state is ExceptionGetAllCoupons ||
                            state is OfflineFailureGetAllCoupons) {
                          final message = state is ExceptionGetAllCoupons
                              ? state.message
                              : (state as OfflineFailureGetAllCoupons).message;
                          return SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 64,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    message,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.red,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return const SliverToBoxAdapter(
                          child: SizedBox.shrink(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildFilterChip(
          label: "All".tr(),
          isSelected: activeFilter == null,
          color: navy,
          icon: Icons.all_inclusive_rounded,
          onTap: () {
            setState(() {
              activeFilter = null;
            });
            _refreshCoupons(context);
          },
        ),
        _buildFilterChip(
          label: "Active".tr(),
          isSelected: activeFilter == true,
          color: Colors.green,
          icon: Icons.check_circle_rounded,
          onTap: () {
            setState(() {
              activeFilter = true;
            });
            _refreshCoupons(context);
          },
        ),
        _buildFilterChip(
          label: "Inactive".tr(),
          isSelected: activeFilter == false,
          color: Colors.red,
          icon: Icons.cancel_rounded,
          onTap: () {
            setState(() {
              activeFilter = false;
            });
            _refreshCoupons(context);
          },
        ),
      ],
    );
  }

  Widget _buildDiscountTypeFilters(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: grey.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.percent_rounded,
                  color: orange,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Discount Type".tr(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildFilterChip(
                  label: "Amount".tr(),
                  isSelected: discountTypeFilter == "AMOUNT",
                  color: Colors.purple,
                  icon: Icons.attach_money_rounded,
                  onTap: () {
                    setState(() {
                      discountTypeFilter =
                          discountTypeFilter == "AMOUNT" ? null : "AMOUNT";
                    });
                    _refreshCoupons(context);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterChip(
                  label: "Percent".tr(),
                  isSelected: discountTypeFilter == "PERCENT",
                  color: Colors.blue,
                  icon: Icons.percent_rounded,
                  onTap: () {
                    setState(() {
                      discountTypeFilter =
                          discountTypeFilter == "PERCENT" ? null : "PERCENT";
                    });
                    _refreshCoupons(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppliesToFilters(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: grey.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.category_rounded,
                  color: orange,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Applies To".tr(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildFilterChip(
                label: "Session".tr(),
                isSelected: appliesToFilter == "SESSION_INVOICE",
                color: Colors.teal,
                icon: Icons.access_time_rounded,
                onTap: () {
                  setState(() {
                    appliesToFilter = appliesToFilter == "SESSION_INVOICE"
                        ? null
                        : "SESSION_INVOICE";
                  });
                  _refreshCoupons(context);
                },
              ),
              _buildFilterChip(
                label: "Buffet".tr(),
                isSelected: appliesToFilter == "BUFFET_INVOICE",
                color: Colors.orange,
                icon: Icons.restaurant_rounded,
                onTap: () {
                  setState(() {
                    appliesToFilter = appliesToFilter == "BUFFET_INVOICE"
                        ? null
                        : "BUFFET_INVOICE";
                  });
                  _refreshCoupons(context);
                },
              ),
              _buildFilterChip(
                label: "Total".tr(),
                isSelected: appliesToFilter == "TOTAL_INVOICE",
                color: Colors.indigo,
                icon: Icons.receipt_long_rounded,
                onTap: () {
                  setState(() {
                    appliesToFilter = appliesToFilter == "TOTAL_INVOICE"
                        ? null
                        : "TOTAL_INVOICE";
                  });
                  _refreshCoupons(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggleButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [orange, orange.withOpacity(0.8)],
                  )
                : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : grey,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: icon != null ? 12 : 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, color.withOpacity(0.85)],
                  )
                : null,
            color: isSelected ? null : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color.withOpacity(0.3) : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? Colors.white : color,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : darkNavy,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _refreshCoupons(BuildContext context) {
    setState(() {
      currentPage = 0;
    });
    context.read<GetAllCouponsBloc>().add(
          GetAllCoupons(
            page: currentPage,
            size: perPage,
            active: activeFilter,
            discountType: discountTypeFilter,
            appliesTo: appliesToFilter,
            codeSubstring: codeSubstringFilter,
          ),
        );
  }

  void _showDeactivateDialog(BuildContext context, CouponModel coupon) {
    // Get the bloc from the parent context
    final deactivateCouponBloc = context.read<DeactivateCouponBloc>();

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: deactivateCouponBloc,
          child: BlocListener<DeactivateCouponBloc, DeactivateCouponState>(
            listener: (context, state) {
              if (state is SuccessDeactivateCoupon) {
                Navigator.of(context).pop();
              }
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.warning_rounded,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Deactivate Coupon".tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: darkNavy,
                      ),
                    ),
                  ),
                ],
              ),
              content: Text(
                "Are you sure you want to deactivate coupon ${coupon.code}?"
                    .tr(),
                style: const TextStyle(
                  fontSize: 15,
                  color: grey,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    "Cancel".tr(),
                    style: const TextStyle(
                      color: grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                BlocBuilder<DeactivateCouponBloc, DeactivateCouponState>(
                  builder: (context, state) {
                    final isLoading = state is LoadingDeactivateCoupon;
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.red.shade600,
                            Colors.red.shade700,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                context.read<DeactivateCouponBloc>().add(
                                      DeactivateCoupon(couponId: coupon.id),
                                    );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.block_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Deactivate".tr(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, CouponModel coupon) {
    // Get the bloc from the parent context
    final deleteCouponBloc = context.read<DeleteCouponBloc>();

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: deleteCouponBloc,
          child: BlocListener<DeleteCouponBloc, DeleteCouponState>(
            listener: (context, state) {
              if (state is SuccessDeleteCoupon) {
                Navigator.of(context).pop();
              }
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Delete Coupon".tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: darkNavy,
                      ),
                    ),
                  ),
                ],
              ),
              content: Text(
                "Are you sure you want to delete coupon ${coupon.code}? This action cannot be undone."
                    .tr(),
                style: const TextStyle(
                  fontSize: 15,
                  color: grey,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    "Cancel".tr(),
                    style: const TextStyle(
                      color: grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                BlocBuilder<DeleteCouponBloc, DeleteCouponState>(
                  builder: (context, state) {
                    final isLoading = state is LoadingDeleteCoupon;
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.red.shade600,
                            Colors.red.shade700,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                context.read<DeleteCouponBloc>().add(
                                      DeleteCoupon(couponId: coupon.id),
                                    );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.delete_forever_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Delete".tr(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
