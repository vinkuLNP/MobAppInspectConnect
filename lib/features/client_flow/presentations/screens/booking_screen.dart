import 'package:flutter/material.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/booking_list_entity.dart';
import 'package:intl/intl.dart';
import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/common_app_bar.dart';
import 'package:provider/provider.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  DateTime? _selectedDate;
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<BookingProvider>();
      provider.fetchBookingsList();
      _setupScrollListener(provider);
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

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
      context.read<BookingProvider>().searchBookingsByDate(
        DateFormat('dd-MM-yyyy').format(picked),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseResponsiveWidget(
      initializeConfig: false,
      buildWidget: (ctx, rc, app) {
        return Scaffold(
          appBar: const CommonAppBar(showLogo: true, title: 'Bookings'),
          backgroundColor: const Color(0xFFF8F9FA),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildFilterBar(context),
                const SizedBox(height: 12),
                Expanded(
                  child: Consumer<BookingProvider>(
                    builder: (context, provider, child) {
                      if (provider.isFetchingBookings &&
                          provider.bookings.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (provider.bookings.isEmpty) {
                        return const Center(
                          child: Text(
                            "No bookings found.",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async =>
                            provider.fetchBookingsList(reset: true),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount:
                              provider.bookings.length +
                              (provider.isLoadMoreRunning ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < provider.bookings.length) {
                              final BookingListEntity booking =
                                  provider.bookings[index];
                              return GestureDetector(
                                onTap: () =>
                                    _showBookingDetails(context, booking),
                                child: Card(
                                  elevation: 3,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                booking.bookingLocation ,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Chip(
                                              label: Text(
                                                _statusLabel(booking.status),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              backgroundColor: _statusColor(
                                                booking.status,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              size: 14,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              DateFormat('dd MMM yyyy').format(
                                                DateTime.parse(
                                                  booking.bookingDate,
                                                ),
                                              ),
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Icon(
                                              Icons.access_time,
                                              size: 14,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              booking.bookingTime ,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        if (booking.description != '' &&
                                            booking.description.isNotEmpty)
                                          Text(
                                            booking.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.black87,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        // 🔍 Search Field
        Expanded(
          child: TextField(
            controller: _searchController,
            cursorColor: primaryColor,
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search, color: primaryColor),
              suffixIcon: IconButton(
                icon: Icon(Icons.cancel, color: primaryColor),
                tooltip: "Clear",
                onPressed: () {
                  _searchController.clear();
                  context.read<BookingProvider>().clearFilters();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryColor, width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryColor, width: 1.8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onSubmitted: (value) {
              final query = value.trim();
              context.read<BookingProvider>().searchBookings(query);
            },
          ),
        ),

        // 📅 Date Filter
        IconButton(
          icon: Icon(Icons.date_range, color: primaryColor),
          tooltip: "Filter by date",
          onPressed: () => _pickDate(context),
        ),

        // ⚙️ Status Filter
        PopupMenuButton<String>(
          icon: Icon(Icons.filter_list, color: primaryColor),
          tooltip: "Filter by status",
          onSelected: (value) {
            setState(() => selectedStatus = value);
            context.read<BookingProvider>().filterByStatus(value);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: '0', child: Text('Pending')),
            const PopupMenuItem(value: '1', child: Text('Approved')),
            const PopupMenuItem(value: '2', child: Text('Rejected')),
          ],
        ),

        // ❌ Cancel Button
        TextButton(
          onPressed: () {
            setState(() {
              _selectedDate = null;
              selectedStatus = null;
              _searchController.clear();
            });
            context.read<BookingProvider>().clearFilters();
          },
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
          child: const Text("Cancel"),
        ),
      ],
    );
  }

  void _showBookingDetails(BuildContext context, BookingListEntity booking) {
    final isPending = booking.status == 0;
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
              Text(
                booking.bookingLocation ,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Date: ${DateFormat('dd MMM yyyy').format(DateTime.parse(booking.bookingDate))}",
              ),
              Text("Time: ${booking.bookingTime }"),
              const SizedBox(height: 12),
              Text("Description: ${booking.description }"),
              const SizedBox(height: 24),
              if (isPending) ...[
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<BookingProvider>().getBookingDetail(
                      context: context,
                      bookingId: booking.id,
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Booking'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _confirmDelete(context, booking);
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Booking'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ] else
                Center(
                  child: Text(
                    "Status: ${_statusLabel(booking.status)}",
                    style: TextStyle(
                      color: _statusColor(booking.status),
                      fontWeight: FontWeight.w600,
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
        title: const Text('Delete Booking?'),
        content: const Text('Are you sure you want to delete this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<BookingProvider>().deleteBookingDetail(
                context: context,
                bookingId: booking.id,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _statusLabel(int? status) {
    switch (status) {
      case 1:
        return 'Approved';
      case 2:
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  Color _statusColor(int? status) {
    switch (status) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}






