# خطة دمج Occupancy & Capacity APIs (محدثة ومصححة)

## نظرة عامة
تحديث التطبيق لاستخدام APIs الجديدة:
- GET `/api/v1/statistics/occupancy` للحصول على `onGround`, `visits`, `capacity` (بدون auth)
- PUT `/api/v1/statistics/capacity?capacity=...` لتحديث `capacity` (مع auth - MANAGER/SuperAdmin فقط)

## الملفات المطلوبة

### 1. Models
- `lib/features/statistics/data/models/occupancy_response_model.dart`
  - `OccupancyResponseModel` class مع:
    - `message` (String)
    - `status` (String)
    - `localDateTime` (String)
    - `body` (Body class)
  - `Body` class مع:
    - `onGround` (int) - مع null safety: `map['onGround'] as int? ?? 0`
    - `visits` (int) - مع null safety: `map['visits'] as int? ?? 0`
    - `capacity` (int) - مع null safety: `map['capacity'] as int? ?? 100`
  - جميع methods: `fromMap`, `toMap`, `copyWith`, `toString`, `==`, `hashCode`

- `lib/features/statistics/data/models/update_capacity_response_model.dart`
  - `UpdateCapacityResponseModel` class مع:
    - `message` (String)
    - `status` (String)
    - `localDateTime` (String)
    - `body` (Body class)
  - `Body` class مع:
    - `capacity` (int) - مع null safety: `map['capacity'] as int? ?? 100`
  - جميع methods: `fromMap`, `toMap`, `copyWith`, `toString`, `==`, `hashCode`

### 2. Services
- `lib/features/statistics/data/source/remote/get_occupancy_service.dart`
  - GET `/api/v1/statistics/occupancy`
  - **مهم جداً**: استخدام `getOptions(auth: false)` لأن API لا يحتاج authentication
  - Error handling: `BAD_REQUEST`, `Forbidden`, `DioException` مع null checks

- `lib/features/statistics/data/source/remote/update_capacity_service.dart`
  - PUT `/api/v1/statistics/capacity?capacity={value}`
  - استخدام `getOptions(auth: true)` لأن API يحتاج authentication
  - Error handling: `BAD_REQUEST`, `Forbidden`, `DioException` مع null checks
  - التأكد من معالجة `e.response == null` بشكل صحيح

### 3. Repositories
- `lib/features/statistics/data/repository/get_occupancy_repo.dart`
  - Network connection check
  - Error mapping: `BAD_REQUEST` -> `ServerFailure`, `Forbidden` -> `ForbiddenFailure`, `DioException` -> `ServerFailure`, `Offline` -> `OfflineFailure`
  - Null safety في error handling

- `lib/features/statistics/data/repository/update_capacity_repo.dart`
  - Network connection check
  - Error mapping: `BAD_REQUEST` -> `ServerFailure`, `Forbidden` -> `ForbiddenFailure`, `DioException` -> `ServerFailure` (مع null check), `Offline` -> `OfflineFailure`
  - Null safety في error handling

### 4. UseCases
- `lib/features/statistics/domain/usecase/get_occupancy_usecase.dart`
  - Call repository method

- `lib/features/statistics/domain/usecase/update_capacity_usecase.dart`
  - Call repository method with capacity parameter

### 5. Blocs
- `lib/features/statistics/presentation/bloc/get_occupancy_bloc.dart`
  - Events: `GetOccupancy`
  - States: 
    - `GetOccupancyInitial`
    - `LoadingOccupancy`
    - `SuccessOccupancy(onGround: int, visits: int, capacity: int)`
    - `ErrorOccupancy(message: String)`
    - `OfflineOccupancy(message: String)`
  - Error handling: `ServerFailure`, `OfflineFailure`, `ForbiddenFailure`

