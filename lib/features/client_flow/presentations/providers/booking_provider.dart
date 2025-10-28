import 'dart:developer';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
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
import 'package:inspect_connect/features/client_flow/domain/usecases/upload_image_usecase.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/booking_edit_screen.dart';
import 'package:intl/intl.dart';

class BookingProvider extends BaseViewModel {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;
  String? _inspectionType;
  String? _location;
  String description = '';
  final List<File> images = [];
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  String? get inspectionType => _inspectionType;
  String? get location => _location;

  void setDate(DateTime d) {
    _selectedDate = DateTime(d.year, d.month, d.day);
    notifyListeners();
  }

  List<String> existingImageUrls = [];

  void removeExistingImageAt(int index) {
    existingImageUrls.removeAt(index);
    notifyListeners();
  }

  void setTime(TimeOfDay t) {
    _selectedTime = t;
    notifyListeners();
  }

  void setInspectionType(String? t) {
    _inspectionType = t;
    notifyListeners();
  }

  void setLocation(String? l) {
    _location = l;
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

  bool validate() {
    return _selectedDate != null &&
        _selectedTime != null &&
        _inspectionType != null &&
        _location != null &&
        description != '' &&
        images.isNotEmpty &&
        uploadedUrls.isNotEmpty &&
        images != [] &&
        uploadedUrls != [];
  }

  List<CertificateSubTypeEntity> subTypes = [];
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
    // if (!canVerify) return;
    try {
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.token == null) {
        throw Exception('User not found in local storage');
      }
      final booking = BookingEntity(
        bookingDate: _selectedDate.toIso8601String().split('T').first,
        bookingTime: '${_selectedTime!.hour}:${_selectedTime!.minute}',
        bookingLocation: _location!,
        certificateSubTypeId: _inspectionType!,
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
              content: Text(
                response.message.isNotEmpty
                    ? response.message
                    : 'Booking created successfully',
              ),
            ),
          );
          clearBookingData();
        },
        error: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Booking creation failed')),
          );
        },
      );
    } finally {
      // setSigningIn(false);
    }
  }


  Future<void> updateBooking({required BuildContext context, required String bookingId,}) async {
    // if (!canVerify) return;
    try {
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.token == null) {
        throw Exception('User not found in local storage');
      }
      final booking = BookingEntity(
        bookingDate: _selectedDate.toIso8601String().split('T').first,
        bookingTime: '${_selectedTime!.hour}:${_selectedTime!.minute}',
        bookingLocation: _location!,
        certificateSubTypeId: _inspectionType!,
        images: uploadedUrls,
        description: description,
      );
      final updateBookingDetailUseCase = locator<UpdateBookingDetailUseCase>();
      final state =
          await executeParamsUseCase<
            BookingDetailModel,
            UpdateBookingDetailParams
          >(
            useCase: updateBookingDetailUseCase,

            query: UpdateBookingDetailParams(bookingEntity: booking,bookingId: bookingId,),
            launchLoader: true,
          );

      state?.when(
        data: (response) async {
          clearBookingDetail();
          bookingDetailModel = response;
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text( 'Booking Updated successfully.')),
          );
          Navigator.pop(context);
          // clearBookingData();
        },
        error: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Booking creation failed')),
          );
        },
      );
    } finally {
      // setSigningIn(false);
    }
  }

  Future<void> getBookingDetail({
    required BuildContext context,
    required String bookingId,
  }) async {
    // if (!canVerify) return;
    try {
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.token == null) {
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
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookingEditScreen(booking: bookingDetailModel),
            ),
          );
        },
        error: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Fetching Booking Detail failed')),
          );
        },
      );
    } finally {
      // setSigningIn(false);
    }
  }

  Future<void> deleteBookingDetail({
    required BuildContext context,
    required String bookingId,
  }) async {
    // if (!canVerify) return;
    try {
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.token == null) {
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
            SnackBar(content: Text(e.message ?? 'Booking Deletion failed')),
          );
        },
      );
    } finally {
      // setSigningIn(false);
    }
  }

  void clearBookingDetail() {
    bookingDetailModel = null;
    notifyListeners();
  }

  Future<void> fetchCertificateSubTypes() async {
    try {
      final getSubTypesUseCase = locator<GetCertificateSubTypesUseCase>();
      final state =
          await executeParamsUseCase<
            List<CertificateSubTypeEntity>,
            GetCertificateSubTypesParams
          >(useCase: getSubTypesUseCase, launchLoader: true);

      state?.when(
        data: (response) {
          subTypes = response;
          notifyListeners();
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('Certificate types loaded successfully'),
          //   ),
          // );
        },
        error: (e) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(e.message ?? 'Failed to load certificate types'),
          //   ),
          // );
        },
      );
    } catch (e) {
      log('fetchCertificateSubTypes error: $e');
    }
  }

  Future<void> uploadImage(BuildContext context) async {
    try {
      if (images.length >= 5) return;
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked == null) return;

      final file = File(picked.path);
      // final allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
      // final extension = picked.name.split('.').last.toLowerCase();

      // if (!allowedExtensions.contains(extension)) {
      //   ScaffoldMessenger.of(
      //     context,
      //   ).showSnackBar(const SnackBar(content: Text('Invalid image type')));
      //   return;
      // }
      if (await file.length() > 1 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File must be under 1 MB')),
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
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(response.message.isNotEmpty ? response.message : 'Image uploaded successfully')),
          // );
        },
        error: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Image upload failed')),
          );
        },
      );
    } catch (e) {
      log('uploadImage error: $e');
    }
  }

  List<String> uploadedUrls = [];

  void clearBookingData() {
    log('🧹 Clearing booking data...');
    _selectedDate = DateTime.now();
    _selectedTime = null;
    _location = null;
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
  int _totalPages = 1;
  bool isFetchingBookings = false;
  bool hasMoreBookings = true;
  bool isLoadMoreRunning = false;

  // Reset bookings data
  void resetBookings() {
    bookings.clear();
    _currentPage = 1;
    _totalPages = 1;
    hasMoreBookings = true;
    notifyListeners();
  }

  final int _perPageLimit = 10;

  // Filters
  String? _searchQuery;
  String? _searchDate;
  String? _status;
  String _sortBy = 'createdAt';
  String _sortOrder = 'desc';

  /// Fetch initial or paginated booking list
  Future<void> fetchBookingsList({
    bool reset = false,
    bool loadMore = false,
  }) async {
    try {
      if (isFetchingBookings || isLoadMoreRunning) return;

      if (reset) {
        _currentPage = 1;
        hasMoreBookings = true;
        bookings = [];
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
        search: _searchDate ?? _searchQuery ?? '', // can be text or date
        sortBy: _sortBy,
        sortOrder: _sortOrder,
        // status: _status != null ? int.tryParse(_status!) ?? 0 : 0,
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
            log('------<response------->$response');
          } else {
            bookings = response;
            log('------<response------->$response');
          }

          if (response.length < _perPageLimit) {
            hasMoreBookings = false;
          } else {
            _currentPage++;
          }
        },
        error: (e) {
          log("Error fetching bookings: ${e.message}");
        },
      );
    } catch (e) {
      log("❌ fetchBookingsList error: $e");
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

  void filterByStatus(String? status) {
    log("🔍 Filtering by status: $status");
    if (_status == status) return;
    _status = status;
    _currentPage = 1;
    fetchBookingsList(reset: true);
  }

  void clearFilters() {
    _searchQuery = null;
    _searchDate = null;
    _status = null;
    _currentPage = 1;
    fetchBookingsList(reset: true);
  }

  /// ✅ Update booking (for Edit)
  // Future<void> updateBooking({
  //   required BuildContext context,
  //   required String bookingId,
  //   VoidCallback? onSuccess,
  // }) async {
  //   try {
  //     final data = {
  //       "bookingDate": selectedDate.toIso8601String(),
  //       "bookingTime": _formatTime(selectedTime!),
  //       "inspectionType": inspectionType,
  //       "location": locationController.text.trim(),
  //       "description": descriptionController.text.trim(),
  //     };

  //     // final res = await ApiClient.postMultipart(
  //     //   endpoint: "/api/v1/bookings/update/$bookingId",
  //     //   data: data,
  //     //   files: images,
  //     //   fileFieldName: "images",
  //     // );

  //     // if (res.success) {
  //     //   ScaffoldMessenger.of(context).showSnackBar(
  //     //     const SnackBar(content: Text('Booking updated successfully!')),
  //     //   );
  //     //   onSuccess?.call();
  //     // } else {
  //     //   _showError(context, res.message);
  //     // }
  //   } catch (e) {
  //     _showError(context, e.toString());
  //   }
  // }

  String _formatTime(TimeOfDay t) {
    final dt = DateTime(0, 0, 0, t.hour, t.minute);
    return DateFormat('HH:mm').format(dt);
  }

  TimeOfDay parseTime(String str) {
    try {
      final parts = str.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (_) {
      return const TimeOfDay(hour: 10, minute: 0);
    }
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
