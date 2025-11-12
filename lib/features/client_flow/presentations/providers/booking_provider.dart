import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
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

  void setTime(TimeOfDay t) {
    _selectedTime = t;
    formattedTime = formatTimeForApi(_selectedTime!);
    notifyListeners();
  }

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
            text:"Please select an inspection type",
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
            text:"Please select a location",
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
            text:"Please enter a description",
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
            text:"Please add at least one image",
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
          if (e.message!.toLowerCase().contains("insufficient")) {
       
            _showInsufficientFundsDialog(context, e.message!);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message ?? 'Booking creation failed')),
            );
          }
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
            SnackBar(content: Text('Booking Updated successfully.')),
          );
          Navigator.pop(context, true);
          clearFilters();
          // clearBookingData();
        },
        error: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Booking creation failed')),
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

          // Navigator.pop(context);
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
              content: Text(e.message ?? 'Fetching Booking Detail failed'),
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
            SnackBar(content: Text(e.message ?? 'Booking Deletion failed')),
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
        },
        error: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Image upload failed')),
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

        isFetchingBookings = true;
        // _bookings = [];
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

  void filterByStatus(String? status) {
    if (_status == "status") return;
    _status = status;
    _currentPage = 1;
    fetchBookingsList(reset: true);
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

  void _showInsufficientFundsDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Insufficient Funds',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            '$message\n\nYou don’t have sufficient funds in your wallet. Please recharge now to continue.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.themeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider(
                      create: (_) => WalletProvider(),
                      child: const WalletScreen(),
                    ),
                    // WalletScreen(
                    //                     // minAmount: 50,
                    //                     // maxAmount: 5000,
                    //                   ),
                  ),
                );
              },
              child: const Text('Recharge Now'),
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
  String? rejectionReason,
}) async {
  try {
    isLoadingBookingDetail = true;
    notifyListeners();

    // final response = await apiService.updateBookingStatus(
    //   bookingId: bookingId,
    //   status: newStatus,
    //   reason: rejectionReason,
    // );

    // if (response.success) {
    //   // Update local list
    //   final index = bookings.indexWhere((b) => b.id == bookingId);
    //   if (index != -1) {
    //     bookings[index] = bookings[index].copyWith(status: newStatus);
    //   }
    //   notifyListeners();

    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(
    //         newStatus == 1
    //             ? 'Booking accepted successfully'
    //             : 'Booking rejected',
    //       ),
    //     ),
    //   );
    // }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed: $e')),
    );
  } finally {
    isLoadingBookingDetail = false;
    notifyListeners();
  }
}

}