- `lib/features/statistics/presentation/bloc/update_capacity_bloc.dart`
  - Events: `UpdateCapacity(int capacity)`
  - States:
    - `UpdateCapacityInitial`
    - `LoadingCapacity`
    - `SuccessCapacity(capacity: int, message: String)`
    - `ErrorCapacity(message: String)`
    - `OfflineCapacity(message: String)`
    - `ForbiddenCapacity(message: String)`
  - Error handling: `ServerFailure`, `OfflineFailure`, `ForbiddenFailure`
  - عند Success: يجب تحديث `capacityNotifier.value` وإعادة استدعاء `GetOccupancyBloc`

### 6. تحديث UI Components

#### 6.1 `lib/features/main_window/presentation/widget/summary.dart`
- إضافة `GetOccupancyBloc` provider في `MultiBlocProvider`
- استبدال قراءة SharedPreferences بقراءة من Bloc state
- إضافة `BlocListener` للتعامل مع states:
  - `SuccessOccupancy`: تحديث `capacityNotifier.value`, `activeSessionsNotifier.value`, و `visits` في SharedPreferences (للتوافق مع الكود القديم)
- إضافة periodic refresh:
  - استخدام `Timer.periodic(Duration(seconds: 30), ...)` في `initState`
  - حفظ `Timer` في متغير instance
  - إلغاء Timer في `dispose()`
  - استدعاء `GetOccupancy` event كل 30 ثانية
- إزالة الاعتماد على SharedPreferences للـ occupancy data (لكن الاحتفاظ به كـ fallback للـ visits)

#### 6.2 `lib/features/main_window/presentation/widget/summary_details.dart`
- تحديث لاستخدام `BlocBuilder<GetOccupancyBloc, GetOccupancyState>`
- قراءة `onGround`, `visits`, `capacity` من Bloc state
- إضافة fallback للقيم الافتراضية في حالة Loading أو Error

#### 6.3 `lib/features/main_window/presentation/widget/pie_chart.dart`
- تحديث لاستخدام `BlocBuilder<GetOccupancyBloc, GetOccupancyState>`
- قراءة `capacity` و `visits` من Bloc state
- إضافة fallback للقيم الافتراضية في حالة Loading أو Error
- إزالة الاعتماد على SharedPreferences

#### 6.4 `lib/features/setting/presentation/view/settings_page.dart`
- إضافة `UpdateCapacityBloc` و `GetOccupancyBloc` providers في `MultiBlocProvider`
- تحديث `initState`:
  - استدعاء `GetOccupancy` event للحصول على القيمة الحالية من API
  - ملء `capacity` text field من Bloc state
- إضافة `BlocListener<GetOccupancyBloc>`:
  - `SuccessOccupancy`: تحديث `capacity.text` بالقيمة من API
- إضافة `BlocListener<UpdateCapacityBloc>`:
  - `SuccessCapacity`: 
    - عرض SnackBar بنجاح
    - تحديث `capacityNotifier.value`
    - إعادة استدعاء `GetOccupancy` event
  - `ErrorCapacity`: عرض SnackBar بالخطأ
  - `OfflineCapacity`: عرض SnackBar بالخطأ
  - `ForbiddenCapacity`: عرض SnackBar بالخطأ وإعادة توجيه للـ login
- تحديث `onSubmitted` للـ capacity text field:
  - استخدام `submitEditingDialog` (مشابه لـ hourly price)
  - استدعاء `UpdateCapacity` event مع القيمة المدخلة
  - التحقق من أن القيمة رقم صحيح قبل الإرسال

### 7. تحديث Services القديمة (اختياري - للتنظيف)
- `lib/features/home/data/source/remote/get_all_active_sessions_service.dart`
  - إزالة الحساب المحلي لـ `onGround` (السطر 25-28)
  - إزالة `prefs.setInt("onGround", onGround)` و `activeSessionsNotifier.value = onGround`
  - الاعتماد على `GetOccupancyBloc` بدلاً من ذلك

- `lib/features/premium_client/data/source/remote/start_premium_session_service.dart`
  - إزالة الحساب المحلي لـ `visits` (السطور 22-45)
  - الاعتماد على `GetOccupancyBloc` بدلاً من ذلك

