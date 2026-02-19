import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_detail_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/booking_list_entity.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/certificate_sub_type_entity.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_sub_providers/bookin_actions.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_sub_providers/booking_filters.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_sub_providers/booking_images.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_sub_providers/booking_timers.dart';

class BookingProvider extends BaseViewModel {
  DateTime provSelectedDate = DateTime.now();
  TimeOfDay? provSelectedTime;
  String? formattedTime;

  CertificateSubTypeEntity? provInspectionType;
  String? location;
  String? description;

  List<File> images = [];
  List<String> uploadedUrls = [];
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<String> existingImageUrls = [];
  String? currentBookingId;
  bool isProcessing = false;
  bool isLoadingBookingDetail = false;
  bool isLoading = false;
  bool isActionProcessing = false;
  bool isUpdatingBooking = false;
  BookingData? updatedBookingData;
  BookingDetailModel? bookingDetailModel;
  List<BookingData> bookings = [];
  Map<String, Duration> activeTimers = {};
  Map<String, bool> isTimerRunning = {};
  Map<String, bool> showUpFeeStatusMap = {};
  Timer? timer;
  int currentPage = 1;
  bool hasMoreBookings = true;
  bool isFetchingBookings = false;
  bool isLoadMoreRunning = false;
  bool isFilterLoading = false;
  DateTime get selectedDate => provSelectedDate;
  TimeOfDay? get selectedTime => provSelectedTime;
  CertificateSubTypeEntity? get inspectionType => provInspectionType;
  String? get getLocation => location;

  List<CertificateSubTypeEntity> subTypes = [];
  String? searchQuery;
  String? searchDate;
  String? status;
  String sortBy = 'createdAt';
  String sortOrder = 'desc';
  final int perPageLimit = 10;

  String? placeName,
      pincode,
      city,
      state,
      country,
      placeType,
      selectedLat,
      selectedLng,
      fullAddress;
  bool agreedToPolicies = false;

  final ImagePicker picker = ImagePicker();

  late final BookingImagesService imagesService;
  late final BookingTimerService timerService;
  late final BookingActionsService actionsService;
  late final BookingFiltersService filtersService;

  BookingProvider() {
    log("🔥 BookingProvider instance hash: $hashCode");
    imagesService = BookingImagesService(this);
    timerService = BookingTimerService(this);
    actionsService = BookingActionsService(this);
    filtersService = BookingFiltersService(this, timerService);
  }

  void onBookingAssigned({String? bookingId, dynamic inspectors}) async {
    log('Provider: booking assigned: \$bookingId');
    await updateBookingListUI();
  }

  void onRaiseInspectionUpdate(dynamic data) async {
    log('Provider: onRaiseInspectionUpdate: $data');
  }

  void onBookingStatusUpdated({
    dynamic status,
    String? bookingId,
    String? message,
  }) async {
    log(
      'Provider: onBookingStatusUpdated status=\$status bookingId=\$bookingId',
    );
    await updateBookingListUI();
    notifyListeners();
  }

  Future<void> updateBookingListUI() async {
    resetBookings();
    await fetchBookingsList(reset: true);

    notifyListeners();
  }

  void onBookingCompleted({String? bookingId, dynamic payload}) async {
    log('Provider: onBookingCompleted bookingId=\$bookingId');
    await updateBookingListUI();
  }

  Future<void> init() async {
    await fetchCertificateSubTypes();
    notifyListeners();
  }

  @override
  void dispose() {
    locationController.clear();
    descriptionController.clear();
    timerService.dispose();
    super.dispose();
  }

  void notify() {
    notifyListeners();
  }

  void setProcessing(bool value) {
    isProcessing = value;
    notifyListeners();
  }

  Future<void> fetchCertificateSubTypes() =>
      filtersService.fetchCertificateSubTypes();

  void setDate(DateTime d) => filtersService.setDate(d);

  void setTime(TimeOfDay t) => filtersService.setTime(t);

  void setInspectionType(CertificateSubTypeEntity? t) =>
      filtersService.setInspectionType(t);

  void setLocation(String? l) => filtersService.setLocation(l);

  void setDescription(String? v) => filtersService.setDescription(v);

  void setAgreePolicy(bool val) => filtersService.setAgreePolicy(val);

  void setAddressData(Map<String, dynamic> value) =>
      filtersService.setAddressData(value);

  bool validate({required BuildContext cntx}) =>
      filtersService.validate(cntx: cntx);

