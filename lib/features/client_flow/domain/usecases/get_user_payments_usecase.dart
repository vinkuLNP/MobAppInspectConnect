import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/client_flow/data/models/user_payment_list_model.dart';
import 'package:inspect_connect/features/client_flow/domain/repositories/booking_repository.dart';

class GetUserPaymentsListParams extends Equatable {
  final int page;
  final int limit;
  final String? search;
  final String? sortBy;
  final String? sortOrder;

  const GetUserPaymentsListParams({
    required this.page,
    required this.limit,
    this.search,
    this.sortBy,
    this.sortOrder,
  });

  @override
  List<Object?> get props => [page, limit, search, sortBy, sortOrder,];
}

class GetUserPaymentsListUseCase extends BaseParamsUseCase<PaymentsBodyModel, GetUserPaymentsListParams> {
  final ClientUserRepository _repo;
  GetUserPaymentsListUseCase(this._repo);

  @override
  Future<ApiResultModel<PaymentsBodyModel>> call(GetUserPaymentsListParams? p) {
    return _repo.getUserPaymentList(
      page: p!.page,
      limit: p.limit,
      search: p.search,
      sortBy: p.sortBy,
      sortOrder: p.sortOrder,
    );
  }
}
