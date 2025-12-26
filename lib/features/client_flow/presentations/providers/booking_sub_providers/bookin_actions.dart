import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/di/app_sockets/socket_service.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_detail_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/booking_entity.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/create_booking_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/get_booking_Detail_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/update_booking_detail_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/delete_booking_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/update_booking_status.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/apply_show_up_fee.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/booking_edit_screen.dart';

class BookingActionsService {
  final BookingProvider provider;
  final SocketService socket = locator<SocketService>();
  BookingActionsService(this.provider);

  void clearBookingDetail() {
    provider.bookingDetailModel = null;
    provider.notify();
  }

  void clearBookingData() {
    provider.provSelectedDate = DateTime.now();
    provider.provSelectedTime = null;
    provider.formattedTime = null;
    provider.location = null;
    provider.provInspectionType = null;
    provider.description = '';
    provider.uploadedUrls.clear();
    provider.images.clear();
    provider.locationController.clear();
    provider.descriptionController.clear();
    provider.notify();
  }

  Future<void> createBooking({required BuildContext context}) async {
    try {
      provider.setProcessing(true);
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.authToken == null) {
        throw Exception('User not found in local storage');
      }

      final booking = BookingEntity(
        bookingDate: provider.provSelectedDate
            .toIso8601String()
            .split('T')
            .first,
        bookingTime: provider.formattedTime!,
        bookingLocation: provider.locationController.text,
        certificateSubTypeId: provider.provInspectionType!.id,
        images: provider.uploadedUrls,
        description: provider.description!,
        bookingLocationCoordinates: [
          provider.selectedLng != '' && provider.selectedLng != null
              ? provider.selectedLng.toString()
              : '-114.59635',

          provider.selectedLat != '' && provider.selectedLat != null
              ? provider.selectedLat.toString()
              : '33.6103',
        ],
      );

      final createBookingUseCase = locator<CreateBookingUseCase>();
      final state = await provider
          .executeParamsUseCase<
            CreateBookingResponseModel,
            CreateBookingParams
          >(
            useCase: createBookingUseCase,
            query: CreateBookingParams(bookingEntity: booking),
            launchLoader: true,
          );

      state?.when(
        data: (response) async {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(
                  color: AppColors.whiteColor,
                  text: response.message.isNotEmpty
                      ? response.message
                      : 'Booking created successfully',
                ),
              ),
            );
          }
          log('Booking created with ID: ${response.body.id}');
          final inspectorIds = response.body.inspectorIds;
          await handleBookingCreated(
            context: context,
            bookingId: response.body.id,
            inspectorIds: inspectorIds,
          );
          // clearBookingData();
        },
        error: (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(
                  color: AppColors.whiteColor,
                  text: e.message ?? 'Booking creation failed',
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      log(e.toString());
    } finally {
      provider.setProcessing(false);
    }
  }

  Future<void> handleBookingCreated({
    required BuildContext context,
    required String bookingId,
    required List<String> inspectorIds,
  }) async {
    try {
      log('handleBookingCreated: bookingId= $bookingId');
      socket.bookingCreationNotification({
        'bookingId': bookingId,
        'inspectorIds': inspectorIds,
      });

      socket.joinBookingRoom(bookingId);
      provider.currentBookingId = bookingId;
    } catch (e) {
      log('BookingActionsService.handleBookingCreated error: \$e');
    }
  }

  Future<void> updateBoookingStatusSocket({
    required String bookingId,
    required String inspectorId,
    required int status,
  }) async {
    socket.updateBookingStatus({
      'bookingId': bookingId,
      'userId': inspectorId,
      'status': status,
    });
  }

  Future<void> inspectorRaiseAmount({
    required String bookingId,
    required String inspectorId,
    required int raisedAmount,
  }) async {
    socket.raiseInspectionRequest({
      'bookingId': bookingId,
      'inspectorId': inspectorId,
      'raisedAmount': raisedAmount,
      'agreedToRaise': 0,
    });
  }

  Future<void> updateBooking({
    required BuildContext context,
    required String bookingId,
  }) async {
    try {
      provider.setProcessing(true);
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.authToken == null) {
        throw Exception('User not found in local storage');
      }

      final booking = BookingEntity(
        bookingDate: provider.provSelectedDate
            .toIso8601String()
            .split('T')
            .first,
        bookingTime: provider.formattedTime!,
        bookingLocation: provider.location!,
        bookingLocationCoordinates: [
          provider.selectedLat != '' && provider.selectedLat != null
              ? provider.selectedLat.toString()
              : '-97.7431',
          provider.selectedLng != '' && provider.selectedLng != null
              ? provider.selectedLng.toString()
              : '30.2672',
        ],
        certificateSubTypeId: provider.provInspectionType!.id,
        images: provider.uploadedUrls,
        description: provider.description!,
      );

      final updateBookingDetailUseCase = locator<UpdateBookingDetailUseCase>();
      final state = await provider
          .executeParamsUseCase<BookingData, UpdateBookingDetailParams>(
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
          provider.updatedBookingData = response;
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(
                  color: AppColors.whiteColor,
                  text: 'Booking Updated successfully.',
                ),
              ),
            );
          }
          Navigator.pop(context, true);
          provider.clearFilters();
        },
        error: (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(
                  color: AppColors.whiteColor,
                  text: e.message ?? 'Booking update failed',
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      log(e.toString());
    } finally {
      provider.setProcessing(false);
    }
  }

  Future<void> deleteBookingDetail({
    required BuildContext context,
    required String bookingId,
  }) async {
    try {
      provider.setProcessing(true);
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.authToken == null) {
        throw Exception('User not found in local storage');
      }

      final deleteBookingUseCase = locator<DeleteBookingDetailUseCase>();
      final state = await provider
          .executeParamsUseCase<bool, DeleteBookingDetailParams>(
            useCase: deleteBookingUseCase,
            query: DeleteBookingDetailParams(bookingId: bookingId),
            launchLoader: true,
          );

      state?.when(
        data: (response) async {
          clearBookingDetail();
          Navigator.pop(context);
          provider.fetchBookingsList(reset: true);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(
                  color: AppColors.whiteColor,
                  text: 'Booking Deleted successfully.',
                ),
              ),
            );
          }
        },
        error: (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(
                  color: AppColors.whiteColor,
                  text: e.message ?? 'Booking Deletion failed',
                ),
              ),
            );
          }
        },
      );
    } finally {
      provider.setProcessing(false);
    }
  }

  Future<void> getBookingDetail({
    required BuildContext context,
    required String bookingId,
    required bool isEditable,
    required bool isInspectorView,
  }) async {
    try {
      provider.isLoadingBookingDetail = true;
      provider.notify();
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.authToken == null) {
        throw Exception('User not found in local storage');
      }

      final getBookingDetailUseCase = locator<GetBookingDetailUseCase>();
      final state = await provider
          .executeParamsUseCase<BookingDetailModel, GetBookingDetailParams>(
            useCase: getBookingDetailUseCase,
            query: GetBookingDetailParams(bookingId: bookingId),
            launchLoader: true,
          );

      state?.when(
        data: (response) async {
          clearBookingDetail();
          provider.bookingDetailModel = response;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookingEditScreen(
                booking: response,
                isEdiatble: isEditable,
                isReadOnly: !isEditable,
                isInspectorView: isInspectorView,
              ),
            ),
          ).then((result) {
            if (result == true) {
              provider.fetchBookingsList(reset: true);
            }
          });
        },
        error: (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(
                  color: AppColors.whiteColor,
                  text: e.message ?? 'Fetching Booking Detail failed',
                ),
              ),
            );
          }
        },
      );
    } finally {
      provider.isLoadingBookingDetail = false;
      provider.notify();
    }
  }

  Future<void> updateBookingStatus({
    required BuildContext context,
    required String bookingId,
    required String userId,
    required int newStatus,
  }) async {
    try {
      provider.isUpdatingBooking = true;
      provider.notify();
      final updateBookingStatusUseCase = locator<UpdateBookingStatusUseCase>();
      final state = await provider
          .executeParamsUseCase<BookingData, UpdateBookingStatusParams>(
            useCase: updateBookingStatusUseCase,
            query: UpdateBookingStatusParams(
              status: newStatus,
              bookingId: bookingId,
            ),
            launchLoader: true,
          );

      state?.when(
        data: (response) async {
          provider.updatedBookingData = response;
          final index = provider.bookings.indexWhere((b) => b.id == bookingId);
          if (index != -1) {
            provider.bookings[index] = provider.updatedBookingData!;
          }
          await updateBoookingStatusSocket(
            bookingId: bookingId,
            inspectorId: userId,
            status: newStatus,
          );
          if (newStatus == bookingStatusAccepted ||
              newStatus == bookingStatusRejected) {
            socket.leaveBookingRoom(bookingId);
          }

          provider.notify();
        },
        error: (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(
                  color: AppColors.whiteColor,
                  text: e.message ?? 'Booking update failed',
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: textWidget(
              color: AppColors.whiteColor,
              text: 'Failed: $e',
            ),
          ),
        );
      }
    } finally {
      provider.isUpdatingBooking = false;
      provider.notify();
    }
  }

  Future<void> updateShowUpFeeStatus({
    required BuildContext context,
    required String bookingId,
    required bool showUpFeeApplied,
  }) async {
    try {
      provider.isUpdatingBooking = true;
      provider.notify();
      final showUpFeeStatusUseCase = locator<ShowUpFeeStatusUseCase>();
      final state = await provider
          .executeParamsUseCase<BookingData, ShowUpFeeStatusParams>(
            useCase: showUpFeeStatusUseCase,
            query: ShowUpFeeStatusParams(
              showUpFeeApplied: showUpFeeApplied,
              bookingId: bookingId,
            ),
            launchLoader: false,
          );

      state?.when(
        data: (response) async {
          provider.updatedBookingData = response;
          final index = provider.bookings.indexWhere((b) => b.id == bookingId);
          if (index != -1) {
            provider.bookings = [...provider.bookings]
              ..[index] = provider.updatedBookingData!;
          }
          provider.showUpFeeStatusMap[bookingId] = showUpFeeApplied;
          provider.notify();
        },
        error: (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(
                  color: AppColors.whiteColor,
                  text: e.message ?? 'Show Up fee Status failed to update.',
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: textWidget(
              color: AppColors.whiteColor,
              text: 'Failed: $e',
            ),
          ),
        );
      }
    } finally {
      provider.isUpdatingBooking = false;
      provider.notify();
    }
  }

  Future<void> approveAndPayBooking(
    BuildContext context,
    String bookingId,
    String userId,
  ) async {
    try {
      provider.isActionProcessing = true;
      provider.notify();
      await updateBookingStatus(
        context: context,
        bookingId: bookingId,
        newStatus: bookingStatusCompleted,
        userId: userId,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: textWidget(
              color: AppColors.whiteColor,
              text: "Payment successful and booking approved.",
            ),
          ),
        );
      }
      provider.fetchBookingsList(reset: true);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: textWidget(color: AppColors.whiteColor, text: "Error: $e"),
          ),
        );
      }
    } finally {
      provider.isActionProcessing = false;
      provider.notify();
    }
  }

  Future<void> disagreeBooking(
    BuildContext context,
    String bookingId,
    String userId,
  ) async {
    try {
      provider.isActionProcessing = true;
      provider.notify();
      await updateBookingStatus(
        context: context,
        bookingId: bookingId,
        newStatus: bookingStatusStoppped,
        userId: userId,
      );
      provider.fetchBookingsList(reset: true);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: textWidget(color: AppColors.whiteColor, text: "Error: $e"),
          ),
        );
      }
    } finally {
      provider.isActionProcessing = false;
      provider.notify();
    }
  }

  Future<void> declineBooking({
    required BuildContext context,
    required String bookingId,
    required String userId,
  }) async {
    try {
      provider.isUpdatingBooking = true;
      provider.notify();
      provider.isActionProcessing = true;
      provider.notify();
      await updateBookingStatus(
        context: context,
        bookingId: bookingId,
        newStatus: bookingStatusCancelledByInspector,
        userId: userId,
      );
      await provider.fetchBookingsList(reset: true);
    } finally {
      provider.isUpdatingBooking = false;
      provider.isActionProcessing = false;
      provider.notify();
    }
  }
}
