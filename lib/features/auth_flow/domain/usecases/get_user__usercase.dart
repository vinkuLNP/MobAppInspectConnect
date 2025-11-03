import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_detail.dart';
import 'package:inspect_connect/features/auth_flow/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class GetUserParams extends Equatable {
  final String userId;


  const GetUserParams({
    required this.userId,
  });

  @override
  List<Object?> get props => [ userId,];
}

class GetUserUseCase extends BaseParamsUseCase<UserDetail, GetUserParams> {
  final AuthRepository _repo;
  GetUserUseCase(this._repo);

  @override
  Future<ApiResultModel<UserDetail>> call(GetUserParams? p) => _repo.fetchUserDetail(
        userId: p!.userId,
      );
}
