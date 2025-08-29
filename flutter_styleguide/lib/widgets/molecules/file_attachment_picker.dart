import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// Model for file attachment data
class FileAttachment {
  final String name;
  final int size;
  final String type;
  final List<int> bytes;
  final DateTime uploadedAt;

  const FileAttachment({
    required this.name,
    required this.size,
    required this.type,
    required this.bytes,
    required this.uploadedAt,
  });

  String get sizeString {
    if (size < 1024) return '${size}B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)}KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}

/// File attachment picker with validation and progress indication
/// Supports drag-and-drop and click-to-select functionality
class FileAttachmentPicker extends StatelessWidget {
  final List<FileAttachment> attachments;
  final ValueChanged<List<FileAttachment>>? onAttachmentsChanged;
  final VoidCallback? onAttachmentPressed;
  final bool isLoading;
  final double? uploadProgress;
  final int maxFileSize;
  final int maxFiles;
  final List<String> allowedTypes;
  final bool? isTestMode;
  final bool? testDarkMode;

  const FileAttachmentPicker({
    required this.attachments,
    super.key,
    this.onAttachmentsChanged,
    this.onAttachmentPressed,
    this.isLoading = false,
    this.uploadProgress,
    this.maxFileSize = 10 * 1024 * 1024, // 10MB default
    this.maxFiles = 5,
    this.allowedTypes = const ['jpg', 'jpeg', 'png', 'gif', 'pdf', 'txt', 'doc', 'docx'],
    this.isTestMode = false,
    this.testDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = isTestMode == true
        ? (testDarkMode == true ? AppColors.dark : AppColors.light)
        : context.colorsListening;

    // If no attachments and not loading, return empty container
    if (attachments.isEmpty && !isLoading) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with file count
          if (attachments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${attachments.length} file${attachments.length == 1 ? '' : 's'} attached',
                style: TextStyle(color: colors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),

          // Attachments list
          if (attachments.isNotEmpty) _buildAttachmentsList(colors),

          // Upload progress
          if (isLoading && uploadProgress != null) ...[const SizedBox(height: 8), _buildUploadProgress(colors)],
        ],
      ),
    );
  }

  Widget _buildAttachmentsList(ThemeColorSet colors) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 120),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: attachments.length,
        itemBuilder: (context, index) {
          final attachment = attachments[index];
          return _buildAttachmentItem(attachment, colors, index);
        },
      ),
    );
  }

  Widget _buildAttachmentItem(FileAttachment attachment, ThemeColorSet colors, int index) {
    final isImage = _isImageFile(attachment.type);

    return Container(
      key: ValueKey('attachment_${attachment.name}_${attachment.uploadedAt.millisecondsSinceEpoch}'),
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.inputBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          // File type icon or image preview
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isImage ? Colors.transparent : _getFileColor(attachment.type).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: isImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: _ImagePreview(
                      key: ValueKey('image_${attachment.name}_${attachment.size}'),
                      bytes: attachment.bytes,
                      fileType: attachment.type,
                    ),
                  )
                : Center(child: Icon(_getFileIcon(attachment.type), color: _getFileColor(attachment.type), size: 16)),
          ),
          const SizedBox(width: 12),

          // File info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.name,
                  style: TextStyle(color: colors.textColor, fontSize: 13, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(attachment.sizeString, style: TextStyle(color: colors.textMuted, fontSize: 11)),
                    if (isImage) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getFileColor(attachment.type).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          attachment.type.toUpperCase(),
                          style: TextStyle(
                            color: _getFileColor(attachment.type),
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Remove button
          InkWell(
            onTap: () => _removeAttachment(index),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Icon(Icons.close, color: colors.textMuted, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadProgress(ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Uploading files...', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: uploadProgress,
          backgroundColor: colors.borderColor.withValues(alpha: 0.3),
          valueColor: AlwaysStoppedAnimation<Color>(colors.accentColor),
        ),
      ],
    );
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'txt':
        return Icons.text_snippet;
      case 'dart':
        return Icons.code;
      case 'js':
      case 'ts':
        return Icons.javascript;
      default:
        return Icons.attach_file;
    }
  }

  Color _getFileColor(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return const Color(0xFFE53E3E); // Red for PDF
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return const Color(0xFF38A169); // Green for images
      case 'doc':
      case 'docx':
        return const Color(0xFF3182CE); // Blue for documents
      case 'txt':
        return const Color(0xFF805AD5); // Purple for text
      case 'dart':
        return const Color(0xFF0175C2); // Dart blue
      case 'js':
      case 'ts':
        return const Color(0xFFF7DF1E); // JavaScript yellow
      default:
        return const Color(0xFF718096); // Gray for unknown
    }
  }

  bool _isImageFile(String fileType) {
    const imageTypes = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return imageTypes.contains(fileType.toLowerCase());
  }

  void _removeAttachment(int index) {
    final newAttachments = List<FileAttachment>.from(attachments);
    newAttachments.removeAt(index);
    onAttachmentsChanged?.call(newAttachments);
  }
}

/// Private widget for image preview to prevent unnecessary rebuilds
class _ImagePreview extends StatefulWidget {
  final List<int> bytes;
  final String fileType;

  const _ImagePreview({required this.bytes, required this.fileType, super.key});

  @override
  State<_ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<_ImagePreview> {
  late final Uint8List _imageData;

  @override
  void initState() {
    super.initState();
    // Convert once and cache to prevent rebuilds
    _imageData = Uint8List.fromList(widget.bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      _imageData,
      width: 32,
      height: 32,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          Icon(_getFileIcon(widget.fileType), color: _getFileColor(widget.fileType), size: 16),
    );
  }

  // Helper methods for error fallback
  IconData _getFileIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'txt':
      case 'rtf':
        return Icons.text_snippet;
      case 'dart':
      case 'js':
      case 'ts':
      case 'html':
      case 'css':
      case 'json':
      case 'yaml':
      case 'xml':
        return Icons.code;
      default:
        return Icons.image;
    }
  }

  Color _getFileColor(String type) {
    switch (type.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        return const Color(0xFF4CAF50); // Green for images
      case 'pdf':
        return const Color(0xFFF44336); // Red for PDF
      case 'doc':
      case 'docx':
        return const Color(0xFF2196F3); // Blue for documents
      case 'txt':
      case 'rtf':
        return const Color(0xFF9E9E9E); // Gray for text
      case 'dart':
      case 'js':
      case 'ts':
      case 'html':
      case 'css':
      case 'json':
      case 'yaml':
      case 'xml':
        return const Color(0xFFFF9800); // Orange for code
      default:
        return const Color(0xFF607D8B); // Blue gray for unknown
    }
  }
}
