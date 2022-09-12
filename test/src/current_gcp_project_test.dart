// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:current_gcp_project/current_gcp_project.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform/platform.dart';
import 'package:test/test.dart';

class MockClient extends Mock implements Client {}

class MockResponse extends Mock implements Response {}

class MockUri extends Mock implements Uri {}

void main() {
  setUpAll(() {
    registerFallbackValue(MockUri());
  });

  group('CurrentGcpProject', () {
    test('can be instantiated', () {
      expect(CurrentGcpProject(), isNotNull);
    });
    group('currentProjectId', () {
      test('returns project if environment variable is set', () async {
        final platform = FakePlatform(
          environment: {'GCP_PROJECT': 'project-id'},
        );
        final projectId = await CurrentGcpProject().currentProjectId(
          platform: platform,
        );
        expect(projectId, 'project-id');
      });

      test('returns project id from metadata service if available', () async {
        final client = MockClient();
        final response = MockResponse();
        when(
          () => client.get(
            any(
              that: isA<Uri>().having(
                (uri) => uri.toString(),
                'uri',
                'http://metadata.google.internal/computeMetadata/v1/project/project-id',
              ),
            ),
            headers: any(
              named: 'headers',
              that: isA<Map<String, String>>().having(
                (headers) => headers['Metadata-Flavor'],
                'header',
                'Google',
              ),
            ),
          ),
        ).thenAnswer((_) async => response);
        when(() => response.body).thenReturn('project-id');
        when(() => response.statusCode).thenReturn(200);

        expect(
          await CurrentGcpProject().currentProjectId(
            injectedClient: client,
          ),
          'project-id',
        );
      });

      test('returns null from metadata service if request fails', () async {
        final client = MockClient();
        final response = MockResponse();
        when(() => client.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => response);
        when(() => response.statusCode).thenReturn(400);

        expect(
          await CurrentGcpProject().currentProjectId(
            injectedClient: client,
          ),
          null,
        );
      });
      test('returns null from if request throws SocketException', () async {
        final client = MockClient();
        when(() => client.get(any(), headers: any(named: 'headers')))
            .thenThrow(SocketException('oops'));

        expect(
          await CurrentGcpProject().currentProjectId(
            injectedClient: client,
          ),
          null,
        );
      });
    });
  });
}
