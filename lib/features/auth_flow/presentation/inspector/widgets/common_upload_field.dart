import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/field_upload_provider.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/pdf_viewer_screen.dart';
import 'package:provider/provider.dart';

class CommonUploadField extends StatelessWidget {
  final int maxFiles;
  final FileUploadProvider provider;

  const CommonUploadField({
    super.key,
    required this.maxFiles,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Consumer<FileUploadProvider>(
        builder: (_, prov, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (prov.files.isEmpty) _uploadBox(context, prov),

              if (prov.files.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: prov.files.length < maxFiles
                      ? prov.files.length + 1
                      : prov.files.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1.4,
                  ),
                  itemBuilder: (context, index) {
                    if (index < prov.files.length) {
                      final file = prov.files[index];

                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () => _openPreview(context, file),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: file.isImage
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        file.url,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    )
                                  :
                                    SizedBox(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.insert_drive_file,
                                            color: Colors.blueAccent,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: textWidget(
                                              text: file.name,
                                              fontSize: 13,
                                              textOverflow:
                                                  TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => prov.removeFile(index),
                              child: const CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.black54,
                                child: Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return _uploadBox(context, prov);
                  },
                ),

              if (prov.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    prov.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _uploadBox(BuildContext context, FileUploadProvider prov) {
    return GestureDetector(
      onTap: () async {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'pdf'],
        );

        if (result != null && result.files.single.path != null) {
          await prov.pickAndUploadFile(
            file: File(result.files.single.path!),
            maxFiles: maxFiles,
          );
        }
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Center(child: Icon(Icons.upload_file)),
      ),
    );
  }

  void _openPreview(BuildContext context, UploadedFileEntity file) {
    if (file.isImage) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(),
            body: Center(child: Image.network(file.url)),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PDFViewerScreen(url: file.url)),
      );
    }
  }
}
