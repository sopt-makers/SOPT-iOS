fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios set_version_demo

```sh
[bundle exec] fastlane ios set_version_demo
```

Set Marketing and Build version

### ios upload_testflight_demo

```sh
[bundle exec] fastlane ios upload_testflight_demo
```

Demo App Testflight Upload

### ios set_version

```sh
[bundle exec] fastlane ios set_version
```

Set Marketing and Build version

### ios upload_testflight

```sh
[bundle exec] fastlane ios upload_testflight
```

Prod App Testflight Upload

### ios register_new_device

```sh
[bundle exec] fastlane ios register_new_device
```

Register Devices

### ios test_scheme

```sh
[bundle exec] fastlane ios test_scheme
```



### ios test_app

```sh
[bundle exec] fastlane ios test_app
```

Run unit/ui tests for App

### ios test_demoApp

```sh
[bundle exec] fastlane ios test_demoApp
```

Run unit/ui tests for demo App

### ios test_features

```sh
[bundle exec] fastlane ios test_features
```

Run tests for feature schemes

### ios regenerate

```sh
[bundle exec] fastlane ios regenerate
```

Regenerate tuist Projects with the specified version

### ios start_project

```sh
[bundle exec] fastlane ios start_project
```

Initial Setting For Projects

### ios match_read_only

```sh
[bundle exec] fastlane ios match_read_only
```

Match all code signing

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
