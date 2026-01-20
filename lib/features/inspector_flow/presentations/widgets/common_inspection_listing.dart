import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_assets_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/common_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/booking_list_entity.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';

class BaseInspectionListScreen extends StatefulWidget {
  final String title;
  final List<int> filterStatuses;
  final Widget Function(BuildContext, BookingListEntity)? bookingActionBuilder;
  final bool showAppBar;

  const BaseInspectionListScreen({
    super.key,
    required this.title,
    required this.filterStatuses,
    this.bookingActionBuilder,
    this.showAppBar = false,
  });

  @override
  State<BaseInspectionListScreen> createState() =>
      _BaseInspectionListScreenState();
}

class _BaseInspectionListScreenState extends State<BaseInspectionListScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animController;
  bool _isCardLoading = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<BookingProvider>();
      provider.resetBookings();
      provider.clearFilters(triggerFetch: false);
      provider.fetchBookingsList(reset: true);
      _setupScrollListener(provider);

      _animController.forward();
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
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: widget.showAppBar
          ? CommonAppBar(
              title: widget.title,
              showLogo: false,
              showBackButton: true,
            )
          : null,
      body: Stack(
        children: [
          Consumer<BookingProvider>(
            builder: (context, provider, _) {
              final filteredBookings =
                  provider.bookings
                      .where((b) => widget.filterStatuses.contains(b.status))
                      .toList()
                    ..sort((a, b) {
                      final now = DateTime.now();
                      final aDate = DateTime.parse(a.bookingDate);
                      final bDate = DateTime.parse(b.bookingDate);

                      final aIsPast = aDate.isBefore(now);
                      final bIsPast = bDate.isBefore(now);

                      if (aIsPast && !bIsPast) return 1;
                      if (!aIsPast && bIsPast) return -1;

                      return aDate.compareTo(bDate);
                    });

              if (provider.isFetchingBookings && filteredBookings.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (filteredBookings.isEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedScale(
                          scale: 1.05,
                          duration: const Duration(seconds: 2),
                          curve: Curves.easeInOut,
                          child: Image.asset(noBookingImg, width: 160),
                        ),

                        const SizedBox(height: 20),
                        Text(
                          "No bookings found",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Pull down to refresh or tap below",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 20),
                        AppButton(
                          text: "Refresh",
                          width: MediaQuery.of(context).size.width / 3,
                          iconLeftMargin: 10,
                          icon: const Icon(
                            Icons.refresh,
                            size: 20,
                            color: AppColors.backgroundColor,
                          ),

                          showIcon: true,
                          onTap: () {
                            final provider = context.read<BookingProvider>();
                            provider.fetchBookingsList(reset: true);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => provider.fetchBookingsList(reset: true),
                color: AppColors.authThemeColor,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  itemCount:
                      filteredBookings.length +
                      (provider.isLoadMoreRunning ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= filteredBookings.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final booking = filteredBookings[index];
                    final animation = CurvedAnimation(
                      parent: _animController,
                      curve: Interval(
                        (index / filteredBookings.length).clamp(0.0, 1.0),
                        1.0,
                        curve: Curves.easeOutCubic,
                      ),
                    );
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: animation.value,
                          child: Transform.translate(
                            offset: Offset(0, 30 * (1 - animation.value)),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          _buildBookingCard(context, booking),
                          index == filteredBookings.length - 1
                              ? SizedBox(height: 80)
                              : SizedBox.shrink(),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),

          if (_isCardLoading)
            Positioned(
              top: MediaQuery.of(context).size.height / 2.8,
              right: MediaQuery.of(context).size.width / 2 - 15,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, BookingListEntity booking) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () async {
        if (_isCardLoading) return;

        setState(() => _isCardLoading = true);
        final provider = context.read<BookingProvider>();

        try {
          await provider
              .getBookingDetail(
                context: context,
                bookingId: booking.id,
                isEditable: false,
                isInspectorView: true,
              )
              .then((_) async {
                await Future.delayed(const Duration(milliseconds: 200));
              });
        } catch (e) {
          log("Error fetching booking detail: $e");
        } finally {
          if (mounted) setState(() => _isCardLoading = false);
        }
      },
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.blueAccent.withValues(alpha: 0.1),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      booking.bookingLocation,
                      maxLines: 3,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                  if (booking.status != bookingStatusPending)
                    _buildStatusChip(booking.status),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat(
                      'EEE, dd MMM yyyy',
                    ).format(DateTime.parse(booking.bookingDate)),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.access_time_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    booking.bookingTime,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                booking.description.isNotEmpty
                    ? booking.description
                    : "No description provided",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[800],
                  height: 1.4,
                ),
              ),

              if (widget.bookingActionBuilder != null) ...[
                const SizedBox(height: 12),
                const Divider(height: 1, color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: widget.bookingActionBuilder!(context, booking),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(int? status) {
    final label = bookingStatusToText(status ?? -1);
    final color = statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(statusIcon(status ?? 1), size: 16, color: color),
          SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
