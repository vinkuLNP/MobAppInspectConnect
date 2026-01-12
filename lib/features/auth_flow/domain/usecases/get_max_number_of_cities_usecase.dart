import 'package:equatable/equatable.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/usecases/base_params_usecase.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/settings_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/repositories/auth_repository.dart';

class SettingsParams extends Equatable {
  final String? type;
  const SettingsParams({required this.type});

  @override
  List<Object?> get props => [type];
}

class GetSettingsUseCase
    extends BaseParamsUseCase<SettingEntity, SettingsParams> {
  final AuthRepository _repo;
  GetSettingsUseCase(this._repo);

  @override
  Future<ApiResultModel<SettingEntity>> call(SettingsParams? p) =>
      _repo.getSettings(p!.type!);
}
