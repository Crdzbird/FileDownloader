import 'dart:io';

import 'package:dio/dio.dart' hide ProgressCallback;
import 'package:file_downloader/core/downloader/downloader.dart';
import 'package:file_downloader/core/downloader/interfaces/progress_interface.dart';

class DownloaderUtils {
  final ProgressInterface progress;
  Dio? client;
  final File target;
  bool deleteOnCancel;
  final VoidCallback onDone;
  final ProgressCallback progressCallback;

  DownloaderUtils({
    required this.progress,
    this.client,
    required this.target,
    this.deleteOnCancel = false,
    required this.onDone,
    required this.progressCallback,
  });
}