### 8. تحديث Notifiers
- `lib/core/utils/task_notifier.dart`
  - لا حاجة لتغييرات (الـ notifiers موجودة بالفعل)
  - سيتم تحديثها من Bloc listeners

## خطوات التنفيذ بالترتيب

1. إنشاء `occupancy_response_model.dart` مع null safety كامل
2. إنشاء `update_capacity_response_model.dart` مع null safety كامل
3. إنشاء `get_occupancy_service.dart` مع `auth: false`
4. إنشاء `update_capacity_service.dart` مع `auth: true` و null checks
5. إنشاء `get_occupancy_repo.dart` مع error handling كامل
6. إنشاء `update_capacity_repo.dart` مع error handling كامل
7. إنشاء `get_occupancy_usecase.dart`
8. إنشاء `update_capacity_usecase.dart`
9. إنشاء `get_occupancy_bloc.dart` مع جميع states
10. إنشاء `update_capacity_bloc.dart` مع جميع states وتحديث notifiers
11. تحديث `summary.dart`: إضافة Bloc provider, listener, periodic refresh, و dispose
12. تحديث `summary_details.dart`: استخدام BlocBuilder
13. تحديث `pie_chart.dart`: استخدام BlocBuilder
14. تحديث `settings_page.dart`: إضافة Bloc providers, listeners, و submit dialog
15. (اختياري) تنظيف Services القديمة: إزالة الحساب المحلي

## ملاحظات مهمة جداً

### Authentication
- **GET occupancy**: لا يحتاج auth → استخدام `getOptions(auth: false)`
- **PUT capacity**: يحتاج auth → استخدام `getOptions(auth: true)`

### Null Safety
- جميع `fromMap` methods يجب أن تستخدم `as int? ?? defaultValue`
- جميع error handling يجب أن يتحقق من `e.response != null` قبل الوصول إلى `e.response!.data`

### Periodic Refresh
- استخدام `Timer.periodic` في `summary.dart`
- **مهم**: إلغاء Timer في `dispose()` لتجنب memory leaks
- الفترة المقترحة: 30 ثانية

### Error Handling
- `403 Forbidden` في update capacity: إعادة توجيه للـ login
- `Offline`: عرض رسالة مناسبة
- `ServerFailure`: عرض رسالة الخطأ

### Integration
- عند نجاح update capacity:
  1. تحديث `capacityNotifier.value = newCapacity`
  2. إعادة استدعاء `GetOccupancy` event للحصول على البيانات المحدثة
  3. عرض SnackBar بنجاح

### Backward Compatibility
- الاحتفاظ بقراءة `visits` من SharedPreferences كـ fallback (للتوافق مع الكود القديم)
- إزالة الاعتماد على SharedPreferences للـ `onGround` و `capacity` (الاعتماد على API فقط)

### Testing Checklist
- [ ] GET occupancy يعمل بدون auth
- [ ] PUT capacity يعمل مع auth
- [ ] PUT capacity يرفض بدون auth (403)
- [ ] PUT capacity يرفض مع ADMIN role (403)
- [ ] Periodic refresh يعمل كل 30 ثانية
- [ ] Timer يتم إلغاؤه في dispose
- [ ] Notifiers يتم تحديثها بشكل صحيح
- [ ] Settings page يقرأ القيمة الحالية من API
- [ ] Settings page يحدث capacity بنجاح
- [ ] Error states يتم عرضها بشكل صحيح
- [ ] Offline state يتم التعامل معه بشكل صحيح

## الأخطاء الشائعة التي يجب تجنبها

1. ❌ استخدام `auth: true` في GET occupancy
2. ❌ عدم معالجة null في `fromMap` methods
3. ❌ عدم إلغاء Timer في `dispose()`
4. ❌ عدم التحقق من `e.response != null` قبل الوصول إلى `e.response!.data`
5. ❌ عدم تحديث notifiers بعد نجاح update capacity
6. ❌ عدم إعادة استدعاء GetOccupancy بعد update capacity
7. ❌ عدم إضافة fallback values في BlocBuilder

