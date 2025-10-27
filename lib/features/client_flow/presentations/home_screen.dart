import 'package:flutter/material.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/common_app_bar.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/image_picker.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const int _prefetchDays = 60;

  List<DateTime> _generateDates() {
    final today = DateTime.now();
    final currentYearEnd = DateTime(today.year, 12, 31);
    final days = <DateTime>[];
    for (int i = 0; i < _prefetchDays; i++) {
      final d = today.add(Duration(days: i));
      if (d.isAfter(currentYearEnd)) break;
      days.add(d);
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final dates = _generateDates();

    return ChangeNotifierProvider(
      
      create: (_) {
         final prov = BookingProvider();
    prov.init(); // 👈 Automatically fetch certificate subtypes
    return prov;
      } ,
      
      child: Scaffold(
        appBar: CommonAppBar(title: 'Book Inspection', showLogo: true),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<BookingProvider>(
              builder: (context, prov, _) {
                final controller = ScrollController();
                final selectedIndex = dates.indexWhere(
                  (d) => _sameDate(d, prov.selectedDate),
                );

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (selectedIndex != -1 && controller.hasClients) {
                    controller.animateTo(
                      selectedIndex * 82.0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                    );
                  }
                });

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Select Date',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final today = DateTime.now();
                              final last = DateTime(today.year, 12, 31);
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: prov.selectedDate,
                                firstDate: today,
                                lastDate: last,
                              );
                              if (picked != null) {
                                prov.setDate(picked);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: const Icon(Icons.calendar_month),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          controller: controller,
                          scrollDirection: Axis.horizontal,
                          itemCount: dates.length,
                          itemBuilder: (ctx, i) {
                            final d = dates[i];
                            final isSelected = _sameDate(d, prov.selectedDate);
                            return GestureDetector(
                              onTap: () => prov.setDate(d),
                              child: Container(
                                width: 74,
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey.shade400,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _weekdayShort(d),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${d.day}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _monthShort(d),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isSelected
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Selected: ${prov.selectedDate.day} ${_monthShort(prov.selectedDate)} ${prov.selectedDate.year}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 20),

                      SelectTimeWidget(
                        initialTime: prov.selectedTime,
                        onTimeSelected: (t) => prov.setTime(t),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Inspection Type',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // DropdownButtonFormField<String>(
                      //   decoration: const InputDecoration(
                      //     border: OutlineInputBorder(),
                      //     hintText: 'Select inspection type',
                      //     enabledBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(color: Colors.grey),
                      //     ),
                      //   ),
                      //   value: prov.inspectionType,
                      //   items: const [
                      //     DropdownMenuItem(
                      //       value: 'Electrical',
                      //       child: Text('Electrical'),
                      //     ),
                      //     DropdownMenuItem(
                      //       value: 'Plumbing',
                      //       child: Text('Plumbing'),
                      //     ),
                      //     DropdownMenuItem(
                      //       value: 'Structural',
                      //       child: Text('Structural'),
                      //     ),
                      //     DropdownMenuItem(
                      //       value: 'Other',
                      //       child: Text('Other'),
                      //     ),
                      //   ],
                      //   onChanged: prov.setInspectionType,
                      // ),
                      Consumer<BookingProvider>(
                        builder: (context, prov, _) {
                          return prov.subTypes.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Select inspection type',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  value: prov.inspectionType,
                                  items: prov.subTypes.isNotEmpty
                                      ? prov.subTypes
                                            .map(
                                              (subType) =>
                                                  DropdownMenuItem<String>(
                                                    value: subType.id,
                                                    child: Text(subType.name),
                                                  ),
                                            )
                                            .toList()
                                      : [],
                                  onChanged: prov.setInspectionType,
                                );
                        },
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter location',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        onChanged: prov.setLocation,
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        maxLines: 4,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Add details...',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        onChanged: prov.setDescription,
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        'Upload Images (max 5)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                        itemCount: prov.images.length < 5
                            ? prov.images.length + 1
                            : 5,
                        itemBuilder: (ctx, i) {
                          if (i < prov.images.length) {
                            return Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      prov.images[i],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: GestureDetector(
                                    onTap: () => prov.removeImageAt(i),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return GestureDetector(
                            onTap: () => prov.uploadImage(ctx),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: const Center(
                                child: Icon(Icons.add_a_photo),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (!prov.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please fill all the required fields',
                                  ),
                                ),
                              );
                              return;
                            }

                            final dt = prov.selectedDate;
                            final t = prov.selectedTime!;
                            final scheduled = DateTime(
                              dt.year,
                              dt.month,
                              dt.day,
                              t.hour,
                              t.minute,
                            );

                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(content: Text('Booked for $scheduled')),
                            // );
                            prov.createBooking(context: context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Text('Confirm Booking'),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  bool _sameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _weekdayShort(DateTime d) {
    const names = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return names[d.weekday % 7];
  }

  String _monthShort(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[d.month - 1];
  }
}


