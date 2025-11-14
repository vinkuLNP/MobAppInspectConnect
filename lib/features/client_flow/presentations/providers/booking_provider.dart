import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_detail_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/upload_image_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/booking_entity.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/booking_list_entity.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/certificate_sub_type_entity.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/upload_image_dto.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/create_booking_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/delete_booking_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/fetch_booking_list_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/get_booking_Detail_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/get_certificate_subtype_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/update_booking_detail_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/update_booking_status.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/update_booking_timer.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/upload_image_usecase.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/wallet_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/booking_edit_screen.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/payment_screens/wallet_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BookingProvider extends BaseViewModel {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;
  String? formattedTime;

  CertificateSubTypeEntity? _inspectionType;
  String? location;
  String description = '';
  final List<File> images = [];
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  CertificateSubTypeEntity? get inspectionType => _inspectionType;
  String? get getLocation => location;
  bool isLoadingBookingDetail = false;

  void setDate(DateTime d) {
    _selectedDate = DateTime(d.year, d.month, d.day);
    notifyListeners();
  }

  void setTime(TimeOfDay t) {
    _selectedTime = t;
    formattedTime = formatTimeForApi(_selectedTime!);
    notifyListeners();
  }

  List<String> existingImageUrls = [];

  void removeExistingImageAt(int index) {
    existingImageUrls.removeAt(index);
    uploadedUrls.removeAt(index);
    notifyListeners();
  }

  bool isProcessing = false;

  void setProcessing(bool value) {
    isProcessing = value;
    notifyListeners();
  }

  bool isFilterLoading = false;
  bool isActionProcessing = false;

  void setInspectionType(CertificateSubTypeEntity? t) {
    _inspectionType = t;

    notifyListeners();
  }

  void setLocation(String? l) {
    location = l;
    if (locationController.text != l) {
      locationController.text = l ?? '';
    }
    notifyListeners();
  }

  void setDescription(String v) {
    description = v;
    if (descriptionController.text != v) {
      descriptionController.text = v;
    }
    notifyListeners();
  }

  final ImagePicker _picker = ImagePicker();

  void removeImageAt(int idx) {
    if (idx >= 0 && idx < images.length) {
      images.removeAt(idx);
      notifyListeners();
    }
  }

  bool validate({required BuildContext cntx}) {
    bool isValid = true;

    if (_selectedTime == null) {
      print("Please select a time");
      ScaffoldMessenger.of(cntx).showSnackBar(
        SnackBar(
          content: textWidget(
            text: 'Please select a time',
            color: AppColors.backgroundColor,
          ),
        ),
      );
      isValid = false;
    }

    if (_inspectionType == null) {
      ScaffoldMessenger.of(cntx).showSnackBar(
        SnackBar(
          content: textWidget(
            text: "Please select an inspection type",
            color: AppColors.backgroundColor,
          ),
        ),
      );
      isValid = false;
    }

    if (location == null) {
      ScaffoldMessenger.of(cntx).showSnackBar(
        SnackBar(
          content: textWidget(
            text: "Please select a location",
            color: AppColors.backgroundColor,
          ),
        ),
      );
      isValid = false;
    }

    if (description == '' || description.trim().isEmpty) {
      ScaffoldMessenger.of(cntx).showSnackBar(
        SnackBar(
          content: textWidget(
            text: "Please enter a description",
            color: AppColors.backgroundColor,
          ),
        ),
      );
      isValid = false;
    }

    if (uploadedUrls.isEmpty) {
      ScaffoldMessenger.of(cntx).showSnackBar(
        SnackBar(
          content: textWidget(
            text: "Please add at least one image",
            color: AppColors.backgroundColor,
          ),
        ),
      );
      isValid = false;
    }

    return isValid;
  }

  List<CertificateSubTypeEntity> subTypes = [];
  BookingData? updatedBookingData;
  BookingDetailModel? bookingDetailModel;

  bool isLoading = false;

  Future<void> init() async {
    isLoading = true;
    notifyListeners();
    fetchCertificateSubTypes();

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> createBooking({required BuildContext context}) async {
    try {
      setProcessing(true);
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.authToken == null) {
        throw Exception('User not found in local storage');
      }
      final booking = BookingEntity(
        bookingDate: _selectedDate.toIso8601String().split('T').first,
        bookingTime: formattedTime!,
        bookingLocation: location!,
        certificateSubTypeId: _inspectionType!.id,
        images: uploadedUrls,
        description: description,
      );
      final createBookingUseCase = locator<CreateBookingUseCase>();
      final state =
          await executeParamsUseCase<
            CreateBookingResponseModel,
            CreateBookingParams
          >(
            useCase: createBookingUseCase,

            query: CreateBookingParams(bookingEntity: booking),
            launchLoader: true,
          );

      state?.when(
        data: (response) async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:   textWidget(text: 
                response.message.isNotEmpty
                    ? response.message
                    : 'Booking created successfully',color: AppColors.backgroundColor,
              ),
            ),
          );
          clearBookingData();
        },
        error: (e) {
          // if (e.message!.toLowerCase().contains("insufficient")) {
          //   _showInsufficientFundsDialog(context, e.message!);
          // } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content:   textWidget(text: e.message ?? 'Booking creation failed',color: AppColors.backgroundColor,)),
          );
          // }
        },
      );
    } finally {
      setProcessing(false);
    }
  }

  Future<void> updateBooking({
    required BuildContext context,
    required String bookingId,
  }) async {
    try {
      setProcessing(true);
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.authToken == null) {
        throw Exception('User not found in local storage');
      }
      final booking = BookingEntity(
        bookingDate: _selectedDate.toIso8601String().split('T').first,
        bookingTime: formattedTime!,
        bookingLocation: location!,
        certificateSubTypeId: _inspectionType!.id,
        images: uploadedUrls,
        description: description,
      );

      final updateBookingDetailUseCase = locator<UpdateBookingDetailUseCase>();
      final state =
          await executeParamsUseCase<BookingData, UpdateBookingDetailParams>(
            useCase: updateBookingDetailUseCase,

            query: UpdateBookingDetailParams(
              bookingEntity: booking,
              bookingId: bookingId,
            ),
            launchLoader: true,
          );

      state?.when(
        data: (response) async {
          clearBookingDetail();
          updatedBookingData = response;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content:   textWidget(text: 'Booking Updated successfully.',color: AppColors.backgroundColor,)),
          );
          Navigator.pop(context, true);
          clearFilters();
        },
        error: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content:   textWidget(text: e.message ?? 'Booking creation failed',color: AppColors.backgroundColor,)),
          );
        },
      );
    } finally {
      setProcessing(false);
    }
  }

  Future<void> getBookingDetail({
    required BuildContext context,
    required String bookingId,
    required bool isEditable,
  }) async {
    try {
      isLoadingBookingDetail = true;
      notifyListeners();
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.authToken == null) {
        throw Exception('User not found in local storage');
      }

      final getBookingDetailUseCase = locator<GetBookingDetailUseCase>();
      final state =
          await executeParamsUseCase<
            BookingDetailModel,
            GetBookingDetailParams
          >(
            useCase: getBookingDetailUseCase,

            query: GetBookingDetailParams(bookingId: bookingId),
            launchLoader: true,
          );

      state?.when(
        data: (response) async {
          clearBookingDetail();
          bookingDetailModel = response;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookingEditScreen(
                booking: bookingDetailModel,
                isEdiatble: isEditable,
                isReadOnly: !isEditable,
              ),
            ),
          ).then((result) {
            if (result == true) {
              fetchBookingsList(reset: true);
            }
          });
        },
        error: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:   textWidget(text: e.message ?? 'Fetching Booking Detail failed',color: AppColors.backgroundColor,),
            ),
          );
        },
      );
    } finally {
      isLoadingBookingDetail = false;
      notifyListeners();
    }
  }

  Future<void> deleteBookingDetail({
    required BuildContext context,
    required String bookingId,
  }) async {
    try {
      setProcessing(true);
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.authToken == null) {
        throw Exception('User not found in local storage');
      }

      final deleteBookingUseCase = locator<DeleteBookingDetailUseCase>();
      final state = await executeParamsUseCase<bool, DeleteBookingDetailParams>(
        useCase: deleteBookingUseCase,

        query: DeleteBookingDetailParams(bookingId: bookingId),
        launchLoader: true,
      );

      state?.when(
        data: (response) async {
          clearBookingDetail();
          Navigator.pop(context);
          fetchBookingsList();
        },
        error: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content:   textWidget(text: e.message ?? 'Booking Deletion failed',color: AppColors.backgroundColor,)),
          );
        },
      );
    } finally {
      setProcessing(false);
    }
  }

  void clearBookingDetail() {
    bookingDetailModel = null;
    notifyListeners();
  }

  Future<void> fetchCertificateSubTypes() async {
    try {
      setProcessing(true);
      final getSubTypesUseCase = locator<GetCertificateSubTypesUseCase>();
      final state =
          await executeParamsUseCase<
            List<CertificateSubTypeEntity>,
            GetCertificateSubTypesParams
          >(useCase: getSubTypesUseCase, launchLoader: true);

      state?.when(
        data: (response) {
          subTypes = response;
          setInspectionType(subTypes[0]);
          notifyListeners();
        },
        error: (e) {},
      );
    } catch (e) {
    } finally {
      setProcessing(false);
    }
  }

  Future<void> uploadImage(BuildContext context) async {
    try {
      if (images.length >= 5) return;
      setProcessing(true);
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked == null) return;

      final file = File(picked.path);
      if (await file.length() > 1 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content:   textWidget(text: 'File must be under 1 MB',color: AppColors.backgroundColor,)),
        );
        return;
      }

      final uploadImage = UploadImageDto(filePath: file.path);
      final uploadImageUseCase = locator<UploadImageUseCase>();
      final result =
          await executeParamsUseCase<
            UploadImageResponseModel,
            UploadImageParams
          >(
            useCase: uploadImageUseCase,
            query: UploadImageParams(filePath: uploadImage),
            launchLoader: true,
          );

      result?.when(
        data: (response) {
          uploadedUrls.add(response.fileUrl);
          images.add(file);
          notifyListeners();
        },
        error: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content:   textWidget(text: e.message ?? 'Image upload failed',color: AppColors.backgroundColor,)),
          );
        },
      );
    } catch (e) {
    } finally {
      setProcessing(false);
    }
  }

  List<String> uploadedUrls = [];

  void clearBookingData() {
    _selectedDate = DateTime.now();
    _selectedTime = null;
    formattedTime = null;
    location = null;
    _inspectionType = null;
    description = '';
    uploadedUrls.clear();
    images.clear();
    locationController.clear();
    descriptionController.clear();

    notifyListeners();
  }

  List<BookingListEntity> bookings = [];

  int _currentPage = 1;
  bool isFetchingBookings = false;
  bool hasMoreBookings = true;
  bool isLoadMoreRunning = false;

  void resetBookings() {
    bookings.clear();
    _currentPage = 1;
    hasMoreBookings = true;
    notifyListeners();
  }

  final int _perPageLimit = 10;

  String? _searchQuery;
  String? _searchDate;
  String? _status;
  String _sortBy = 'createdAt';
  String _sortOrder = 'desc';

  Future<void> fetchBookingsList({
    bool reset = false,
    bool loadMore = false,
  }) async {
    try {
      if (isFetchingBookings || isLoadMoreRunning) return;

      if (reset) {
        _currentPage = 1;
        if (bookings.isEmpty) {
          isFetchingBookings = true;
        }
        notifyListeners();
      }

      if (!loadMore) {
        isFetchingBookings = true;
      } else {
        isLoadMoreRunning = true;
      }
      notifyListeners();

      final fetchBookingUsecase = locator<FetchBookingsUseCase>();

      final params = FetchBookingsParams(
        page: _currentPage,
        perPageLimit: _perPageLimit,
        search: _searchDate ?? _searchQuery ?? '',
        sortBy: _sortBy,
        sortOrder: _sortOrder,
        status: _status != null && _status!.isNotEmpty
            ? int.tryParse(_status!)
            : null,
      );

      final state =
          await executeParamsUseCase<
            List<BookingListEntity>,
            FetchBookingsParams
          >(useCase: fetchBookingUsecase, query: params, launchLoader: false);

      state?.when(
        data: (response) {
          if (loadMore) {
            bookings.addAll(response);
          } else {
            bookings = response;
          }
          for (var booking in bookings) {
            final liveDuration = calculateLiveDuration(booking);
            activeTimers[booking.id] = liveDuration;

            isTimerRunning[booking.id] = booking.status == bookingStatusStarted;
          }

          if (response.length < _perPageLimit) {
            hasMoreBookings = false;
          } else {
            _currentPage++;
          }
          notifyListeners();
        },
        error: (e) {},
      );
    } catch (e) {
    } finally {
      isFetchingBookings = false;
      isLoadMoreRunning = false;
      notifyListeners();
    }
  }

  void searchBookings(String query) {
    _searchQuery = query.trim().isEmpty ? null : query.trim();
    _searchDate = null;
    _currentPage = 1;
    fetchBookingsList(reset: true);
  }

  void searchBookingsByDate(String date) {
    _searchDate = date;
    _searchQuery = null;
    _currentPage = 1;
    fetchBookingsList(reset: true);
  }

  Future<void> filterByStatus(String status) async {
    if (_status == "status") return;
    _status = status;
    _currentPage = 1;
    try {
      isFilterLoading = true;
      bookings.clear();
      notifyListeners();

      await fetchBookingsList(reset: true);
    } finally {
      isFilterLoading = false;
      notifyListeners();
    }
  }

  void sortBookingsByDate({bool ascending = true}) {
    bookings.sort((a, b) {
      final dateA = DateTime.parse(a.bookingDate);
      final dateB = DateTime.parse(b.bookingDate);
      return ascending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });
    notifyListeners();
  }

  void clearFilters({bool triggerFetch = false}) {
    _searchQuery = null;
    _searchDate = null;
    _status = null;
    _currentPage = 1;
    hasMoreBookings = true;
    bookings.clear();
    notifyListeners();

    if (triggerFetch) {
      fetchBookingsList(reset: true);
    }
  }

  TimeOfDay parseTime(String str) {
    try {
      final normalized = str.trim().toUpperCase().replaceAll('.', '');

      if (normalized.contains('AM') || normalized.contains('PM')) {
        final dt = DateFormat('h:mm a').parse(normalized);
        return TimeOfDay(hour: dt.hour, minute: dt.minute);
      }

      final dt = DateFormat('HH:mm').parse(normalized);
      return TimeOfDay(hour: dt.hour, minute: dt.minute);
    } catch (e) {
      return const TimeOfDay(hour: 10, minute: 0);
    }
  }

  String formatTimeForApi(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void showInsufficientFundsDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title:    textWidget(text: 
            'Insufficient Funds',
        fontWeight: FontWeight.bold),
        
          content:   textWidget(text: 
            '$message\n\nYou don’t have sufficient funds in your wallet. Please recharge now to continue.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:    textWidget(text: 'Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.themeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider(
                      create: (_) => WalletProvider(),
                      child: const WalletScreen(),
                    ),
                  ),
                );
              },
              child:    textWidget(text: 'Recharge Now'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateBookingStatus({
    required BuildContext context,
    required String bookingId,
    required int newStatus,
  }) async {
    try {
      isUpdatingBooking = true;
      notifyListeners();
      final updateBookingStatusUseCase = locator<UpdateBookingStatusUseCase>();
      final state =
          await executeParamsUseCase<BookingData, UpdateBookingStatusParams>(
            useCase: updateBookingStatusUseCase,

            query: UpdateBookingStatusParams(
              status: newStatus,
              bookingId: bookingId,
            ),
            launchLoader: true,
          );

      state?.when(
        data: (response) async {
          updatedBookingData = response;
          final index = bookings.indexWhere((b) => b.id == bookingId);
          if (index != -1) {
            bookings[index] = updatedBookingData!;
          }

          notifyListeners();
        },
        error: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content:   textWidget(text: e.message ?? 'Booking creation failed',color: AppColors.backgroundColor,)),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content:   textWidget(text: 'Failed: $e',color: AppColors.backgroundColor,)));
    } finally {
      isUpdatingBooking = false;
      notifyListeners();
    }
  }

  Map<String, Duration> activeTimers = {};
  Map<String, bool> isTimerRunning = {};
  Timer? _timer;

  Future<void> startInspectionTimer({
    required BuildContext context,
    required String bookingId,
  }) async {
    await updateBookingTimer(
      context: context,
      bookingId: bookingId,
      action: "start",
    );

    final previousSeconds =
        updatedBookingData?.timerDuration ??
        activeTimers[bookingId]?.inSeconds ??
        0;

    activeTimers[bookingId] = Duration(seconds: previousSeconds);
    isTimerRunning[bookingId] = true;
    _startLocalTimer(bookingId);
    notifyListeners();
  }

  void _startLocalTimer(String _) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      for (final id in isTimerRunning.keys) {
        if (isTimerRunning[id] == true) {
          final current = activeTimers[id] ?? Duration.zero;
          activeTimers[id] = current + const Duration(seconds: 1);
        }
      }
      notifyListeners();
    });
  }

  Future<void> pauseInspectionTimer({
    required BuildContext context,
    required String bookingId,
  }) async {
    await updateBookingTimer(
      context: context,
      bookingId: bookingId,
      action: "pause",
    );

    isTimerRunning[bookingId] = false;
    notifyListeners();
  }

  Future<void> stopInspectionTimer({
    required BuildContext context,
    required String bookingId,
  }) async {
    await updateBookingTimer(
      context: context,
      bookingId: bookingId,
      action: "stop",
    );

    isTimerRunning[bookingId] = false;
    _timer?.cancel();
    notifyListeners();
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  bool isUpdatingBooking = false;

  Future<void> updateBookingTimer({
    required BuildContext context,
    required String bookingId,
    required String action,
  }) async {
    try {
      isUpdatingBooking = true;
      notifyListeners();
      final updateBookingTimerUseCase = locator<UpdateBookingTimerUseCase>();
      final state =
          await executeParamsUseCase<BookingData, UpdateBookingTimerParams>(
            useCase: updateBookingTimerUseCase,

            query: UpdateBookingTimerParams(
              action: action,
              bookingId: bookingId,
            ),
            launchLoader: false,
          );

      state?.when(
        data: (response) async {
          updatedBookingData = response;
          final index = bookings.indexWhere((b) => b.id == bookingId);
          if (index != -1) {
            bookings[index] = updatedBookingData!;
          }
          notifyListeners();
        },
        error: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content:   textWidget(text: e.message ?? 'Booking creation failed',color: AppColors.backgroundColor,)),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content:   textWidget(text: 'Failed: $e',color: AppColors.backgroundColor,)));
    } finally {
      isUpdatingBooking = false;
      notifyListeners();
    }
  }

  Duration calculateLiveDuration(BookingListEntity booking) {
    try {
      if (booking.status == bookingStatusStarted ||
          booking.status == bookingStatusStarted) {
        final startedAt = DateTime.tryParse(booking.timerStartedAt ?? "");
        if (startedAt != null) {
          final now = DateTime.now().toUtc();
          final baseSeconds = booking.timerDuration ?? 0;
          final liveElapsed = now.difference(startedAt).inSeconds;
          return Duration(seconds: baseSeconds + liveElapsed);
        }
      }
      return Duration(seconds: booking.timerDuration ?? 0);
    } catch (e) {
      return Duration.zero;
    }
  }

  Future<void> approveAndPayBooking(
    BuildContext context,
    String bookingId,
  ) async {
    try {
      isActionProcessing = true;
      notifyListeners();
      await updateBookingStatus(
        context: context,
        bookingId: bookingId,
        newStatus: bookingStatusCompleted,
      );
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content:   textWidget(text: "Payment successful and booking approved.",color: AppColors.backgroundColor,),
        ),
      );
      fetchBookingsList(reset: true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content:   textWidget(text: "Error: $e",color: AppColors.backgroundColor,)));
    } finally {
      isActionProcessing = false;
      notifyListeners();
    }
  }

  Future<void> disagreeBooking(BuildContext context, String bookingId) async {
    try {
      isActionProcessing = true;
      notifyListeners();
      await updateBookingStatus(
        context: context,
        bookingId: bookingId,
        newStatus: bookingStatusStoppped,
      );
      fetchBookingsList(reset: true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content:   textWidget(text: "Error: $e",color: AppColors.backgroundColor,)));
    } finally {
      isActionProcessing = false;
      notifyListeners();
    }
  }

  Future<void> declineBooking({
    required BuildContext context,
    required String bookingId,
  }) async {
    try {
      isUpdatingBooking = true;
      notifyListeners();
      isActionProcessing = true;
      notifyListeners();
      await updateBookingStatus(
        context: context,
        bookingId: bookingId,
        newStatus: bookingStatusCancelledByInspector,
      );
      await fetchBookingsList(reset: true);
    } finally {
      isUpdatingBooking = false;
      notifyListeners();
    }
  }
}
