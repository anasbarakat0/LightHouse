// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StatisticsOverviewResponseModel {
  final String message;
  final String status;
  final String localDateTime;
  final StatisticsOverviewBody body;

  StatisticsOverviewResponseModel({
    required this.message,
    required this.status,
    required this.localDateTime,
    required this.body,
  });

  factory StatisticsOverviewResponseModel.fromMap(Map<String, dynamic> map) {
    return StatisticsOverviewResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      localDateTime: map['localDateTime'] as String,
      body: StatisticsOverviewBody.fromMap(map['body'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'status': status,
      'localDateTime': localDateTime,
      'body': body.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  factory StatisticsOverviewResponseModel.fromJson(String source) =>
      StatisticsOverviewResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class StatisticsOverviewBody {
  final RevenueStatistics revenue;
  final SessionsStatistics sessions;
  final UsersStatistics users;
  final BuffetStatistics buffet;
  final PackagesStatistics packages;
  final CouponsStatistics coupons;
  final RealTimeStatistics realTime;

  StatisticsOverviewBody({
    required this.revenue,
    required this.sessions,
    required this.users,
    required this.buffet,
    required this.packages,
    required this.coupons,
    required this.realTime,
  });

  factory StatisticsOverviewBody.fromMap(Map<String, dynamic> map) {
    return StatisticsOverviewBody(
      revenue: RevenueStatistics.fromMap(map['revenue'] as Map<String, dynamic>),
      sessions: SessionsStatistics.fromMap(map['sessions'] as Map<String, dynamic>),
      users: UsersStatistics.fromMap(map['users'] as Map<String, dynamic>),
      buffet: BuffetStatistics.fromMap(map['buffet'] as Map<String, dynamic>),
      packages: PackagesStatistics.fromMap(map['packages'] as Map<String, dynamic>),
      coupons: CouponsStatistics.fromMap(map['coupons'] as Map<String, dynamic>),
      realTime: RealTimeStatistics.fromMap(map['realTime'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'revenue': revenue.toMap(),
      'sessions': sessions.toMap(),
      'users': users.toMap(),
      'buffet': buffet.toMap(),
      'packages': packages.toMap(),
      'coupons': coupons.toMap(),
      'realTime': realTime.toMap(),
    };
  }
}

class RevenueStatistics {
  final double totalRevenue;
  final double sessionRevenue;
  final double buffetRevenue;
  final double packagesRevenue;
  final double revenueBeforeDiscounts;
  final double couponDiscounts;
  final double manualDiscounts;
  final double netRevenue;
  final double premiumRevenue;
  final double expressRevenue;

  RevenueStatistics({
    required this.totalRevenue,
    required this.sessionRevenue,
    required this.buffetRevenue,
    required this.packagesRevenue,
    required this.revenueBeforeDiscounts,
    required this.couponDiscounts,
    required this.manualDiscounts,
    required this.netRevenue,
    required this.premiumRevenue,
    required this.expressRevenue,
  });

  factory RevenueStatistics.fromMap(Map<String, dynamic> map) {
    return RevenueStatistics(
      totalRevenue: (map['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      sessionRevenue: (map['sessionRevenue'] as num?)?.toDouble() ?? 0.0,
      buffetRevenue: (map['buffetRevenue'] as num?)?.toDouble() ?? 0.0,
      packagesRevenue: (map['packagesRevenue'] as num?)?.toDouble() ?? 0.0,
      revenueBeforeDiscounts: (map['revenueBeforeDiscounts'] as num?)?.toDouble() ?? 0.0,
      couponDiscounts: (map['couponDiscounts'] as num?)?.toDouble() ?? 0.0,
      manualDiscounts: (map['manualDiscounts'] as num?)?.toDouble() ?? 0.0,
      netRevenue: (map['netRevenue'] as num?)?.toDouble() ?? 0.0,
      premiumRevenue: (map['premiumRevenue'] as num?)?.toDouble() ?? 0.0,
      expressRevenue: (map['expressRevenue'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalRevenue': totalRevenue,
      'sessionRevenue': sessionRevenue,
      'buffetRevenue': buffetRevenue,
      'packagesRevenue': packagesRevenue,
      'revenueBeforeDiscounts': revenueBeforeDiscounts,
      'couponDiscounts': couponDiscounts,
      'manualDiscounts': manualDiscounts,
      'netRevenue': netRevenue,
      'premiumRevenue': premiumRevenue,
      'expressRevenue': expressRevenue,
    };
  }
}

class SessionsStatistics {
  final int totalSessions;
  final int premiumSessions;
  final int expressSessions;
  final int activeSessions;
  final int completedSessions;
  final double averagePremiumDuration;
  final double averageExpressDuration;
  final double averageOverallDuration;
  final double totalHours;

  SessionsStatistics({
    required this.totalSessions,
    required this.premiumSessions,
    required this.expressSessions,
    required this.activeSessions,
    required this.completedSessions,
    required this.averagePremiumDuration,
    required this.averageExpressDuration,
    required this.averageOverallDuration,
    required this.totalHours,
  });

  factory SessionsStatistics.fromMap(Map<String, dynamic> map) {
    return SessionsStatistics(
      totalSessions: map['totalSessions'] as int? ?? 0,
      premiumSessions: map['premiumSessions'] as int? ?? 0,
      expressSessions: map['expressSessions'] as int? ?? 0,
      activeSessions: map['activeSessions'] as int? ?? 0,
      completedSessions: map['completedSessions'] as int? ?? 0,
      averagePremiumDuration: (map['averagePremiumDuration'] as num?)?.toDouble() ?? 0.0,
      averageExpressDuration: (map['averageExpressDuration'] as num?)?.toDouble() ?? 0.0,
      averageOverallDuration: (map['averageOverallDuration'] as num?)?.toDouble() ?? 0.0,
      totalHours: (map['totalHours'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalSessions': totalSessions,
      'premiumSessions': premiumSessions,
      'expressSessions': expressSessions,
      'activeSessions': activeSessions,
      'completedSessions': completedSessions,
      'averagePremiumDuration': averagePremiumDuration,
      'averageExpressDuration': averageExpressDuration,
      'averageOverallDuration': averageOverallDuration,
      'totalHours': totalHours,
    };
  }
}

class UsersStatistics {
  final int totalPremiumUsers;
  final int activePremiumUsers;
  final int newUsers;
  final int usersWithPackages;
  final List<TopActiveUser> topActiveUsers;

  UsersStatistics({
    required this.totalPremiumUsers,
    required this.activePremiumUsers,
    required this.newUsers,
    required this.usersWithPackages,
    required this.topActiveUsers,
  });

  factory UsersStatistics.fromMap(Map<String, dynamic> map) {
    return UsersStatistics(
      totalPremiumUsers: map['totalPremiumUsers'] as int? ?? 0,
      activePremiumUsers: map['activePremiumUsers'] as int? ?? 0,
      newUsers: map['newUsers'] as int? ?? 0,
      usersWithPackages: map['usersWithPackages'] as int? ?? 0,
      topActiveUsers: (map['topActiveUsers'] as List<dynamic>?)
              ?.map((x) => TopActiveUser.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalPremiumUsers': totalPremiumUsers,
      'activePremiumUsers': activePremiumUsers,
      'newUsers': newUsers,
      'usersWithPackages': usersWithPackages,
      'topActiveUsers': topActiveUsers.map((x) => x.toMap()).toList(),
    };
  }
}

class TopActiveUser {
  final String userId;
  final String userName;
  final int totalSessions;
  final double totalSpent;
  final double averageSessionDuration;

  TopActiveUser({
    required this.userId,
    required this.userName,
    required this.totalSessions,
    required this.totalSpent,
    required this.averageSessionDuration,
  });

  factory TopActiveUser.fromMap(Map<String, dynamic> map) {
    return TopActiveUser(
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      totalSessions: map['totalSessions'] as int? ?? 0,
      totalSpent: (map['totalSpent'] as num?)?.toDouble() ?? 0.0,
      averageSessionDuration: (map['averageSessionDuration'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'totalSessions': totalSessions,
      'totalSpent': totalSpent,
      'averageSessionDuration': averageSessionDuration,
    };
  }
}

class BuffetStatistics {
  final double totalRevenue;
  final double averagePerSession;
  final int totalOrders;
  final List<TopSellingProduct> topSellingProducts;

  BuffetStatistics({
    required this.totalRevenue,
    required this.averagePerSession,
    required this.totalOrders,
    required this.topSellingProducts,
  });

  factory BuffetStatistics.fromMap(Map<String, dynamic> map) {
    return BuffetStatistics(
      totalRevenue: (map['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      averagePerSession: (map['averagePerSession'] as num?)?.toDouble() ?? 0.0,
      totalOrders: map['totalOrders'] as int? ?? 0,
      topSellingProducts: (map['topSellingProducts'] as List<dynamic>?)
              ?.map((x) => TopSellingProduct.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalRevenue': totalRevenue,
      'averagePerSession': averagePerSession,
      'totalOrders': totalOrders,
      'topSellingProducts': topSellingProducts.map((x) => x.toMap()).toList(),
    };
  }
}

class TopSellingProduct {
  final String productId;
  final String productName;
  final int totalQuantity;
  final double totalRevenue;
  final double averagePrice;

  TopSellingProduct({
    required this.productId,
    required this.productName,
    required this.totalQuantity,
    required this.totalRevenue,
    required this.averagePrice,
  });

  factory TopSellingProduct.fromMap(Map<String, dynamic> map) {
    return TopSellingProduct(
      productId: map['productId'] as String,
      productName: map['productName'] as String,
      totalQuantity: map['totalQuantity'] as int? ?? 0,
      totalRevenue: (map['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      averagePrice: (map['averagePrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'totalQuantity': totalQuantity,
      'totalRevenue': totalRevenue,
      'averagePrice': averagePrice,
    };
  }
}

class PackagesStatistics {
  final int totalPackagesSold;
  final int activePackages;
  final int expiredPackages;
  final double totalRevenue;
  final double averagePackageValue;
  final double totalHoursPurchased;
  final double totalHoursConsumed;
  final double remainingHours;
  final double utilizationRate;
  final List<PopularPackage> popularPackages;

  PackagesStatistics({
    required this.totalPackagesSold,
    required this.activePackages,
    required this.expiredPackages,
    required this.totalRevenue,
    required this.averagePackageValue,
    required this.totalHoursPurchased,
    required this.totalHoursConsumed,
    required this.remainingHours,
    required this.utilizationRate,
    required this.popularPackages,
  });

  factory PackagesStatistics.fromMap(Map<String, dynamic> map) {
    return PackagesStatistics(
      totalPackagesSold: map['totalPackagesSold'] as int? ?? 0,
      activePackages: map['activePackages'] as int? ?? 0,
      expiredPackages: map['expiredPackages'] as int? ?? 0,
      totalRevenue: (map['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      averagePackageValue: (map['averagePackageValue'] as num?)?.toDouble() ?? 0.0,
      totalHoursPurchased: (map['totalHoursPurchased'] as num?)?.toDouble() ?? 0.0,
      totalHoursConsumed: (map['totalHoursConsumed'] as num?)?.toDouble() ?? 0.0,
      remainingHours: (map['remainingHours'] as num?)?.toDouble() ?? 0.0,
      utilizationRate: (map['utilizationRate'] as num?)?.toDouble() ?? 0.0,
      popularPackages: (map['popularPackages'] as List<dynamic>?)
              ?.map((x) => PopularPackage.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalPackagesSold': totalPackagesSold,
      'activePackages': activePackages,
      'expiredPackages': expiredPackages,
      'totalRevenue': totalRevenue,
      'averagePackageValue': averagePackageValue,
      'totalHoursPurchased': totalHoursPurchased,
      'totalHoursConsumed': totalHoursConsumed,
      'remainingHours': remainingHours,
      'utilizationRate': utilizationRate,
      'popularPackages': popularPackages.map((x) => x.toMap()).toList(),
    };
  }
}

class PopularPackage {
  final String packageId;
  final String packageName;
  final int timesSold;
  final double totalRevenue;

  PopularPackage({
    required this.packageId,
    required this.packageName,
    required this.timesSold,
    required this.totalRevenue,
  });

  factory PopularPackage.fromMap(Map<String, dynamic> map) {
    return PopularPackage(
      packageId: map['packageId'] as String,
      packageName: map['packageName'] as String,
      timesSold: map['timesSold'] as int? ?? 0,
      totalRevenue: (map['totalRevenue'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'packageId': packageId,
      'packageName': packageName,
      'timesSold': timesSold,
      'totalRevenue': totalRevenue,
    };
  }
}

class CouponsStatistics {
  final int totalCoupons;
  final int activeCoupons;
  final int usedCoupons;
  final double totalDiscountGiven;
  final double averageDiscountPerUse;
  final double totalRevenueWithCoupons;
  final double netRevenue;
  final List<TopUsedCoupon> topUsedCoupons;

  CouponsStatistics({
    required this.totalCoupons,
    required this.activeCoupons,
    required this.usedCoupons,
    required this.totalDiscountGiven,
    required this.averageDiscountPerUse,
    required this.totalRevenueWithCoupons,
    required this.netRevenue,
    required this.topUsedCoupons,
  });

  factory CouponsStatistics.fromMap(Map<String, dynamic> map) {
    return CouponsStatistics(
      totalCoupons: map['totalCoupons'] as int? ?? 0,
      activeCoupons: map['activeCoupons'] as int? ?? 0,
      usedCoupons: map['usedCoupons'] as int? ?? 0,
      totalDiscountGiven: (map['totalDiscountGiven'] as num?)?.toDouble() ?? 0.0,
      averageDiscountPerUse: (map['averageDiscountPerUse'] as num?)?.toDouble() ?? 0.0,
      totalRevenueWithCoupons: (map['totalRevenueWithCoupons'] as num?)?.toDouble() ?? 0.0,
      netRevenue: (map['netRevenue'] as num?)?.toDouble() ?? 0.0,
      topUsedCoupons: (map['topUsedCoupons'] as List<dynamic>?)
              ?.map((x) => TopUsedCoupon.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalCoupons': totalCoupons,
      'activeCoupons': activeCoupons,
      'usedCoupons': usedCoupons,
      'totalDiscountGiven': totalDiscountGiven,
      'averageDiscountPerUse': averageDiscountPerUse,
      'totalRevenueWithCoupons': totalRevenueWithCoupons,
      'netRevenue': netRevenue,
      'topUsedCoupons': topUsedCoupons.map((x) => x.toMap()).toList(),
    };
  }
}

class TopUsedCoupon {
  final String couponCode;
  final int timesUsed;
  final double totalDiscount;
  final String discountType;

  TopUsedCoupon({
    required this.couponCode,
    required this.timesUsed,
    required this.totalDiscount,
    required this.discountType,
  });

  factory TopUsedCoupon.fromMap(Map<String, dynamic> map) {
    return TopUsedCoupon(
      couponCode: map['couponCode'] as String,
      timesUsed: map['timesUsed'] as int? ?? 0,
      totalDiscount: (map['totalDiscount'] as num?)?.toDouble() ?? 0.0,
      discountType: map['discountType'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'couponCode': couponCode,
      'timesUsed': timesUsed,
      'totalDiscount': totalDiscount,
      'discountType': discountType,
    };
  }
}

class RealTimeStatistics {
  final int activeSessions;
  final double todayRevenue;
  final int todaySessions;
  final double currentHourRevenue;
  final List<String> peakHours;
  final int activePremiumSessions;
  final int activeExpressSessions;

  RealTimeStatistics({
    required this.activeSessions,
    required this.todayRevenue,
    required this.todaySessions,
    required this.currentHourRevenue,
    required this.peakHours,
    required this.activePremiumSessions,
    required this.activeExpressSessions,
  });

  factory RealTimeStatistics.fromMap(Map<String, dynamic> map) {
    return RealTimeStatistics(
      activeSessions: map['activeSessions'] as int? ?? 0,
      todayRevenue: (map['todayRevenue'] as num?)?.toDouble() ?? 0.0,
      todaySessions: map['todaySessions'] as int? ?? 0,
      currentHourRevenue: (map['currentHourRevenue'] as num?)?.toDouble() ?? 0.0,
      peakHours: (map['peakHours'] as List<dynamic>?)?.map((x) => x.toString()).toList() ?? [],
      activePremiumSessions: map['activePremiumSessions'] as int? ?? 0,
      activeExpressSessions: map['activeExpressSessions'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'activeSessions': activeSessions,
      'todayRevenue': todayRevenue,
      'todaySessions': todaySessions,
      'currentHourRevenue': currentHourRevenue,
      'peakHours': peakHours,
      'activePremiumSessions': activePremiumSessions,
      'activeExpressSessions': activeExpressSessions,
    };
  }
}

