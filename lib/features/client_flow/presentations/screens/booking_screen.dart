// import 'package:flutter/material.dart';
// import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
// import 'package:inspect_connect/features/client_flow/domain/entities/booking_list_entity.dart';
// import 'package:intl/intl.dart';
// import 'package:inspect_connect/core/basecomponents/base_responsive_widget.dart';
// import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
// import 'package:inspect_connect/features/client_flow/presentations/widgets/common_app_bar.dart';
// import 'package:provider/provider.dart';

// class BookingsScreen extends StatefulWidget {
//   const BookingsScreen({super.key});

//   @override
//   State<BookingsScreen> createState() => _BookingsScreenState();
// }

// class _BookingsScreenState extends State<BookingsScreen> {
//   final ScrollController _scrollController = ScrollController();
//   final TextEditingController _searchController = TextEditingController();
//   DateTime? _selectedDate;
//   String? selectedStatus;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final provider = context.read<BookingProvider>();
//       provider.fetchBookingsList();
//       _setupScrollListener(provider);
//     });
//   }

//   void _setupScrollListener(BookingProvider provider) {
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//               _scrollController.position.maxScrollExtent - 200 &&
//           !provider.isLoadMoreRunning &&
//           provider.hasMoreBookings) {
//         provider.fetchBookingsList(loadMore: true);
//       }
//     });
//   }

//   Future<void> _pickDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2024),
//       lastDate: DateTime(2030),
//     );

//     if (picked != null) {
//       setState(() => _selectedDate = picked);
//       context.read<BookingProvider>().searchBookingsByDate(
//         DateFormat('dd-MM-yyyy').format(picked),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BaseResponsiveWidget(
//       initializeConfig: false,
//       buildWidget: (ctx, rc, app) {
//         return Scaffold(
//           appBar: const CommonAppBar(showLogo: true, title: 'Bookings'),
//           backgroundColor: Colors.grey[200],
//           body: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 _buildFilterBar(context),
//                 const SizedBox(height: 12),
//                 Expanded(
//                   child: Consumer<BookingProvider>(
//                     builder: (context, provider, child) {
//                       if (provider.isFetchingBookings &&
//                           provider.bookings.isEmpty) {
//                         return const Center(child: CircularProgressIndicator());
//                       }

//                       if (provider.bookings.isEmpty) {
//                         return Center(
//                           child: textWidget(
//                             text: "No bookings found.",
//                             fontSize: 16,
//                             color: Colors.grey,
//                           ),
//                         );
//                       }

