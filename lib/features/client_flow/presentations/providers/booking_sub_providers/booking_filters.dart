import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/booking_list_entity.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/certificate_sub_type_entity.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_sub_providers/booking_timers.dart';
import 'package:intl/intl.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/get_certificate_subtype_usecase.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/fetch_booking_list_usecase.dart';

class BookingFiltersService {
  final BookingProvider provider;
  final BookingTimerService timerService;

  BookingFiltersService(this.provider, this.timerService);

  Future<void> fetchCertificateSubTypes() async {
    try {
      provider.setProcessing(true);
      final getSubTypesUseCase = locator<GetCertificateSubTypesUseCase>();
      final state = await provider
          .executeParamsUseCase<
            List<CertificateSubTypeEntity>,
            GetCertificateSubTypesParams
          >(useCase: getSubTypesUseCase, launchLoader: true);

      state?.when(
        data: (response) {
          provider.subTypes = response;
          if (provider.subTypes.isNotEmpty) {
            provider.setInspectionType(provider.subTypes[0]);
          }
          provider.notify();
        },
        error: (e) {},
      );
    } catch (e) {
      log(e.toString());
    } finally {
      provider.setProcessing(false);
    }
  }

  void setDate(DateTime d) {
    provider.provSelectedDate = DateTime(d.year, d.month, d.day);
    provider.notify();
  }

  void setTime(TimeOfDay t) {
    provider.provSelectedTime = t;
    provider.formattedTime = formatTimeForApi(provider.provSelectedTime!);
    provider.notify();
  }

  void setInspectionType(CertificateSubTypeEntity? t) {
    provider.provInspectionType = t;
    provider.notify();
  }

  void setLocation(String? l) {
    provider.location = provider.locationController.text;
    provider.notify();
  }

  void setDescription(String? v) {
    provider.description = v;
    if (provider.descriptionController.text != v) {
      provider.descriptionController.text = v ?? '';
    }
    provider.notify();
  }

  void setAgreePolicy(bool val) {
    provider.agreedToPolicies = val;
    provider.notify();
  }

  void setAddressData(Map<String, dynamic> value) {
    provider.placeName = value["place_name"];
    provider.city = value["city"];
    provider.state = value["state"];
    provider.country = value["country"];
    provider.pincode = value["pincode"];
    provider.selectedLat = value["lat"].toString();
    provider.selectedLng = value["lng"].toString();
    provider.placeType = value["place_type"].toString();
    provider.notify();
  }

