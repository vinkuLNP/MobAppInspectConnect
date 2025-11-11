import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@injectable
class ConnectivityCheckerHelper {
  Future<bool> checkConnectivity() async {
    final List<ConnectivityResult> result = await Connectivity().checkConnectivity();
print('Connectivity result: $result');

    return _handleResult(result);
  }

  static Stream<List<ConnectivityResult>> listenToConnectivityChanged() {
    return Connectivity().onConnectivityChanged;
  }

  bool _handleResult(List<ConnectivityResult> result) {
    return result.contains(ConnectivityResult.mobile) ||
           result.contains(ConnectivityResult.wifi )||
           result.contains(ConnectivityResult.ethernet);
  }
}
