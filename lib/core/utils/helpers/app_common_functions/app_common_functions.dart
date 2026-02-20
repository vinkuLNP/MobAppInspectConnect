import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/pdf_viewer_screen.dart';
import 'package:intl/intl.dart';

void openPreview(
  BuildContext context, {
  required String pathOrUrl,
  required bool isImage,
  required bool isNetwork,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: isImage
              ? (isNetwork
                    ? Image.network(pathOrUrl)
                    : Image.file(File(pathOrUrl)))
              : PDFViewerScreen(url: pathOrUrl),
        ),
      ),
    ),
  );
}

bool isImage(String path) {
  final ext = path.split('.').last.toLowerCase();
  return imageExtensions.contains(ext);
}

Widget imageUploader({
  required BuildContext context,
  required List<File> files,
  required int maxFiles,
  required VoidCallback onAdd,
  required void Function(int index) onRemove,
  bool allowOnlyImages = false,
}) {
  final canAddMore = files.length < maxFiles;

  if (files.isEmpty) {
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.grey.shade50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo, color: Colors.grey, size: 30),
            const SizedBox(height: 8),
            textWidget(
              text: allowOnlyImages ? tapToUploadImage : tapToUploadFile,
              color: Colors.grey,
              fontSize: 12,
            ),
          ],
        ),
      ),
    );
  }

  final itemCount = canAddMore ? files.length + 1 : files.length;
  const crossAxisCount = 3;
  const spacing = 8.0;
  const itemHeight = 80.0;
  final rowCount = (itemCount / crossAxisCount).ceil();

  return SizedBox(
    height: rowCount * (itemHeight + spacing + 20),
    child: GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: 1,
      ),
      itemCount: itemCount,
      itemBuilder: (ctx, i) {
        if (i < files.length) {
          final file = files[i];
          final ext = file.path.split('.').last.toLowerCase();
          final isImage = imageExtensions.contains(ext);

          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () => openPreview(
                    context,
                    pathOrUrl: file.path,
                    isImage: isImage,
                    isNetwork:
                        file.path.startsWith(httpProtocol) ||
                        file.path.startsWith(httpsProtocol),
                  ),
                  child: Container(
                    color: Colors.grey.shade100,
                    child: isImage
                        ? _buildImageWidget(file)
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.insert_drive_file,
                                  size: 32,
                                  color: Colors.blueGrey,
                                ),
                                const SizedBox(height: 6),
                                textWidget(
                                  text: file.path.split('/').last,
                                  fontSize: 10,
                                  maxLine: 2,
                                  alignment: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: GestureDetector(
                    onTap: () => onRemove(i),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return GestureDetector(
            onTap: onAdd,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.grey.shade50,
              ),
              child: const Center(child: Icon(Icons.add_a_photo)),
            ),
          );
        }
      },
    ),
  );
}

Widget _buildImageWidget(File file) {
  final path = file.path;

  if (path.startsWith(httpProtocol) || path.startsWith(httpsProtocol)) {
    return Image.network(
      path,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, _, _) =>
          const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
    );
  }

  return Image.file(
    file,
    fit: BoxFit.cover,
    width: double.infinity,
    height: double.infinity,
    errorBuilder: (_, _, _) =>
        const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
  );
}

bool isToday(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}

bool isYesterday(DateTime date) {
  final yesterday = DateTime.now().subtract(const Duration(days: 1));
  return date.year == yesterday.year &&
      date.month == yesterday.month &&
      date.day == yesterday.day;
}

String groupLabel(DateTime date) {
  if (isToday(date)) return 'Today';
  if (isYesterday(date)) return 'Yesterday';
  return DateFormat('dd MMM yyyy').format(date);
}

double parseToDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

String formatMoney(double amount) {
  return "\$$amount";
}

String formatMoneyFromDynamic(dynamic value) {
  final double amount = parseToDouble(value);
  if (amount == 0) return "\$0.0";
  return formatMoney(amount);
}

String formatDateFlexible(
  dynamic date, {
  String dateFormat = 'MMM dd, yyyy',
  bool toLocal = true,
  String fallback = 'N/A',
}) {
  if (date == null) return fallback;

  try {
    DateTime parsed;

    if (date is DateTime) {
      parsed = date;
    } else if (date is String) {
      parsed = DateTime.parse(date);
    } else {
      return fallback;
    }

    final resultDate = toLocal ? parsed.toLocal() : parsed;
    return DateFormat(dateFormat).format(resultDate);
  } catch (_) {
    return fallback;
  }
}
