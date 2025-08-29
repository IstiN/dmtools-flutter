import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:dmtools_styleguide/widgets/molecules/file_attachment_picker.dart';
import '../golden_test_helper.dart' as helper;

void main() {
  setUpAll(() async {
    await helper.GoldenTestHelper.loadAppFonts();
  });

  group('File Attachment Picker Golden Tests', () {
    goldenTest(
      'File Attachment Picker - Light Mode',
      fileName: 'file_attachment_picker_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'file_attachment_picker_light',
            child: SizedBox(width: 400, height: 300, child: helper.createTestApp(_buildFileAttachmentPicker())),
          ),
        ],
      ),
    );

    goldenTest(
      'File Attachment Picker - Dark Mode',
      fileName: 'file_attachment_picker_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'file_attachment_picker_dark',
            child: SizedBox(
              width: 400,
              height: 300,
              child: helper.createTestApp(_buildFileAttachmentPicker(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'File Attachment Picker Empty - Light Mode',
      fileName: 'file_attachment_picker_empty_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'file_attachment_picker_empty_light',
            child: SizedBox(width: 300, height: 150, child: helper.createTestApp(_buildEmptyFileAttachmentPicker())),
          ),
        ],
      ),
    );

    goldenTest(
      'File Attachment Picker with Upload Progress - Light Mode',
      fileName: 'file_attachment_picker_uploading_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'file_attachment_picker_uploading_light',
            child: SizedBox(
              width: 400,
              height: 350,
              child: helper.createTestApp(_buildUploadingFileAttachmentPicker()),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _buildFileAttachmentPicker() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('File Attachment Picker with Files'),
          const SizedBox(height: 16),
          FileAttachmentPicker(
            attachments: [
              FileAttachment(
                name: 'main.dart',
                size: 2048,
                type: 'dart',
                bytes: const [],
                uploadedAt: DateTime(2024, 1, 15, 10, 30),
              ),
              FileAttachment(
                name: 'design_document.pdf',
                size: 1024 * 1024, // 1MB
                type: 'pdf',
                bytes: const [],
                uploadedAt: DateTime(2024, 1, 15, 10, 31),
              ),
              FileAttachment(
                name: 'screenshot.png',
                size: 512 * 1024, // 512KB
                type: 'png',
                bytes: const [],
                uploadedAt: DateTime(2024, 1, 15, 10, 32),
              ),
            ],
            onAttachmentsChanged: (attachments) {
              // Handle attachments change
            },
            onAttachmentPressed: () {
              // Handle attachment button press
            },
            isTestMode: true,
          ),
        ],
      ),
    ),
  );
}

Widget _buildEmptyFileAttachmentPicker() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('File Attachment Picker - Empty'),
          const SizedBox(height: 16),
          FileAttachmentPicker(
            attachments: const [],
            onAttachmentsChanged: (attachments) {
              // Handle attachments change
            },
            onAttachmentPressed: () {
              // Handle attachment button press
            },
            isTestMode: true,
          ),
        ],
      ),
    ),
  );
}

Widget _buildUploadingFileAttachmentPicker() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('File Attachment Picker - Uploading'),
          const SizedBox(height: 16),
          FileAttachmentPicker(
            attachments: [
              FileAttachment(
                name: 'uploading_file.txt',
                size: 1024,
                type: 'txt',
                bytes: const [],
                uploadedAt: DateTime(2024, 1, 15, 10, 30),
              ),
            ],
            onAttachmentsChanged: (attachments) {
              // Handle attachments change
            },
            onAttachmentPressed: () {
              // Handle attachment button press
            },
            isLoading: true,
            uploadProgress: 0.65,
            isTestMode: true,
          ),
        ],
      ),
    ),
  );
}
