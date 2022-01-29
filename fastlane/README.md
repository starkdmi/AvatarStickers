fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios sign
```
fastlane ios sign
```
Verify and update signing certificates
### ios build
```
fastlane ios build
```
Build Application
### ios screenshots
```
fastlane ios screenshots
```
Capture and Process the Screenshots
### ios beta
```
fastlane ios beta
```
Upload Application to Testflight beta testing
### ios release
```
fastlane ios release
```
Release Application to App Store with Metadata and Screenshots

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