//                       return RefreshIndicator(
//                         onRefresh: () async =>
//                             provider.fetchBookingsList(reset: true),
//                         child: ListView.builder(
//                           controller: _scrollController,
//                           itemCount:
//                               provider.bookings.length +
//                               (provider.isLoadMoreRunning ? 1 : 0),
//                           itemBuilder: (context, index) {
//                             if (index < provider.bookings.length) {
//                               final BookingListEntity booking =
//                                   provider.bookings[index];
//                               return GestureDetector(
//                                 onTap: () =>
//                                     _showBookingDetails(context, booking),
//                                 child: Card(
//                                   elevation: 3,
//                                   margin: const EdgeInsets.symmetric(
//                                     vertical: 8,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(16.0),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Expanded(
//                                               child: textWidget(
//                                                 text: booking.bookingLocation,
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                             ),
//                                             Chip(
//                                               label: textWidget(
//                                                 text: _statusLabel(
//                                                   booking.status,
//                                                 ),
//                                                 color: Colors.white,
//                                               ),
//                                               backgroundColor: _statusColor(
//                                                 booking.status,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 8),
//                                         Row(
//                                           children: [
//                                             Icon(
//                                               Icons.calendar_today,
//                                               size: 14,
//                                               color: Colors.grey[600],
//                                             ),
//                                             const SizedBox(width: 4),
//                                             textWidget(
//                                               text: DateFormat('dd MMM yyyy')
//                                                   .format(
//                                                     DateTime.parse(
//                                                       booking.bookingDate,
//                                                     ),
//                                                   ),
//                                               color: Colors.grey,
//                                             ),
//                                             const SizedBox(width: 12),
//                                             Icon(
//                                               Icons.access_time,
//                                               size: 14,
//                                               color: Colors.grey[600],
//                                             ),
//                                             const SizedBox(width: 4),
//                                             textWidget(
//                                               text: booking.bookingTime,
//                                               color: Colors.grey,
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 6),
//                                         if (booking.description != '' &&
//                                             booking.description.isNotEmpty)
//                                           textWidget(
//                                             text: booking.description,
//                                             maxLine: 2,
//                                             textOverflow: TextOverflow.ellipsis,
//                                             color: Colors.black87,
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             } else {
//                               return const Padding(
//                                 padding: EdgeInsets.all(16),
//                                 child: Center(
//                                   child: CircularProgressIndicator(),
//                                 ),
//                               );
//                             }
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildFilterBar(BuildContext context) {
//     final primaryColor = Theme.of(context).colorScheme.primary;

//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             controller: _searchController,
//             cursorColor: primaryColor,
//             decoration: InputDecoration(
//               hintText: 'Search',
//               prefixIcon: Icon(Icons.search, color: primaryColor),
//               suffixIcon: IconButton(
//                 icon: Icon(Icons.cancel, color: primaryColor),
//                 tooltip: "Clear",
//                 onPressed: () {
//                   _searchController.clear();
//                   context.read<BookingProvider>().clearFilters();
//                 },
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: primaryColor, width: 1.2),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: primaryColor, width: 1.8),
//               ),
//               filled: true,
//               fillColor: Colors.white,
//             ),
//             onSubmitted: (value) {
//               final query = value.trim();
//               context.read<BookingProvider>().searchBookings(query);
//             },
//           ),
//         ),

//         IconButton(
//           icon: Icon(Icons.date_range, color: primaryColor),
//           tooltip: "Filter by date",
//           onPressed: () => _pickDate(context),
//         ),

//         PopupMenuButton<String>(
//           icon: Icon(Icons.filter_list, color: primaryColor),
//           tooltip: "Filter by status",
//           onSelected: (value) {
//             setState(() => selectedStatus = value);
//             context.read<BookingProvider>().filterByStatus(value);
//           },
//           itemBuilder: (context) => [
//             PopupMenuItem(
//               value: '0',
//               child: textWidget(text: 'Pending'),
//             ),
//             PopupMenuItem(
//               value: '1',
//               child: textWidget(text: 'Approved'),
//             ),
//             PopupMenuItem(
//               value: '2',
//               child: textWidget(text: 'Rejected'),
//             ),
//           ],
//         ),

//         TextButton(
//           onPressed: () {
//             setState(() {
//               _selectedDate = null;
//               selectedStatus = null;
//               _searchController.clear();
//             });
//             context.read<BookingProvider>().clearFilters();
//           },
//           style: TextButton.styleFrom(
//             foregroundColor: primaryColor,
//             textStyle: const TextStyle(fontWeight: FontWeight.w600),
//           ),
//           child: textWidget(text: "Cancel"),
//         ),
//       ],
//     );
//   }

