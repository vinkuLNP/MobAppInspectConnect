// import 'package:clean_architecture/features/auth_flow/data/datasources/local_datasources/local_database.dart';
// import 'package:injectable/injectable.dart';


// @module
// abstract class AppModule {
//   @preResolve
//   Future<AppLocalDatabase> get prefs => AppLocalDatabase.create();
// }
import 'package:clean_architecture/core/utils/helpers/connectivity_helper/connectivity_helper/connectivity_checker_helper.dart';
import 'package:clean_architecture/core/utils/helpers/http_strategy_helper/http_request_context.dart';
import 'package:clean_architecture/features/auth_flow/data/datasources/auth_remote_datasource.dart';
import 'package:clean_architecture/features/auth_flow/data/repositories/auth_repository_impl.dart';
import 'package:clean_architecture/features/auth_flow/domain/usecases/sign_in_usecase.dart';
import 'package:clean_architecture/features/auth_flow/presentation/client/client_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> appProviders() {
  final connectivity = ConnectivityCheckerHelper();
  final httpCtx = HttpRequestContext(connectivity);

  final remote = AuthRemoteDataSourceImpl(httpCtx);
  final repo   = AuthRepositoryImpl(remote);
  final signIn = SignInUseCase(repo);

  return [
    ChangeNotifierProvider(create: (_) => ClientViewModelProvider()),
  ];
}