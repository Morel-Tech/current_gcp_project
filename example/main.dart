// ignore_for_file: unused_local_variable

import 'package:current_gcp_project/current_gcp_project.dart';

void main() async {
  final projectId = await const CurrentGcpProject().currentProjectId();
  // use projectId...
}
