import 'package:current_gcp_project/current_gcp_project.dart';

void main() async {
  final projectId = await CurrentProjectId().currentProjectId();
  // use projectId...
}
