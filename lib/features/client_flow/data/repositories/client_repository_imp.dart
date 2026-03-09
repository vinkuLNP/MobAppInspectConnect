import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/features/client_flow/data/datasources/remote_datasource/client_api_datasource.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_detail_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/notification_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/upload_image_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/user_payment_list_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/wallet_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/withdraw_response_model.dart';
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
  Future<ApiResultModel<WalletModel>> getUserWalletAmount() {
    return remote.getUserWalletAmount();
  }

  @override
  Future<ApiResultModel<UploadImageResponseModel>> uploadImage({
    required UploadImageDto uploadImageDto,
  }) {
    return remote.uploadImage(uploadImageDto);
  }

  @override
  Future<ApiResultModel<WithdrawMoneyModel>> withdrawMoney({
    required int amount,
  }) {
    return remote.withdrawMoney(amount);
  }

  @override
  Future<ApiResultModel<String>> onBoardingUser() {
    return remote.onBoardingUser();
  }

  @override
  Future<ApiResultModel<CreateBookingResponseModel>> createBooking({
    required BookingEntity booking,
  }) async {
    return remote.createBooking(booking);
  }

  @override
  Future<ApiResultModel<List<BookingData>>> fetchBookings({
    required int page,
    required int perPageLimit,
    String? search,
    String? sortBy,
    String? sortOrder,
    int? status,
    int? type
  }) {
    return remote.getBookingList(
      page: page,
      perPageLimit: perPageLimit,
      search: search,
      sortBy: sortBy,
      sortOrder: sortOrder,
      status: status,
      type: type,
    );
  }

  @override
  Future<ApiResultModel<List<NotificationModel>>> getNotifications({
    required int page,
    required int perPageLimit,
  }) {
    return remote.getNotifications(page: page, perPageLimit: perPageLimit);
  }

  @override
  Future<ApiResultModel<PaymentsBodyModel>> getUserPaymentList({
    required int page,
    required int limit,
    String? search,
    String? sortBy,
    String? sortOrder,
    int? status,
  }) {
    return remote.getUserPaymentList(
      page: page,
      limit: limit,
      search: search,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }

  @override
  Future<ApiResultModel<BookingDetailModel>> getBookingDetail(
    String bookingId,
  ) {
    return remote.getBookingDetail(bookingId);
  }

  @override
  Future<ApiResultModel<bool>> deleteBooking(String bookingId) {
    return remote.deleteBooking(bookingId);
  }

  @override
  Future<ApiResultModel<BookingData>> updateBooking(
    String bookingId,
    BookingEntity booking,
  ) {
    return remote.updateBooking(bookingId, booking);
  }

  @override
  Future<ApiResultModel<String>> deductTransferWallet(
    String bookingId,
    String transferToId,
  ) {
    return remote.deductTransferWallet(bookingId, transferToId);
  }

  @override
  Future<ApiResultModel<BookingData>> updateBookingStatus(
    String bookingId,
    int status,
  ) {
    return remote.updateBookingStatus(bookingId, status);
  }

  @override
  Future<ApiResultModel<BookingData>> showUpFeeStatus(
    String bookingId,
    bool status,
  ) {
    return remote.showUpFeeStatus(bookingId, status);
  }

  @override
  Future<ApiResultModel<BookingData>> lateCancellation(
    String bookingId,
    int status,
    String clientId,
    bool lateCancellation,
  ) {
    return remote.lateCancellation(
      bookingId,
      status,
      clientId,
      lateCancellation,
    );
  }

  @override
  Future<ApiResultModel<BookingData>> updateBookingTimer(
    String bookingId,
    String action,
  ) {
    return remote.updateBookingTimer(bookingId, action);
  }
}
