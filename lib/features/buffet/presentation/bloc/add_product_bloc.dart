import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/buffet/data/models/product_model.dart';
import 'package:lighthouse/features/buffet/domain/usecase/add_product_usecase.dart';
import 'package:meta/meta.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final AddProductUsecase addProductUsecase;
  AddProductBloc(this.addProductUsecase) : super(AddProductInitial()) {
    on<AddProduct>((event, emit) async {
      var data = await addProductUsecase.call(event.product);
       data.fold((failures) {
        switch (failures) {
          case ServerFailure():
            emit(ExceptionAddProduct(message: failures.message));
            break;
          case OfflineFailure():
            emit(ExceptionAddProduct(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenAddProduct(message: failures.message));
            break;
          default:
          emit(LoadingAddProduct());
        }
      }, (response) {
        emit(ProductAdded(response: response));
      });
    });
  }
}