  bool validate({required BuildContext cntx}) {
    if (provider.provSelectedTime == null) {
      ScaffoldMessenger.of(cntx).showSnackBar(
        SnackBar(content: textWidget(text: 'Please select a time', color: AppColors.backgroundColor,)),
      );
      return false;
    }
    if (provider.provInspectionType == null) {
      ScaffoldMessenger.of(cntx).showSnackBar(
        SnackBar(content: textWidget(text: 'Please select an inspection type', color: AppColors.backgroundColor,)),
      );
      return false;
    }
    if (provider.location == null) {
      ScaffoldMessenger.of(cntx).showSnackBar(
        SnackBar(content: textWidget(text: 'Please select a location', color: AppColors.backgroundColor,)),
      );
      return false;
    }
    if (provider.description == null) {
      ScaffoldMessenger.of(cntx).showSnackBar(
        SnackBar(content: textWidget(text: 'Please enter a description', color: AppColors.backgroundColor,)),
      );
      return false;
    }
    if (provider.uploadedUrls.isEmpty) {
      ScaffoldMessenger.of(cntx).showSnackBar(
        SnackBar(content: textWidget(text: 'Please add at least one image', color: AppColors.backgroundColor,)),
      );
      return false;
    }
    if (!provider.agreedToPolicies) {
      ScaffoldMessenger.of(cntx).showSnackBar(
        SnackBar(
          content: textWidget(
            text: 'You must agree to the policies before continuing.', color: AppColors.backgroundColor,
          ),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> fetchBookingsList({
    bool reset = false,
    bool loadMore = false,
  }) async {
    try {
      if (provider.isFetchingBookings || provider.isLoadMoreRunning) return;

      if (reset) {
        provider.currentPage = 1;
        if (provider.bookings.isEmpty) {
          provider.isFetchingBookings = true;
        }
        provider.notify();
      }

      if (!loadMore) {
        provider.isFetchingBookings = true;
      } else {
        provider.isLoadMoreRunning = true;
      }
      provider.notify();

      final fetchBookingUsecase = locator<FetchBookingsUseCase>();

      final params = FetchBookingsParams(
        page: provider.currentPage,
        perPageLimit: provider.perPageLimit,
        search: provider.searchDate ?? provider.searchQuery ?? '',
        sortBy: provider.sortBy,
        sortOrder: provider.sortOrder,
        status: provider.status != null && provider.status!.isNotEmpty
            ? int.tryParse(provider.status!)
            : null,
      );

      final state = await provider
          .executeParamsUseCase<List<BookingListEntity>, FetchBookingsParams>(
            useCase: fetchBookingUsecase,
            query: params,
            launchLoader: false,
          );

      state?.when(
        data: (response) {
          if (loadMore) {
            provider.bookings.addAll(response);
          } else {
            provider.bookings = response;
          }

          for (var booking in provider.bookings) {
            final liveDuration = provider.calculateLiveDuration(booking);
            provider.activeTimers[booking.id] = liveDuration;
            provider.isTimerRunning[booking.id] =
                booking.status == bookingStatusStarted;
          }

          provider.timerService.ensureGlobalTimerRunning
              .call(); 
          if (response.length < provider.perPageLimit) {
            provider.hasMoreBookings = false;
          } else {
            provider.currentPage++;
          }
          provider.notify();
        },
        error: (e) {},
      );
    } catch (e) {
      log(e.toString());
    } finally {
      provider.isFetchingBookings = false;
      provider.isLoadMoreRunning = false;
      provider.notify();
    }
  }

  void resetBookings() {
    provider.bookings.clear();
    provider.currentPage = 1;
    provider.hasMoreBookings = true;
    provider.notify();
  }

  void searchBookings(String query) {
    provider.searchQuery = query.trim().isEmpty ? null : query.trim();
    provider.searchDate = null;
    provider.currentPage = 1;
    fetchBookingsList(reset: true);
  }

  void searchBookingsByDate(String date) {
    provider.searchDate = date;
    provider.searchQuery = null;
    provider.currentPage = 1;
    fetchBookingsList(reset: true);
  }

  List<BookingListEntity> getFilteredBookings(List<int> filterStatuses) {
    final now = DateTime.now();
    final filtered = provider.bookings
        .where((b) => filterStatuses.contains(b.status))
        .toList();

    filtered.sort((a, b) {
      final aDate = DateTime.parse(a.bookingDate);
      final bDate = DateTime.parse(b.bookingDate);
      final aIsPast = aDate.isBefore(now);
      final bIsPast = bDate.isBefore(now);

      if (aIsPast && !bIsPast) return 1;
      if (!aIsPast && bIsPast) return -1;

      return aDate.compareTo(bDate);
    });

    return filtered;
  }

  Future<void> filterByStatus(String status) async {
    if (provider.status == "status") return;
    provider.status = status;
    provider.currentPage = 1;
    try {
      provider.isFilterLoading = true;
      provider.bookings.clear();
      provider.notify();
      await fetchBookingsList(reset: true);
    } finally {
      provider.isFilterLoading = false;
      provider.notify();
    }
  }

  void sortBookingsByDate({bool ascending = true}) {
    provider.bookings.sort((a, b) {
      final dateA = DateTime.parse(a.bookingDate);
      final dateB = DateTime.parse(b.bookingDate);
      return ascending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });
    provider.notify();
  }

  void clearFilters({bool triggerFetch = false}) {
    provider.searchQuery = null;
    provider.searchDate = null;
    provider.status = null;
    provider.currentPage = 1;
    provider.hasMoreBookings = true;
    provider.bookings.clear();
    provider.notify();

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
}
