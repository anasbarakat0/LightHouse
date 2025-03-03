import 'package:bloc/bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/buffet/domain/usecase/delete_product_usecase.dart';
import 'package:meta/meta.dart';

part 'delete_product_event.dart';
part 'delete_product_state.dart';

class DeleteProductBloc extends Bloc<DeleteProductEvent, DeleteProductState> {
  final DeleteProductUsecase deleteProductUsecase;
  DeleteProductBloc(this.deleteProductUsecase) : super(DeleteProductInitial()) {
    on<DeleteProduct>((event, emit) async {
      var data = await deleteProductUsecase.call(event.id);
      data.fold((failures) {switch (failures) {
          case ServerFailure():
            emit(ExceptionDeleteProduct(message: failures.message));
            break;
          case OfflineFailure():
            emit(ExceptionDeleteProduct(message: connectionMessage));
            break;
          case ForbiddenFailure():
            emit(ForbiddenDeleteProduct(message: failures.message));
            break;
          default:
          emit(LoadingDeleteProduct());
        }
      }, (response) {
        emit(ProductDeleted(response: response));
      });
    });
  }
}
