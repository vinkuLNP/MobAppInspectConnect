import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/client_flow/data/models/notification_model.dart';
import 'package:inspect_connect/features/client_flow/domain/repositories/booking_repository.dart';

class NotificationParams extends Equatable {
  final int page;
  final int perPageLimit;

  const NotificationParams({required this.page, required this.perPageLimit});

  @override
  List<Object?> get props => [page, perPageLimit];
}

class NotificationUseCase
    extends BaseParamsUseCase<List<NotificationModel>, NotificationParams> {
  final ClientUserRepository _repo;
  NotificationUseCase(this._repo);

  @override
  Future<ApiResultModel<List<NotificationModel>>> call(NotificationParams? p) {
    return _repo.getNotifications(page: p!.page, perPageLimit: p.perPageLimit);
  }
}
