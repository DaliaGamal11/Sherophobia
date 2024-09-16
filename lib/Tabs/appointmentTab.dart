import 'package:flutter/cupertino.dart';
import 'package:booking_calendar/booking_calendar.dart';
class appointmentTab extends StatelessWidget {
  const appointmentTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BookingCalendar(
      key: key,
      ///These are the required parameters
      getBookingStream: getBookingStream,
      uploadBooking: uploadBooking,
      convertStreamResultToDateTimeRanges: convertStreamResultToDateTimeRanges,
      ///These are only customizable, optional parameters
      bookingButtonColor: bookingButtonColor,
      bookingButtonText: bookingButtonText,
      bookingExplanation: bookingExplanation,
      bookingGridChildAspectRatio: bookingGridChildAspectRatio,
      bookingGridCrossAxisCount: bookingGridCrossAxisCount,
      formatDateTime: formatDateTime,
      convertStreamResultToDateTimeRanges:
      convertStreamResultToDateTimeRanges,
      availableSlotColor: availableSlotColor,
      availableSlotText: availableSlotText,
      bookedSlotColor: bookedSlotColor,
      bookedSlotText: bookedSlotText,
      selectedSlotColor: selectedSlotColor,
      selectedSlotText: selectedSlotText,
      gridScrollPhysics: gridScrollPhysics,
      loadingWidget: loadingWidget,
      errorWidget: errorWidget,
      uploadingWidget: uploadingWidget,
      pauseSlotColor: pauseSlotColor,
      pauseSlotText: pauseSlotText,
      hideBreakTime: hideBreakTime,
      locale: locale,
      disabledDays: disabledDays,
      startingDayOfWeek: startingDayOfWeek,
    );
  }
}
