import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/helpers/app_common_functions/app_common_functions.dart';
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
    return isImage(path);
  }

  String _docPath(IccUiDocument doc) => doc.localFile?.path ?? doc.uploadedUrl!;

  Widget _buildPreview(IccUiDocument doc) {
    if (doc.localFile != null) {
      return buildLocalImage(doc.localFile!);
    }

    if (doc.uploadedUrl != null && _isImageDoc(doc)) {
      return buildNetworkImage(doc.uploadedUrl!);
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
      return emptyUploadTile(onTap: _pickFile);
    }

    return gridBuilder(
      itemCount: canAddMore ? documents.length + 1 : documents.length,
      itemBuilder: (context, index) {
        if (index == documents.length && canAddMore) {
          return addMoreTile(onTap: _pickFile);
        }

        final doc = documents[index];
        return _docCard(context, doc, index);
      },
    );
  }

  Widget _docCard(BuildContext context, IccUiDocument doc, int index) {
    final hasExpiry = doc.expiryDate != null;
    final isImg = _isImageDoc(doc);
    final path = _docPath(doc);

    if (isImg) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () =>
                    openPreview(context, pathOrUrl: path, isImage: true),
                child: _buildPreview(doc),
              ),
            ),

            removeFileWidget(onRemove: () => onRemove(index)),

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
    final path = _docPath(doc);

    return Stack(
      children: [
        GestureDetector(
          onTap: () => openPreview(context, pathOrUrl: path, isImage: false),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: hasExpiry ? Colors.green : Colors.red),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                fileIcon(doc.fileName),
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
          ),
        ),
        removeFileWidget(onRemove: () => onRemove(index)),
      ],
    );
  }
}
