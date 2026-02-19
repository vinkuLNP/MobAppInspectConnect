import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/data/models/ui_icc_document.dart';

class AppFilePickerGrid extends StatelessWidget {
  final List<IccUiDocument> documents;
  final int maxFiles;
  final Function(File) onPick;
  final Function(int) onRemove;
  final Function(int, DateTime) onPickExpiry;

  const AppFilePickerGrid({
    super.key,
    required this.documents,
    required this.onPick,
    required this.onRemove,
    required this.onPickExpiry,
    this.maxFiles = 4,
  });
  bool _isImageDoc(IccUiDocument doc) {
    final path = doc.localFile?.path ?? doc.uploadedUrl ?? '';
    final ext = path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'webp', 'gif'].contains(ext);
  }

  Widget _buildPreview(IccUiDocument doc) {
    if (doc.localFile != null) {
      return Image.file(
        doc.localFile!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) =>
            const Icon(Icons.broken_image, color: Colors.grey),
      );
    }

    if (doc.uploadedUrl != null && _isImageDoc(doc)) {
      return Image.network(
        doc.uploadedUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) =>
            const Icon(Icons.broken_image, color: Colors.grey),
      );
    }

    return const Center(
      child: Icon(Icons.insert_drive_file, size: 32, color: Colors.grey),
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: mixedExtensions,
    );

    if (result != null && result.files.single.path != null) {
      onPick(File(result.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final canAddMore = documents.length < maxFiles;

    if (documents.isEmpty) {
      return _emptyUploadTile();
    }

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
      itemCount: canAddMore ? documents.length + 1 : documents.length,
      itemBuilder: (context, index) {
        if (index == documents.length && canAddMore) {
          return GestureDetector(onTap: _pickFile, child: _addMoreTile());
        }

        final doc = documents[index];
        return _docCard(context, doc, index);
      },
    );
  }

  Widget _emptyUploadTile() {
    return GestureDetector(
      onTap: _pickFile,
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

  Widget _addMoreTile() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade50,
      ),
      child: const Center(
        child: Icon(Icons.upload_file, size: 28, color: Colors.grey),
      ),
    );
  }

  Widget _docCard(BuildContext context, IccUiDocument doc, int index) {
    final hasExpiry = doc.expiryDate != null;
    final isImg = _isImageDoc(doc);

    if (isImg) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            Positioned.fill(child: _buildPreview(doc)),

            Positioned(
              top: 6,
              right: 6,
              child: GestureDetector(
                onTap: () => onRemove(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),

            Positioned(
              bottom: 6,
              left: 6,
              right: 6,
              child: GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now().add(const Duration(days: 30)),
                    lastDate: DateTime(2100),
                    initialDate:
                        doc.expiryDate ??
                        DateTime.now().add(const Duration(days: 30)),
                  );
                  if (date != null) {
                    onPickExpiry(index, date);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: textWidget(
                    text: hasExpiry
                        ? '$expiryTxt: ${doc.expiryDate!.toIso8601String().split("T").first}'
                        : '$selectExpiryDate *',
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return _fileTile(context, doc, index);
  }

  Widget _fileTile(BuildContext context, IccUiDocument doc, int index) {
    final hasExpiry = doc.expiryDate != null;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: hasExpiry ? Colors.green : Colors.red),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.insert_drive_file,
                color: AppColors.authThemeColor,
                size: 18,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: textWidget(
                  text: doc.fileName,
                  fontSize: 12,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () => onRemove(index),
                child: const Icon(Icons.close, size: 16, color: Colors.red),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                firstDate: DateTime.now().add(const Duration(days: 30)),
                lastDate: DateTime(2100),
                initialDate:
                    doc.expiryDate ??
                    DateTime.now().add(const Duration(days: 30)),
              );
              if (date != null) {
                onPickExpiry(index, date);
              }
            },
            child: textWidget(
              text: hasExpiry
                  ? '$expiryTxt: ${doc.expiryDate!.toIso8601String().split("T").first}'
                  : '$selectExpiryDate *',
              fontSize: 11,
              color: hasExpiry ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
