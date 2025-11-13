import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_detail_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/upload_image_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/user_payment_list_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/wallet_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/upload_image_dto.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/booking_entity.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/certificate_sub_type_entity.dart';

abstract class ClientUserRepository {
 Future<ApiResultModel<List<CertificateSubTypeEntity>>>  getCertificateSubTypes();
  Future<ApiResultModel<UploadImageResponseModel>> uploadImage({required UploadImageDto filePath});
  Future<ApiResultModel<CreateBookingResponseModel>>  createBooking({required BookingEntity booking});
 Future<ApiResultModel<List<BookingData>>>  fetchBookings({
   required int page,
    required int perPageLimit,
    String? search,
    String? sortBy,
    String? sortOrder,
    int? status,
 });
 Future<ApiResultModel<PaymentsBodyModel>>  getUserPaymentList({
   required int page,
    required int limit,
    String? search,
    String? sortBy,
    String? sortOrder,
 });
 Future<ApiResultModel<WalletModel>>  getUserWalletAmount();

  Future<ApiResultModel<BookingDetailModel>> getBookingDetail(String bookingId);
Future<ApiResultModel<bool>> deleteBooking(String bookingId);
Future<ApiResultModel<BookingData>> updateBooking(String bookingId, BookingEntity booking);

Future<ApiResultModel<BookingData>> updateBookingStatus(String bookingId,int status);

Future<ApiResultModel<BookingData>> updateBookingTimer(String bookingId,String action);

}
