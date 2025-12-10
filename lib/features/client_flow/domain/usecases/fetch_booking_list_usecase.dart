import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_model.dart';
import 'package:inspect_connect/features/client_flow/domain/repositories/booking_repository.dart';

class FetchBookingsParams extends Equatable {
  final int page;
  final int perPageLimit;
  final String? search;
  final String? sortBy;
  final String? sortOrder;
  final int? status;

  const FetchBookingsParams({
    required this.page,
    required this.perPageLimit,
    this.search,
    this.sortBy,
    this.sortOrder,
    this.status,
  });

  @override
  List<Object?> get props => [page, perPageLimit, search, sortBy, sortOrder, status];
}

class FetchBookingsUseCase extends BaseParamsUseCase<List<BookingData>, FetchBookingsParams> {
  final ClientUserRepository _repo;
  FetchBookingsUseCase(this._repo);

  @override
  Future<ApiResultModel<List<BookingData>>> call(FetchBookingsParams? p) {
    return _repo.fetchBookings(
      page: p!.page,
      perPageLimit: p.perPageLimit,
      search: p.search,
      sortBy: p.sortBy,
      sortOrder: p.sortOrder,
      status: p.status,
    );
  }
}
