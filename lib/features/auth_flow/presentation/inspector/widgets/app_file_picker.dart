import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';

class AppFilePickerGrid extends StatelessWidget {
  final List<File> files;
  final List<String> existingUrls;
  final int maxFiles;
  final Function(File file) onPick;
  final Function(int index) onRemoveFile;
  final Function(int index) onRemoveUrl;

  const AppFilePickerGrid({
    super.key,
    required this.files,
    required this.existingUrls,
    required this.onPick,
    required this.onRemoveFile,
    required this.onRemoveUrl,
    this.maxFiles = 4,
  });

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      onPick(File(result.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = files.length + existingUrls.length;
    final canAddMore = totalCount < maxFiles;

    if (totalCount == 0) {
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
        childAspectRatio: 3,
      ),
      itemCount: canAddMore ? totalCount + 1 : totalCount,
      itemBuilder: (context, index) {
        if (index < existingUrls.length) {
          final url = existingUrls[index];
          final name = url.split('/').last;

          return _documentTile(name: name, onDelete: () => onRemoveUrl(index));
        }

        final localIndex = index - existingUrls.length;
        if (localIndex < files.length) {
          final file = files[localIndex];
          final name = file.path.split('/').last;

          return _documentTile(
            name: name,
            onDelete: () => onRemoveFile(localIndex),
          );
        }

        return GestureDetector(onTap: _pickFile, child: _addMoreTile());
      },
    );
  }

  Widget _emptyUploadTile() {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
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
            textWidget(
              text: "Upload Document",
              color: Colors.grey,
              fontSize: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget _addMoreTile() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade50,
      ),
      child: const Center(
        child: Icon(Icons.upload_file, size: 28, color: Colors.grey),
      ),
    );
  }

  Widget _documentTile({required String name, required VoidCallback onDelete}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file, color: AppColors.authThemeColor),
          const SizedBox(width: 8),
          Expanded(
            child: textWidget(
              text: name,
              fontSize: 13,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.close, size: 18, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
