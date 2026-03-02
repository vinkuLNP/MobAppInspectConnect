import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/features/client_flow/data/models/notification_model.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/notification_use_case.dart';

class NotificationProvider extends BaseViewModel {
  final List<NotificationModel> notifications = [];
  bool isLoading = false;
  int page = 1;
  int pagePerLimit = 10;

  bool hasMore = true;
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  Future<void> fetchNotifications({bool refresh = false}) async {
    if (isLoading || (!hasMore && !refresh)) return;

    if (refresh) {
      page = 1;
      notifications.clear();
      hasMore = true;
    }

    isLoading = true;
    notifyListeners();

    final useCase = locator<NotificationUseCase>();
    final result =
        await executeParamsUseCase<List<NotificationModel>, NotificationParams>(
          useCase: useCase,
          query: NotificationParams(page: page, perPageLimit: pagePerLimit),
          launchLoader: false,
        );

    result?.when(
      data: (data) {
        notifications.addAll(data);
        hasMore = data.isNotEmpty;
        page++;
      },
      error: (_) {},
    );

    isLoading = false;
    notifyListeners();
  }
}
