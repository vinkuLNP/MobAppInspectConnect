import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/pdf_viewer_screen.dart';
import 'package:intl/intl.dart';

void openPreview(
  BuildContext context, {
  required String pathOrUrl,
  required bool isImage,
}) {
  final bool isNetwork =
      pathOrUrl.startsWith(httpProtocol) || pathOrUrl.startsWith(httpsProtocol);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: textWidget(
            text: pathOrUrl.split('/').last,
            color: AppColors.whiteColor,
          ),
        ),
        body: Center(
          child: isImage
              ? (isNetwork
                    ? Image.network(pathOrUrl)
                    : Image.file(File(pathOrUrl)))
              : PDFViewerScreen(path: pathOrUrl, isNetwork: isNetwork),
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

  List<String> existingUrls = const [],
  void Function(int index)? onRemoveExisting,

  bool allowOnlyImages = false,
}) {
  final totalItems = files.length + existingUrls.length;
  final canAddMore = totalItems < maxFiles;

  if (totalItems == 0) {
    return emptyUploadTile(onTap: onAdd);
  }

  final itemCount = canAddMore ? totalItems + 1 : totalItems;

  return gridBuilder(
    itemCount: itemCount,
    itemBuilder: (ctx, i) {
      if (i < existingUrls.length) {
        final url = existingUrls[i];
        final isImg = isImage(url);

        return _uploadTile(
          context: context,
          child: isImg ? buildNetworkImage(url) : fileIcon(url),
          onTap: () {
            openPreview(context, pathOrUrl: url, isImage: isImg);
          },
          onRemove: onRemoveExisting == null ? null : () => onRemoveExisting(i),
        );
      }

      final fileIndex = i - existingUrls.length;
      if (fileIndex < files.length) {
        final file = files[fileIndex];
        final isImg = isImage(file.path);

        return _uploadTile(
          context: context,
          child: isImg ? _buildImageWidget(file) : fileIcon(file.path),
          onTap: () {
            openPreview(context, pathOrUrl: file.path, isImage: isImg);
          },
          onRemove: () => onRemove(fileIndex),
        );
      }

      return addMoreTile(onTap: onAdd);
    },
  );
}

Widget addMoreTile({required Function() onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade50,
      ),
      child: const Center(child: Icon(Icons.upload_file, color: Colors.grey)),
    ),
  );
}

Widget gridBuilder({
  required Widget? Function(BuildContext, int) itemBuilder,
  required int itemCount,
}) {
  return GridView.builder(
    padding: EdgeInsets.zero,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.6,
    ),
    itemCount: itemCount,
    itemBuilder: itemBuilder,
  );
}

Widget emptyUploadTile({required Function() onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade50,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.upload_file, size: 32, color: Colors.grey),
          const SizedBox(height: 8),
          textWidget(text: uploadDocument, color: Colors.grey, fontSize: 12),
        ],
      ),
    ),
  );
}

Widget buildLocalImage(File file) {
  return Image.file(
    file,
    fit: BoxFit.cover,
    width: double.infinity,
    height: double.infinity,
    errorBuilder: (_, _, _) =>
        const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
  );
}

Widget buildNetworkImage(String url) {
  return Image.network(
    url,
    fit: BoxFit.cover,
    width: double.infinity,
    height: double.infinity,
    errorBuilder: (_, _, _) =>
        const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
    loadingBuilder: (c, w, p) {
      if (p == null) return w;
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    },
  );
}

Widget _uploadTile({
  required BuildContext context,
  required Widget child,
  required VoidCallback onTap,
  VoidCallback? onRemove,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(color: Colors.grey.shade100, child: child),
        ),
        if (onRemove != null) removeFileWidget(onRemove: onRemove),
      ],
    ),
  );
}

Widget removeFileWidget({required Function() onRemove}) {
  return Positioned(
    top: 4,
    right: 4,
    child: GestureDetector(
      onTap: onRemove,
      child: const CircleAvatar(
        radius: 12,
        backgroundColor: Colors.black54,
        child: Icon(Icons.close, size: 16, color: Colors.white),
      ),
    ),
  );
}

Widget fileIcon(String path) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.insert_drive_file, size: 30, color: Colors.blueGrey),
        const SizedBox(height: 6),
        textWidget(
          text: path.contains('/') ? path.split('/').last : path,
          fontSize: 10,
          maxLine: 3,
          alignment: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget _buildImageWidget(File file) {
  final path = file.path;

  if (path.startsWith(httpProtocol) || path.startsWith(httpsProtocol)) {
    return buildNetworkImage(path);
  }

  return buildLocalImage(file);
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
