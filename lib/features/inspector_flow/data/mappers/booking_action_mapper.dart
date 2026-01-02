import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/features/inspector_flow/domain/enum/booking_type_enum.dart';

class BookingActionMapper {
  static InspectorBookingActionType fromStatus(int status) {
    switch (status) {
      case bookingStatusAccepted:
        return InspectorBookingActionType.accepted;

      case bookingStatusStarted:
      case bookingStatusPaused:
      case bookingStatusStoppped:
        return InspectorBookingActionType.running;

      default:
        return InspectorBookingActionType.none;
    }
  }
}
