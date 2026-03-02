import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_common_card_container.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_model.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:provider/provider.dart';

class BookingsScreen extends StatefulWidget {
  final VoidCallback? onBookNowTapped;
  const BookingsScreen({super.key, this.onBookNowTapped});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final ScrollController _scrollController = ScrollController();
  String selectedStatus = allValueTxt;
  bool _shownApprovalDialog = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<BookingProvider>();
      setState(() => selectedStatus = allValueTxt);
      provider.resetBookings();
      provider.clearFilters(triggerFetch: false);

      await provider.fetchBookingsList(reset: true);

      _setupScrollListener(provider);
      _showLatestAwaitingApproval(provider);
    });
  }

  void _showLatestAwaitingApproval(BookingProvider provider) {
    if (_shownApprovalDialog) return;

    final awaitingBookings = provider.bookings
        .where((b) => b.status == bookingStatusAwaiting)
        .toList();

    if (awaitingBookings.isEmpty) return;

    awaitingBookings.sort((a, b) {
      final aTime = DateTime.parse(a.bookingDate);
      final bTime = DateTime.parse(b.bookingDate);
      return bTime.compareTo(aTime);
    });

    final latestBooking = awaitingBookings.first;
    log(latestBooking.toJson().toString());
    _shownApprovalDialog = true;
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _showApprovalDialog(context, latestBooking);
      }
    });
  }

  void _setupScrollListener(BookingProvider provider) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !provider.isLoadMoreRunning &&
          provider.hasMoreBookings) {
        provider.fetchBookingsList(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseResponsiveWidget(
      initializeConfig: true,
      buildWidget: (ctx, rc, app) {
        return Consumer<BookingProvider>(
          builder: (context, provider, _) {
            final todaysApproved = _getTodaysApprovedBookings(
              provider.bookings,
            );
            final otherBookings = provider.bookings
                .where((b) => !todaysApproved.contains(b))
                .toList();
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildFilterChips(context),
                      const SizedBox(height: 16),
                      _buildBookNowButton(context),
                      const SizedBox(height: 16),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async =>
                              provider.fetchBookingsList(reset: true),
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(bottom: 24),
                            itemCount:
                                todaysApproved.length +
                                otherBookings.length +
                                (provider.isLoadMoreRunning ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index < todaysApproved.length) {
                                final booking = todaysApproved[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: GestureDetector(
                                    onTap: () =>
                                        _showBookingDetails(context, booking),
                                    child: _buildBookingCard(context, booking),
                                  ),
                                );
                              }

                              final adjustedIndex =
                                  index - todaysApproved.length;
                              if (adjustedIndex < otherBookings.length) {
                                final booking = otherBookings[adjustedIndex];
                                return Column(
                                  children: [
                                    _buildBookingCard(context, booking),
                                    index == provider.bookings.length - 1
                                        ? SizedBox(height: 80)
                                        : SizedBox.shrink(),
                                  ],
                                );
                              }
                              if (provider.isFetchingBookings &&
                                  provider.bookings.isEmpty) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (!provider.isFetchingBookings &&
                                  provider.bookings.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        noBookingImg,
                                        width: 150,
                                        height: 150,
                                      ),
                                      const SizedBox(height: 16),
                                      textWidget(
                                        text: "No bookings found.",
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                );
                              }

                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (provider.isFetchingBookings && provider.bookings.isEmpty)
                  const Center(child: CircularProgressIndicator()),
                if (!provider.isFetchingBookings && provider.bookings.isEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(noBookingImg, width: 150, height: 150),
                        const SizedBox(height: 16),
                        textWidget(
                          text: "No bookings found.",
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                if (provider.isFilterLoading)
                  const Center(child: CircularProgressIndicator()),
                if (provider.isActionProcessing)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),

                if (provider.isLoadingBookingDetail)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildBookNowButton(BuildContext context) {
    return AppButton(
      onTap: widget.onBookNowTapped,
      icon: const Icon(Icons.add_circle_outline, color: Colors.white),
      iconLeftMargin: 10,
      showIcon: true,
      text: 'Book Now',
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final scrollController = ScrollController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  return false;
                },
                child: Stack(
                  children: [
                    Scrollbar(
                      controller: scrollController,
                      thumbVisibility: true,
                      thickness: 3,
                      radius: const Radius.circular(4),
                      trackVisibility: false,
                      scrollbarOrientation: ScrollbarOrientation.bottom,
                      interactive: true,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: statusOptions.map((option) {
                            final isSelected =
                                selectedStatus == option[valueTxt];
                            return Padding(
                              padding: const EdgeInsets.only(
                                right: 8,
                                bottom: 12,
                              ),
                              child: ChoiceChip(
                                label: textWidget(
                                  text: option[labelTxt],
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[700]!,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                                selected: isSelected,
                                selectedColor: primary,
                                backgroundColor: Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: isSelected ? 3 : 0,
                                onSelected: (selected) {
                                  setState(
                                    () => selectedStatus = option[valueTxt]
                                        .toString(),
                                  );
                                  final provider = context
                                      .read<BookingProvider>();

                                  if (option[valueTxt] == allValueTxt) {
                                    provider.clearFilters(triggerFetch: false);
                                    provider.fetchBookingsList(reset: true);
                                  } else {
                                    provider.filterByStatus(option[valueTxt]);
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return AnimatedBuilder(
                            animation: scrollController,
                            builder: (context, _) {
                              final maxScrollExtent =
                                  scrollController.position.hasPixels
                                  ? scrollController.position.maxScrollExtent
                                  : 1;
                              final scrollOffset = scrollController.hasClients
                                  ? scrollController.offset /
                                        (maxScrollExtent == 0
                                            ? 1
                                            : maxScrollExtent)
                                  : 0.0;
                              final indicatorWidth = constraints.maxWidth * 0.3;
                              final indicatorLeft =
                                  scrollOffset *
                                  (constraints.maxWidth - indicatorWidth);

                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Transform.translate(
                                  offset: Offset(indicatorLeft, 0),
                                  child: Container(
                                    height: 3,
                                    width: indicatorWidth,
                                    decoration: BoxDecoration(
                                      color: AppColors.authThemeColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 6),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _showSortFilterSheet(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.filter_alt_rounded, color: primary, size: 24),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBookingCard(BuildContext context, BookingData booking) {
    final color = statusColor(booking.status);

    return GestureDetector(
      onTap: () => _showBookingDetails(context, booking),
      child: AppCardContainer(
        margin: const EdgeInsets.symmetric(vertical: 8),
        borderRadius: 18,
        shadowColor: Colors.grey.withValues(alpha: 0.15),
        blurRadius: 8,
        shadowOffset: const Offset(0, 3),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6,
                height: 70,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Flexible(
                          flex: 6,
                          child: textWidget(
                            text: booking.bookingLocation,
                            maxLine: 3,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),

                        Flexible(
                          flex: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: color.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  statusIcon(booking.status!),
                                  size: 16,
                                  color: color,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: textWidget(
                                    text: bookingStatusToText(
                                      booking.status ?? -1,
                                    ),
                                    fontSize: 12,
                                    color: color,
                                    fontWeight: FontWeight.w600,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        textWidget(
                          text: DateFormat(
                            'dd MMM yyyy',
                          ).format(DateTime.parse(booking.bookingDate)),
                          fontSize: 12,
                          color: Colors.grey[700]!,
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        textWidget(
                          text: booking.bookingTime,
                          fontSize: 12,
                          color: Colors.grey[700]!,
                        ),
                      ],
                    ),

                    const SizedBox(height: 2),

                    textWidget(
                      text: booking.description.isNotEmpty
                          ? booking.description
                          : noDescriptionProvided,
                      fontSize: 12,
                      color: Colors.grey[800]!,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showApprovalDialog(BuildContext context, BookingData booking) {
    final themeColor = AppColors.authThemeColor;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.assignment_turned_in,
                        color: themeColor,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: textWidget(
                          text: inspectionCompletedApprovalRequired,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: themeColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_bottom,
                          color: themeColor,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        textWidget(
                          text: awaitingYourApprovalLabelTxt,

                          color: themeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Divider(color: Colors.grey[300]),
                  textWidget(
                    text: inspectionDetails,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),

                  const SizedBox(height: 10),

                  _infoRow(
                    "📅 $dateTxt",
                    DateFormat(
                      'dd/MM/yyyy',
                    ).format(DateTime.parse(booking.bookingDate)),
                  ),
                  _infoRow("⏰ $timeTxt", booking.bookingTime),
                  _infoRow("📍 $locationTxt", booking.bookingLocation),
                  _infoRow("📝 $descriptionTxt", booking.description),
                  booking.timerDuration != null && booking.timerDuration! > 0
                      ? _infoRow(
                          "⏱ $durationTxt",
                          formatDuration(booking.timerDuration ?? 0),
                        )
                      : SizedBox(),

                  const SizedBox(height: 20),
                  Divider(color: Colors.grey[300]),

                  textWidget(
                    text: paymentInformationTxt,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),

                  const SizedBox(height: 10),
                  textWidget(
                    text: paymentDeductionInfoTxt(
                      double.parse(booking.totalBillingAmount.toString()),
                    ),

                    color: Colors.grey[700]!,
                    height: 1.4,
                  ),
                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppButton(
                        width: MediaQuery.of(context).size.width / 2.8,

                        pHorizontal: 5,

                        showIcon: true,
                        iconLeftMargin: 10,
                        icon: const Icon(
                          Icons.cancel_outlined,
                          size: 18,
                          color: AppColors.authThemeColor,
                        ),
                        buttonBackgroundColor: AppColors.backgroundColor,
                        isBorder: true,
                        borderColor: AppColors.authThemeColor,
                        text: cancelTxt,
                        textColor: AppColors.authThemeColor,
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 16),
                      AppButton(
                        width: MediaQuery.of(context).size.width / 2.8,
                        icon: const Icon(
                          Icons.payment,
                          size: 18,
                          color: Colors.white,
                        ),
                        text: agreeAndPayTxt,
                        showIcon: true,
                        iconLeftMargin: 10,
                        onTap: () async {
                          log(booking.inspector!.id.toString());
                          log(booking.id.toString());

                          final user = context.read<UserProvider>().user;
                          final rootContext = Navigator.of(context).context;
                          Navigator.pop(context);
                          await context
                              .read<BookingProvider>()
                              .approveAndPayBooking(
                                rootContext,
                                booking.id,
                                user!.userId,
                                booking.inspector!.id.toString(),
                              );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;

    if (hours > 0) {
      return '$hours hr $minutes min';
    }
    return '$minutes min';
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: textWidget(
              text: label,

              color: Colors.black87,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          Expanded(
            flex: 3,
            child: textWidget(text: value, color: Colors.black54, height: 1.4),
          ),
        ],
      ),
    );
  }

  void _showBookingDetails(BuildContext context, BookingData booking) {
    final isPending = booking.status == bookingStatusPending;
    final isApproved = booking.status == bookingStatusAccepted;
    final isRejected = booking.status == bookingStatusRejected;
    final isAwaitingPayment = booking.status == bookingStatusAwaiting;

    if (isAwaitingPayment) {
      _showApprovalDialog(context, booking);
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              textWidget(
                text: booking.bookingLocation,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 12),
              textWidget(
                text:
                    "$dateTxt: ${DateFormat('dd MMM yyyy').format(DateTime.parse(booking.bookingDate))}",
              ),
              textWidget(text: "$timeTxt: ${booking.bookingTime}"),
              const SizedBox(height: 12),
              textWidget(text: "$descriptionTxt: ${booking.description}"),
              const SizedBox(height: 24),

              Row(
                children: [
                  isPending
                      ? Expanded(
                          child: AppButton(
                            text: editBooking,
                            onTap: () async {
                              Navigator.pop(context);

                              final provider = context.read<BookingProvider>();
                              await provider.getBookingDetail(
                                context: context,
                                bookingId: booking.id,
                                isEditable: true,
                                isInspectorView: false,
                              );
                            },
                          ),
                        )
                      : SizedBox.shrink(),
                  SizedBox(width: isPending ? 12 : 0),
                  Expanded(
                    child: AppButton(
                      text: viewBooking,
                      onTap: () async {
                        Navigator.pop(context);

                        final provider = context.read<BookingProvider>();
                        await provider.getBookingDetail(
                          context: context,
                          bookingId: booking.id,
                          isEditable: false,
                          isInspectorView: false,
                        );
                      },
                    ),
                  ),
                ],
              ),
              if (isPending || isApproved || isRejected) ...[
                const SizedBox(height: 12),
                AppButton(
                  text: deleteBooking,
                  buttonBackgroundColor: Colors.redAccent,
                  onTap: () => _showDeleteBookingModal(
                    context,
                    booking,
                    cancellationFee: 60,
                  ),
                ),
              ],
              const SizedBox(height: 12),

              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor(booking.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor(booking.status).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        statusIcon(booking.status!),
                        color: statusColor(booking.status),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      textWidget(
                        text: bookingStatusToText(booking.status ?? -1),
                        color: statusColor(booking.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDeleteBookingModal(
    BuildContext context,
    BookingData booking, {
    required double cancellationFee,
  }) async {
    final bookingProvider = context.read<BookingProvider>();
    bool isLoading = false;

    DateTime bookingDateTime() {
      final date = DateTime.parse(booking.bookingDate);
      final t = booking.bookingTime.trim().toUpperCase().replaceAll('.', '');
      try {
        DateTime time;
        if (t.contains('AM') || t.contains('PM')) {
          time = DateFormat('h:mm a').parse(t);
        } else {
          time = DateFormat('HH:mm').parse(t);
        }
        return DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      } catch (_) {
        return DateTime(date.year, date.month, date.day, 10, 0);
      }
    }

    final now = DateTime.now();
    final bookingTime = bookingDateTime();
    final diffHours = bookingTime.difference(now).inMinutes / 60;
    final bool isWithin8Hours = diffHours > 0 && diffHours < 8;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    textWidget(
                      text: wntDeleteBooking,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 16),
                    textWidget(
                      text: deleteBookingConfirmationTxt,
                      fontSize: 14,
                      color: Colors.grey[700]!,
                    ),
                    if (isWithin8Hours) ...[
                      const SizedBox(height: 12),
                      textWidget(
                        text: cancellationFeeWarningTxt(cancellationFee),
                        fontSize: 14,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () => Navigator.pop(context),
                          child: textWidget(text: cancelTxt),
                        ),
                        const SizedBox(width: 12),
                        AppButton(
                          width: MediaQuery.of(context).size.width / 5,
                          buttonBackgroundColor: Colors.redAccent,
                          onTap: isLoading
                              ? null
                              : () async {
                                  setState(() => isLoading = true);

                                  await bookingProvider.deleteBookingDetail(
                                    context: context,
                                    bookingId: booking.id,
                                    // applyCancellationFee: isWithin8Hours,
                                  );

                                  setState(() => isLoading = false);
                                  if (context.mounted) Navigator.pop(context);
                                },
                          text: deleteText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSortFilterSheet(BuildContext context) {
    final provider = context.read<BookingProvider>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Wrap(
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              textWidget(
                text: filterSortTitleTxt,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const Divider(height: 24),

              ListTile(
                leading: const Icon(Icons.arrow_upward),
                title: textWidget(text: sortByDateAscTxt),
                onTap: () {
                  provider.sortBookingsByDate(ascending: true);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_downward),
                title: textWidget(text: sortByDateDescTxt),
                onTap: () {
                  provider.sortBookingsByDate(ascending: false);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: textWidget(text: clearAllFiltersTxt),
                onTap: () {
                  provider.clearFilters();
                  provider.fetchBookingsList(reset: true);
                  setState(() => selectedStatus = allValueTxt);
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  List<BookingData> _getTodaysApprovedBookings(List<BookingData> list) {
    final now = DateTime.now();

    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final todaysApproved = <BookingData>[];

    for (final b in list) {
      if (b.status == 1) {
        final dt = _bookingDateTime(b);
        if (dt.isAfter(startOfDay) && dt.isBefore(endOfDay)) {
          todaysApproved.add(b);
        }
      }
    }

    todaysApproved.sort((a, b) {
      final aTime = _bookingDateTime(a);
      final bTime = _bookingDateTime(b);
      return aTime.compareTo(bTime);
    });

    return todaysApproved;
  }

  DateTime _bookingDateTime(BookingData b) {
    final date = DateTime.parse(b.bookingDate);
    DateTime time;
    final t = b.bookingTime.trim().toUpperCase().replaceAll('.', '');
    try {
      if (t.contains('AM') || t.contains('PM')) {
        time = DateFormat('h:mm a').parse(t);
      } else {
        time = DateFormat('HH:mm').parse(t);
      }
    } catch (_) {
      time = DateFormat('h:mm a').parse('10:00 AM');
    }
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
