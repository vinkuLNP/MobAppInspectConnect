import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';

class CommonDocumentGrid extends StatelessWidget {
  final List<File> localFiles;
  final List<String> networkUrls;
  final int maxFiles;
  final VoidCallback? onAddTap;
  final Function(int index)? onRemoveLocal;
  final Function(int index)? onRemoveNetwork;
  final Function(int index, bool isNetwork)? onPreview;
  final double childAspectRatio;
  final String uplodeTypeText;
  const CommonDocumentGrid({
    super.key,
    required this.localFiles,
    required this.networkUrls,
    this.maxFiles = 4,
    this.onAddTap,
    this.onRemoveLocal,
    this.onRemoveNetwork,
    this.onPreview,
    this.childAspectRatio = 1.6,
    this.uplodeTypeText = uploadDocument,
  });

  bool _isImage(String path) {
    final ext = path.split('.').last.toLowerCase();
    return imageExtensions.contains(ext);
  }

  Widget _buildLocalImage(File file) {
    return Image.file(
      file,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) =>
          const Center(child: Icon(Icons.broken_image)),
    );
  }

  Widget _buildNetworkImage(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (c, w, p) {
        if (p == null) return w;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
      errorBuilder: (_, __, ___) =>
          const Center(child: Icon(Icons.broken_image)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = localFiles.length + networkUrls.length;
    final canAddMore = totalItems < maxFiles;

    if (totalItems == 0) {
      return GestureDetector(onTap: onAddTap, child: _addBox());
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: canAddMore ? totalItems + 1 : totalItems,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        // NETWORK FILES FIRST
        if (index < networkUrls.length) {
          final url = networkUrls[index];

          return GestureDetector(
            onTap: () => onPreview?.call(index, true),
            child: _isImage(url)
                ? _imageTile(
                    child: _buildNetworkImage(url),
                    onDelete: () => onRemoveNetwork?.call(index),
                  )
                : _documentTile(
                    name: url.split('/').last,
                    onDelete: () => onRemoveNetwork?.call(index),
                  ),
          );
        }

        // LOCAL FILES
        final localIndex = index - networkUrls.length;

        if (localIndex < localFiles.length) {
          final file = localFiles[localIndex];

          return GestureDetector(
            onTap: () => onPreview?.call(localIndex, false),
            child: _isImage(file.path)
                ? _imageTile(
                    child: _buildLocalImage(file),
                    onDelete: () => onRemoveLocal?.call(localIndex),
                  )
                : _documentTile(
                    name: file.path.split('/').last,
                    onDelete: () => onRemoveLocal?.call(localIndex),
                  ),
          );
        }

        // ADD BOX
        return GestureDetector(onTap: onAddTap, child: _addBox());
      },
    );
  }

  Widget _addBox() {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade50,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.upload_file, size: 28, color: Colors.grey),
          const SizedBox(height: 8),
          textWidget(text: uplodeTypeText, color: Colors.grey, fontSize: 12),
        ],
      ),
    );
  }

  Widget _imageTile({required Widget child, required VoidCallback? onDelete}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Container(color: Colors.grey.shade100, child: child),
          if (onDelete != null)
            Positioned(top: 4, right: 4, child: _deleteButton(onDelete)),
        ],
      ),
    );
  }

  Widget _documentTile({required String name, VoidCallback? onDelete}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                const Icon(Icons.insert_drive_file, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(name, overflow: TextOverflow.clip, maxLines: 2),
                ),
              ],
            ),
          ),
          if (onDelete != null)
            Positioned(top: 4, right: 4, child: _deleteButton(onDelete)),
        ],
      ),
    );
  }

  Widget _deleteButton(VoidCallback onDelete) {
    return GestureDetector(
      onTap: onDelete,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, color: Colors.white, size: 16),
      ),
    );
  }
}
