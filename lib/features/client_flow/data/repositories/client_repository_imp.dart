import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/features/client_flow/data/datasources/remote_datasource/client_api_datasource.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/upload_image_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/upload_image_dto.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/booking_entity.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/certificate_sub_type_entity.dart';
import 'package:inspect_connect/features/client_flow/domain/repositories/booking_repository.dart';

class ClientUserRepositoryImpl implements ClientUserRepository {
  final BookingRemoteDataSource remote;

  ClientUserRepositoryImpl(this.remote);

  @override
  Future<ApiResultModel<List<CertificateSubTypeEntity>>>
  getCertificateSubTypes() {
    return remote.getCertificateSubTypes();
  }

  @override
  Future<ApiResultModel<UploadImageResponseModel>> uploadImage({
    required UploadImageDto filePath,
  }) {
    return remote.uploadImage(filePath);
  }

  @override
  Future<ApiResultModel<CreateBookingResponseModel>> createBooking({
    required BookingEntity booking,
  }) async {
    return remote.createBooking( booking);
  }
}
