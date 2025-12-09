import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/booking_list_entity.dart';
import 'package:intl/intl.dart';
import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/common_app_bar.dart';
import 'package:provider/provider.dart';

class BookingsScreen extends StatefulWidget {
  final VoidCallback? onBookNowTapped;
  const BookingsScreen({super.key, this.onBookNowTapped});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final ScrollController _scrollController = ScrollController();
  String selectedStatus = 'all';
  bool _shownApprovalDialog = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<BookingProvider>();
      setState(() => selectedStatus = 'all');
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

  final List<Map<String, dynamic>> _statusOptions = [
    {'label': 'All', 'value': 'all'},
    {'label': 'Awaiting Your Approval', 'value': '$bookingStatusAwaiting'},
    {'label': 'Accepted', 'value': '$bookingStatusAccepted'},
    {'label': 'Inspection Started', 'value': '$bookingStatusStarted'},

    {'label': 'Inspection Paused', 'value': '$bookingStatusPaused'},
    {'label': 'Inspection Stopped', 'value': '$bookingStatusStoppped'},
    {'label': 'Pending', 'value': '$bookingStatusPending'},
    {'label': 'Rejected', 'value': '$bookingStatusRejected'},
    {'label': 'Completed', 'value': '$bookingStatusCompleted'},
    {'label': 'Cancelled (You)', 'value': '$bookingStatusCancelledByClient'},
    {
      'label': 'Cancelled (Inspector)',
      'value': '$bookingStatusCancelledByInspector',
    },
    {'label': 'Expired', 'value': '$bookingStatusExpired'},
  ];

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
            return Scaffold(
              appBar: const CommonAppBar(showLogo: true, title: 'Bookings'),
              backgroundColor: Colors.grey[100],
              body: Stack(
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
                                      child: _buildBookingCard(
                                        context,
                                        booking,
                                      ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/no_booking.webp',
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
                          Image.asset(
                            'assets/images/no_booking.webp',
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
                    ),
                  if (provider.isFilterLoading)
                    const Center(child: CircularProgressIndicator()),
                  if (provider.isActionProcessing)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),

                  if (provider.isLoadingBookingDetail)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
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
                          children: _statusOptions.map((option) {
                            final isSelected =
                                selectedStatus == option['value'];
                            return Padding(
                              padding: const EdgeInsets.only(
                                right: 8,
                                bottom: 12,
                              ),
                              child: ChoiceChip(
                                label: textWidget(
                                  text: option['label'],
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
                                    () => selectedStatus = option['value'],
                                  );
                                  final provider = context
                                      .read<BookingProvider>();

                                  if (option['value'] == 'all') {
                                    provider.clearFilters(triggerFetch: false);
                                    provider.fetchBookingsList(reset: true);
                                  } else {
                                    provider.filterByStatus(option['value']);
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

  Widget _buildBookingCard(BuildContext context, BookingListEntity booking) {
    final color = _statusColor(booking.status);

    return GestureDetector(
      onTap: () => _showBookingDetails(context, booking),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
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
                                  _statusIcon(booking.status!),
                                  size: 16,
                                  color: color,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: textWidget(
                                    text: _statusLabel(booking.status),
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
                          : "No description provided",
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

  IconData _statusIcon(int status) {
    switch (status) {
      case bookingStatusPending:
        return Icons.hourglass_empty;
      case bookingStatusAccepted:
        return Icons.check_circle;
      case bookingStatusRejected:
        return Icons.cancel;
      case bookingStatusCompleted:
        return Icons.verified;
      case bookingStatusAwaiting:
        return Icons.hourglass_bottom;
      case bookingStatusCancelledByClient:
        return Icons.person_off;
      case bookingStatusCancelledByInspector:
        return Icons.engineering;
      case bookingStatusExpired:
        return Icons.timer_off;
      case bookingStatusStarted:
        return Icons.play_arrow;
      case bookingStatusPaused:
        return Icons.pause_circle_filled;
      case bookingStatusStoppped:
        return Icons.stop_circle;
      default:
        return Icons.info_outline;
    }
  }

  void _showApprovalDialog(BuildContext context, BookingListEntity booking) {
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
                          text: "Inspection Completed - Approval Required",
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
                          text: "Awaiting Your Approval",

                          color: themeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Divider(color: Colors.grey[300]),
                  textWidget(
                    text: "Inspection Details",
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),

                  const SizedBox(height: 10),

                  _infoRow(
                    "📅 Date",
                    DateFormat(
                      'dd/MM/yyyy',
                    ).format(DateTime.parse(booking.bookingDate)),
                  ),
                  _infoRow("⏰ Time", booking.bookingTime),
                  _infoRow("📍 Location", booking.bookingLocation),
                  _infoRow("📝 Description", booking.description),
                  _infoRow(
                    "⏱ Duration",
                    booking.timerDuration?.toString() ?? "0 minutes",
                  ),

                  const SizedBox(height: 20),
                  Divider(color: Colors.grey[300]),

                  textWidget(
                    text: "Payment Information",
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),

                  const SizedBox(height: 10),
                  textWidget(
                    text:
                        "Upon your approval, a payment of \$160.00 will be automatically deducted "
                        "from your wallet and transferred to the inspector.",
                    color: Colors.grey[700]!,
                    height: 1.4,
                  ),

                  const SizedBox(height: 8),
                  textWidget(
                    text: "Rate: \$160 per 4-hour block × 1 = \$160",
                    color: Colors.grey[600]!,
                    fontSize: 13,
                  ),

                  const SizedBox(height: 30),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AppButton(
                            width: 120,
                            pHorizontal: 5,
                            showIcon: true,
                            iconLeftMargin: 10,
                            icon: const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.red,
                            ),
                            text: "Disagree",
                            buttonBackgroundColor: AppColors.backgroundColor,
                            isBorder: true,
                            borderColor: Colors.red,
                            textColor: Colors.red,
                            onTap: () async {
                              final rootContext = Navigator.of(context).context;
                              Navigator.pop(context);
                              await context
                                  .read<BookingProvider>()
                                  .disagreeBooking(rootContext, booking.id);
                            },
                          ),
                          const SizedBox(width: 10),
                          AppButton(
                            width: 120,
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
                            text: "Cancel",
                            textColor: AppColors.authThemeColor,
                            onTap: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      AppButton(
                        icon: const Icon(
                          Icons.payment,
                          size: 18,
                          color: Colors.white,
                        ),
                        text: "Agree & Pay",
                        showIcon: true,
                        iconLeftMargin: 10,
                        onTap: () async {
                          final rootContext = Navigator.of(context).context;
                          Navigator.pop(context);
                          await context
                              .read<BookingProvider>()
                              .approveAndPayBooking(rootContext, booking.id);
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

  void _showBookingDetails(BuildContext context, BookingListEntity booking) {
    final isPending = booking.status == bookingStatusPending;
    final isApproved = booking.status == bookingStatusAccepted;
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
                    "Date: ${DateFormat('dd MMM yyyy').format(DateTime.parse(booking.bookingDate))}",
              ),
              textWidget(text: "Time: ${booking.bookingTime}"),
              const SizedBox(height: 12),
              textWidget(text: "Description: ${booking.description}"),
              const SizedBox(height: 24),

              AppButton(
                text: isPending ? 'Edit Booking' : 'View Booking',
                onTap: () async {
                  Navigator.pop(context);

                  final provider = context.read<BookingProvider>();
                  await provider.getBookingDetail(
                    context: context,
                    bookingId: booking.id,
                    isEditable: isPending,
                    isInspectorView: false,
                  );
                },
              ),
              if (isPending || isApproved) ...[
                const SizedBox(height: 12),
                AppButton(
                  text: 'Delete Booking',
                  buttonBackgroundColor: Colors.redAccent,
                  onTap: () {
                    Navigator.pop(context);
                    _confirmDelete(context, booking);
                  },
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
                    color: _statusColor(booking.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _statusColor(
                        booking.status,
                      ).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _statusIcon(booking.status!),
                        color: _statusColor(booking.status),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      textWidget(
                        text: _statusLabel(booking.status),
                        color: _statusColor(booking.status),
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

  void _confirmDelete(BuildContext context, BookingListEntity booking) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: textWidget(text: 'Delete Booking?'),
        content: textWidget(
          text: 'Are you sure you want to delete this booking?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: textWidget(text: 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<BookingProvider>().deleteBookingDetail(
                context: context,
                bookingId: booking.id,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: textWidget(text: 'Delete'),
          ),
        ],
      ),
    );
  }

  String _statusLabel(int? status) {
    switch (status) {
      case bookingStatusPending:
        return 'Pending';
      case bookingStatusAccepted:
        return 'Accepted';
      case bookingStatusRejected:
        return 'Rejected';
      case bookingStatusStarted:
        return 'Inspection Started';
      case bookingStatusStoppped:
        return 'Stopped';
      case bookingStatusCompleted:
        return 'Completed';
      case bookingStatusCancelledByClient:
        return 'Cancelled By You';
      case bookingStatusExpired:
        return 'Expired';
      case bookingStatusAwaiting:
        return 'Awaiting for your Approval';
      case bookingStatusCancelledByInspector:
        return 'Canecelled By Inspector';
      default:
        return 'Other';
    }
  }

  Color _statusColor(int? status) {
    switch (status) {
      case bookingStatusPending:
        return Colors.amber.shade700;
      case bookingStatusAccepted:
        return Colors.green.shade700;
      case bookingStatusRejected:
        return Colors.red.shade600;
      case bookingStatusStarted:
        return Colors.blue.shade600;
      case bookingStatusStoppped:
        return Colors.deepPurple.shade600;
      case bookingStatusCompleted:
        return Colors.teal.shade700;
      case bookingStatusCancelledByClient:
        return Colors.grey.shade700;
      case bookingStatusCancelledByInspector:
        return Colors.redAccent.shade200;
      case bookingStatusExpired:
        return Colors.grey.shade500;
      case bookingStatusAwaiting:
        return Colors.orange.shade600;
      default:
        return Colors.grey;
    }
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
                text: 'Filter & Sort Options',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const Divider(height: 24),

              ListTile(
                leading: const Icon(Icons.arrow_upward),
                title: textWidget(text: 'Sort by Date (Ascending)'),
                onTap: () {
                  provider.sortBookingsByDate(ascending: true);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_downward),
                title: textWidget(text: 'Sort by Date (Descending)'),
                onTap: () {
                  provider.sortBookingsByDate(ascending: false);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: textWidget(text: 'Clear All Filters'),
                onTap: () {
                  provider.clearFilters();
                  provider.fetchBookingsList(reset: true);
                  setState(() => selectedStatus = 'all');
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

  List<BookingListEntity> _getTodaysApprovedBookings(
    List<BookingListEntity> list,
  ) {
    final now = DateTime.now();

    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final todaysApproved = <BookingListEntity>[];

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

  DateTime _bookingDateTime(BookingListEntity b) {
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