  Future<void> uploadImage(BuildContext context) =>
      imagesService.uploadImage(context);

  void removeImageAt(int idx) => imagesService.removeImageAt(idx);

  void removeExistingImageAt(int idx) =>
      imagesService.removeExistingImageAt(idx);

  Future<void> createBooking({required BuildContext context}) =>
      actionsService.createBooking(context: context);

  Future<void> updateBooking({
    required BuildContext context,
    required String bookingId,
  }) => actionsService.updateBooking(context: context, bookingId: bookingId);

  Future<void> deleteBookingDetail({
    required BuildContext context,
    required String bookingId,
  }) => actionsService.deleteBookingDetail(
    context: context,
    bookingId: bookingId,
  );

  Future<void> getBookingDetail({
    required BuildContext context,
    required String bookingId,
    required bool isEditable,
    required bool isInspectorView,
  }) => actionsService.getBookingDetail(
    context: context,
    bookingId: bookingId,
    isEditable: isEditable,
    isInspectorView: isInspectorView,
  );

  void clearBookingDetail() => actionsService.clearBookingDetail();

  void clearBookingData() => actionsService.clearBookingData();

  Future<void> fetchBookingsList({bool reset = false, bool loadMore = false}) =>
      filtersService.fetchBookingsList(reset: reset, loadMore: loadMore);

  void resetBookings() => filtersService.resetBookings();

  void searchBookings(String query) => filtersService.searchBookings(query);

  void searchBookingsByDate(String date) =>
      filtersService.searchBookingsByDate(date);

  Future<void> filterByStatus(String status) =>
      filtersService.filterByStatus(status);

  void sortBookingsByDate({bool ascending = true}) =>
      filtersService.sortBookingsByDate(ascending: ascending);

  void clearFilters({bool triggerFetch = false}) =>
      filtersService.clearFilters(triggerFetch: triggerFetch);

  List<BookingListEntity> getFilteredBookings(List<int> filterStatuses) =>
      filtersService.getFilteredBookings(filterStatuses);

  Future<void> startInspectionTimer({
    required BuildContext context,
    required String bookingId,
  }) =>
      timerService.startInspectionTimer(context: context, bookingId: bookingId);

  Future<void> pauseInspectionTimer({
    required BuildContext context,
    required String bookingId,
  }) =>
      timerService.pauseInspectionTimer(context: context, bookingId: bookingId);

  Future<void> stopInspectionTimer({
    required BuildContext context,
    required String bookingId,
  }) =>
      timerService.stopInspectionTimer(context: context, bookingId: bookingId);

  Future<void> updateBookingTimer({
    required BuildContext context,
    required String bookingId,
    required String action,
  }) => timerService.updateBookingTimer(
    context: context,
    bookingId: bookingId,
    action: action,
  );

  Duration calculateLiveDuration(BookingListEntity booking) =>
      timerService.calculateLiveDuration(booking);

  String formatDuration(Duration duration) =>
      timerService.formatDuration(duration);

  Future<void> updateBookingStatus({
    required BuildContext context,
    required String bookingId,
    required String userId,
    required int newStatus,
  }) => actionsService.updateBookingStatus(
    context: context,
    bookingId: bookingId,
    newStatus: newStatus,
    userId: userId,
  );

  Future<void> updateShowUpFeeStatus({
    required BuildContext context,
    required String bookingId,
    required String userId,

    required bool showUpFeeApplied,
  }) => actionsService.updateShowUpFeeStatus(
    context: context,
    bookingId: bookingId,
    showUpFeeApplied: showUpFeeApplied,
    userId: userId,
  );

  Future<void> approveAndPayBooking(
    BuildContext context,
    String bookingId,
    String userId,
    String inspectorId,
  ) => actionsService.approveAndPayBooking(
    context,
    bookingId,
    userId,
    inspectorId,
  );

  Future<void> disagreeBooking(
    BuildContext context,
    String bookingId,
    String userId,
  ) => actionsService.disagreeBooking(context, bookingId, userId);

  Future<void> declineBooking({
    required BuildContext context,
    required String bookingId,
    required String userId,
  }) => actionsService.declineBooking(
    context: context,
    bookingId: bookingId,
    userId: userId,
  );

  TimeOfDay parseTime(String str) => filtersService.parseTime(str);

  String formatTimeForApi(TimeOfDay t) => filtersService.formatTimeForApi(t);
}
