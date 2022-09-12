# current_gcp_project

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]
[![current_gcp_project](https://github.com/Morel-Tech/current_gcp_project/actions/workflows/current_gcp_project.yaml/badge.svg?event=push)](https://github.com/Morel-Tech/current_gcp_project/actions/workflows/current_gcp_project.yaml)

A helper to determine the current GCP project your code is running on.

## Usage

```dart
final projectId = await CurrentProjectId().currentProjectId();
```

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
