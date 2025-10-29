import 'package:flutter/material.dart';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_detail_model.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/get_booking_Detail_usecase.dart';

class BookingProvider extends BaseViewModel {


  // Future<void> getBookingDetail({
  //   required BuildContext context,
  // }) async {
  //   try {
  //     final user = await locator<AuthLocalDataSource>().getUser();
  //     if (user == null || user.token == null) {
  //       throw Exception('User not found in local storage');
  //     }

  //     final getBookingDetailUseCase = locator<GetBookingDetailUseCase>();
  //     final state =
  //         await executeParamsUseCase<
  //           BookingDetailModel,
  //           GetBookingDetailParams
  //         >(
  //           useCase: getBookingDetailUseCase,

  //           query: GetBookingDetailParams(bookingId: bookingId),
  //           launchLoader: true,
  //         );

  //     state?.when(
  //       data: (response) async {
  //         bookingDetailModel = response;
  //         Navigator.pop(context);
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (_) => BookingEditScreen(booking: bookingDetailModel),
  //           ),
  //         ).then((result) {
  //           if (result == true) {
  //             fetchBookingsList(reset: true);
  //           }
  //         });
  //       },
  //       error: (e) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(e.message ?? 'Fetching Booking Detail failed'),
  //           ),
  //         );
  //       },
  //     );
  //   } finally {}
  // }


}
