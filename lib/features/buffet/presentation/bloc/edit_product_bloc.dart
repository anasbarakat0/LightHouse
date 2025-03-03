import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/buffet/data/models/product_model.dart';
import 'package:lighthouse/features/buffet/domain/usecase/edit_product_usecase.dart';
import 'package:meta/meta.dart';

part 'edit_product_event.dart';
part 'edit_product_state.dart';

class EditProductBloc extends Bloc<EditProductEvent, EditProductState> {
  final EditProductUsecase editProductUsecase;
  EditProductBloc(this.editProductUsecase) : super(EditProductInitial()){
    on<EditProduct>((event, emit) async {
      var data = await editProductUsecase.call(event.product, event.id);
      data.fold((failures) {switch (failures) {
          case ServerFailure():
            emit(ExceptionEditProduct(message: failures.message));
            break;
          case OfflineFailure():
            emit(ExceptionEditProduct(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenEditProduct(message: failures.message));
            break;
          default:
          emit(LoadingEditProduct());
        }
      }, (response) {
        emit(ProductEdited(response: response));
      });
    });
  }
}
