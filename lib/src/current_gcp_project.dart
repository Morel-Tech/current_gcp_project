import 'dart:io';

import 'package:http/http.dart';
import 'package:platform/platform.dart';

/// {@template current_gcp_project}
/// A helper to determine the current GCP project your code is running on
/// {@endtemplate}
class CurrentGcpProject {
  /// {@macro current_gcp_project}
  const CurrentGcpProject();

  /// Returns the current project ID if running on a Google Cloud Platform
  /// compute service.
  ///
  /// Returns null if none can be determined.
  Future<String?> currentProjectId({
    Platform platform = const LocalPlatform(),
    Client? injectedClient,
  }) async {
    final client = injectedClient ?? Client();
    for (final envKey in _gcpProjectIdEnvironmentVariables) {
      final value = platform.environment[envKey];
      if (value != null) return value;
    }

    final url = Uri.parse(
      'http://metadata.google.internal/computeMetadata/v1/project/project-id',
    );

    try {
      final response = await client.get(
        url,
        headers: {'Metadata-Flavor': 'Google'},
      );

      if (response.statusCode != 200) {
        return null;
      }

      return response.body;
    } on SocketException {
      return null;
    }
  }

  static const _gcpProjectIdEnvironmentVariables = {
    'GCP_PROJECT',
    'GCLOUD_PROJECT',
    'CLOUDSDK_CORE_PROJECT',
    'GOOGLE_CLOUD_PROJECT',
  };
}