//   void _showBookingDetails(BuildContext context, BookingListEntity booking) {
//     final isPending = booking.status == 0;
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) {
//         return Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: ListView(
//             shrinkWrap: true,
//             children: [
//               Center(
//                 child: Container(
//                   height: 4,
//                   width: 40,
//                   margin: const EdgeInsets.only(bottom: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[400],
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//               textWidget(
//                 text: booking.bookingLocation,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//               const SizedBox(height: 12),
//               textWidget(
//                 text:
//                     "Date: ${DateFormat('dd MMM yyyy').format(DateTime.parse(booking.bookingDate))}",
//               ),
//               textWidget(text: "Time: ${booking.bookingTime}"),
//               const SizedBox(height: 12),
//               textWidget(text: "Description: ${booking.description}"),
//               const SizedBox(height: 24),
//               if (isPending) ...[
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     context.read<BookingProvider>().getBookingDetail(
//                       context: context,
//                       bookingId: booking.id,
//                     );
//                   },
//                   icon: const Icon(Icons.edit),
//                   label: textWidget(text: 'Edit Booking'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Theme.of(context).colorScheme.primary,
//                     minimumSize: const Size(double.infinity, 48),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     _confirmDelete(context, booking);
//                   },
//                   icon: const Icon(Icons.delete),
//                   label: textWidget(text: 'Delete Booking'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent,
//                     minimumSize: const Size(double.infinity, 48),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//               ] else
//                 Center(
//                   child: textWidget(
//                     text: "Status: ${_statusLabel(booking.status)}",
//                     color: _statusColor(booking.status),
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _confirmDelete(BuildContext context, BookingListEntity booking) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: textWidget(text: 'Delete Booking?'),
//         content: textWidget(
//           text: 'Are you sure you want to delete this booking?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: textWidget(text: 'Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               context.read<BookingProvider>().deleteBookingDetail(
//                 context: context,
//                 bookingId: booking.id,
//               );
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
//             child: textWidget(text: 'Delete'),
//           ),
//         ],
//       ),
//     );
//   }

//   String _statusLabel(int? status) {
//     switch (status) {
//       case 1:
//         return 'Approved';
//       case 2:
//         return 'Rejected';
//       default:
//         return 'Pending';
//     }
//   }

//   Color _statusColor(int? status) {
//     switch (status) {
//       case 1:
//         return Colors.green;
//       case 2:
//         return Colors.red;
//       default:
//         return Colors.orange;
//     }
//   }
// }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<BookingProvider>();
      setState(() {
        selectedStatus = 'all';
        provider.isFetchingBookings = true;
        provider.clearFilters();
        provider.fetchBookingsList(reset: true);
      });
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _statusOptions = [
    {'label': 'All', 'value': 'all'},
    {'label': 'Pending', 'value': '0'},
    {'label': 'Approved', 'value': '1'},
    {'label': 'Rejected', 'value': '2'},
  ];

  @override
  Widget build(BuildContext context) {
    return BaseResponsiveWidget(
      initializeConfig: true,
      buildWidget: (ctx, rc, app) {
        return Scaffold(
          appBar: const CommonAppBar(showLogo: true, title: 'Bookings'),
          backgroundColor: Colors.grey[100],
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildFilterChips(context),
                const SizedBox(height: 16),
                Expanded(
                  child: Consumer<BookingProvider>(
                    builder: (context, provider, child) {
                      if (provider.isFetchingBookings &&
                          provider.bookings.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!provider.isFetchingBookings &&
                          provider.bookings.isEmpty) {
                        return Center(
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
                              ElevatedButton(
                                onPressed: () {
                                  if (widget.onBookNowTapped != null) {
                                    setState(() {
                                      selectedStatus = 'all';
                                      provider.isFetchingBookings = true;
                                      provider.clearFilters();
                                      provider.fetchBookingsList(reset: true);
                                    });
                                    widget.onBookNowTapped!();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  minimumSize: const Size(150, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: textWidget(
                                  text: 'Book Now',
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async =>
                            provider.fetchBookingsList(reset: true),
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount:
                              provider.bookings.length +
                              (provider.isLoadMoreRunning ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < provider.bookings.length) {
                              final booking = provider.bookings[index];
                              return _buildBookingCard(context, booking);
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

  Widget _buildFilterChips(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Wrap(
      spacing: 3,
      runSpacing: 2,
      children: _statusOptions.map((option) {
        final isSelected = selectedStatus == option['value'];
        return ChoiceChip(
          label: textWidget(
            text: option['label'],
            color: isSelected ? Colors.white : Colors.grey[700]!,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
          selected: isSelected,
          selectedColor: primary,
          backgroundColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: isSelected ? 2 : 0,
          onSelected: (selected) {
            setState(() => selectedStatus = option['value']);
            final provider = context.read<BookingProvider>();

            if (option['value'] == 'all') {
              provider.isFetchingBookings = true;
              provider.clearFilters();
              provider.fetchBookingsList(reset: true);
              log('---option[value]------>${option['value']}');
            } else {
              provider.filterByStatus(option['value']);
            }
          },
        );
      }).toList(),
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
              color: Colors.grey.withOpacity(0.15),
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
                    textWidget(
                      text: booking.bookingLocation,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 6),
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
                    const SizedBox(height: 6),
                    textWidget(
                      text: booking.description.isNotEmpty
                          ? booking.description
                          : "No description provided",
                      fontSize: 12,

                      color: Colors.grey[800]!,
                      maxLine: 2,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Chip(
                label: textWidget(
                  text: _statusLabel(booking.status),
                  color: Colors.white,
                  fontSize: 12,
                ),
                backgroundColor: color,
              ),
            ],
          ),
        ),
      ),
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
              if (isPending) ...[
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<BookingProvider>().getBookingDetail(
                      context: context,
                      bookingId: booking.id,
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: textWidget(text: 'Edit Booking'),
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
                  label: textWidget(text: 'Delete Booking'),
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
                  child: textWidget(
                    text: "Status: ${_statusLabel(booking.status)}",
                    color: _statusColor(booking.status),
                    fontWeight: FontWeight.w600,
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
        return Colors.green.shade600;
      case 2:
        return Colors.redAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  void _showSortFilterSheet(BuildContext context) {
    final provider = context.read<BookingProvider>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Divider(
                  height: 4,
                  thickness: 4,
                  color: Colors.grey,
                  indent: 150,
                  endIndent: 150,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.date_range),
                title: const Text('Sort by Date Ascending'),
                onTap: () {
                  provider.sortBookingsByDate(ascending: true);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.date_range),
                title: const Text('Sort by Date Descending'),
                onTap: () {
                  provider.sortBookingsByDate(ascending: false);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.clear_all),
                title: const Text('Clear Filters'),
                onTap: () {
                  provider.clearFilters();
                  provider.fetchBookingsList(reset: true);
                  setState(() => selectedStatus = 'all');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //   Widget _buildFilterChips(BuildContext context) {
  //   final primary = Theme.of(context).colorScheme.primary;

  //   return Row(
  //     children: [
  //       Expanded(
  //         child: Wrap(
  //           spacing: 3,
  //           runSpacing: 2,
  //           children: _statusOptions.map((option) {
  //             final isSelected = selectedStatus == option['value'];
  //             return ChoiceChip(
  //               label: textWidget(
  //                 text: option['label'],
  //                 color: isSelected ? Colors.white : Colors.grey[700]!,
  //                 fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
  //               ),
  //               selected: isSelected,
  //               selectedColor: primary,
  //               backgroundColor: Colors.grey[200],
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               elevation: isSelected ? 2 : 0,
  //               onSelected: (selected) {
  //                 setState(() => selectedStatus = option['value']);
  //                 final provider = context.read<BookingProvider>();

  //                 if (option['value'] == 'all') {
  //                   provider.clearFilters();
  //                   provider.fetchBookingsList(reset: true);
  //                   log('---option[value]------>${option['value']}');
  //                 } else {
  //                   provider.filterByStatus(option['value']);
  //                 }
  //               },
  //             );
  //           }).toList(),
  //         ),
  //       ),
  //       IconButton(
  //         icon: const Icon(Icons.filter_list),
  //         onPressed: () => _showSortFilterSheet(context),
  //       ),
  //     ],
  //   );
  // }

  // }
}
