import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/upload_image_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/booking_entity.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/certificate_sub_type_entity.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/upload_image_dto.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/create_booking_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/get_certificate_subtype_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/upload_image_usecase.dart';

class BookingProvider extends BaseViewModel {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;
  String? _inspectionType;
  String? _location;
  String description = '';
  final List<File> images = [];

  DateTime get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  String? get inspectionType => _inspectionType;
  String? get location => _location;

  void setDate(DateTime d) {
    _selectedDate = DateTime(d.year, d.month, d.day);
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
    notifyListeners();
  }

  void setDescription(String v) {
    description = v;
    notifyListeners();
  }

  final ImagePicker _picker = ImagePicker();

  //   Future<void> addImage() async {
  //   if (images.length >= 5) return;

  //   final XFile? picked = await _picker.pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 80,
  //   );

  //   if (picked == null) return;

  //   final file = File(picked.path);

  //   final allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
  //   final extension = picked.name.split('.').last.toLowerCase();

  //   if (!allowedExtensions.contains(extension)) {
  //     debugPrint('❌ Invalid file type: .$extension');
  //     return;
  //   }

  //   final int fileSize = await file.length();
  //   const int maxSize = 1 * 1024 * 1024;

  //   if (fileSize > maxSize) {
  //     debugPrint('❌ File too large: ${(fileSize / 1024).toStringAsFixed(1)} KB');
  //     return;
  //   }

  //   images.add(file);
  //   notifyListeners();
  // }

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
        description != '';
  }

  List<CertificateSubTypeEntity> subTypes = [];
  bool isLoading = false;

  Future<void> init() async {
    isLoading = true;
    notifyListeners();
    fetchCertificateSubTypes();
    // subTypes = await getSubTypesUseCase();
    //   final result = await getSubTypesUseCase();

    // if (result.) {
    //   subTypes = result.data!;
    // } else {
    //   debugPrint('❌ ${result.error}');
    // }

    isLoading = false;
    notifyListeners();
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

  // Future<void> addImage() async {
  //   if (images.length >= 5) return;

    // final XFile? picked = await _picker.pickImage(
    //   source: ImageSource.gallery,
    //   imageQuality: 80,
    // );
    // if (picked == null) return;

  //   final file = File(picked.path);
  //   final allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
  //   final extension = picked.name.split('.').last.toLowerCase();

  //   if (!allowedExtensions.contains(extension)) return;
  //   if (await file.length() > 1 * 1024 * 1024) return;

  //   // upload to server
  //   // final imageUrl = await uploadImageUseCase(file.path);
  //   images.add(File(file.path));
  //   // uploadedUrls.add(imageUrl);
  //   //     final uploadResult = await uploadImageUseCase(file.path);
  //   // if (uploadResult.isSuccess) {
  //   //   uploadedUrls.add(uploadResult.data!);
  //   //   images.add(file);
  //   //   notifyListeners();
  //   // } else {
  //   //   debugPrint('❌ ${uploadResult.error}');
  //   // }
  //   notifyListeners();
  // }

  Future<void> uploadImage(BuildContext context,) async {
    try {
      if (images.length >= 5) return;
        final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return;

      // validation
      final file = File(picked.path);
      final allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
      final extension = picked.name.split('.').last.toLowerCase();

      if (!allowedExtensions.contains(extension)) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Invalid image type')));
        return;
      }
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

  // List<File> images = [];
  List<String> uploadedUrls = [];

  // Future<void> createBooking() async {
  //   final booking = BookingEntity(
  //     bookingDate: _selectedDate.toIso8601String().split('T').first,
  //     bookingTime: '${_selectedTime!.hour}:${_selectedTime!.minute}',
  //     bookingLocation: _location!,
  //     certificateSubTypeId: _inspectionType!,
  //     images: uploadedUrls,
  //     description: description,
  //   );

  //   await createBookingUseCase(booking);
  // }
}

  // Future<void> createBooking() async {
  //   if (_selectedTime == null || _inspectionType == null || _location == null || description.isEmpty) return;

  //   final booking = BookingEntity(
  //     bookingDate: _selectedDate.toIso8601String().split('T').first,
  //     bookingTime: '${_selectedTime!.hour}:${_selectedTime!.minute}',
  //     bookingLocation: _location!,
  //     certificateSubTypeId: _inspectionType!,
  //     images: uploadedUrls,
  //     description: description,
  //   );

  //   final result = await createBookingUseCase(booking);
  //   if (result.isSuccess) {
  //     debugPrint('✅ Booking created successfully');
  //   } else {
  //     debugPrint('❌ Booking failed: ${result.error}');
  //   }
  // }
