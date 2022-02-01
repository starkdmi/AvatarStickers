## About
[Avatar Stickers](https://apps.apple.com/us/app/avatar-stickers/id1574023061) - iOS application that allows you to create an animated stickers and export them to Telegram and WhatsApp messengers. The application was created while participating in the [contest](https://contest.com/sticker-app). Server code is available [here](https://github.com/starkdmi/AvatarStickersServer).

## Features
- Generate animated stickers
- In-app stickers preview
- Export to Telegram and WhatsApp
- Sync your collections with iCloud
- Share raw files (Lottie and TGS)
- Available without network connection (Except the export)

## Screenshots
| Version | Gallery | Recognition | Selection | Launch | Onboarding | Camera | Settings | 
| --- | --- | --- | --- | --- | --- | --- | --- | 
| 1.0 | ![GalleryView v1.0](Screenshots/v1.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-01GalleryView09.png) | ![RecognitionView v1.0](Screenshots/v1.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-02RecognitionView.png) | ![SelectionView v1.0](Screenshots/v1.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-03SelectionViewSimulator.png) | | | | |
| 2.0 | ![GalleryView v2.0](Screenshots/v2.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-01GalleryView09.png) | ![RecognitionView v2.0](Screenshots/v2.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-02RecognitionView.png) | ![SelectionView v2.0](Screenshots/v2.0/iPhone%2011%20Pro%20Max/Simulator%20Screen%20Shot%20-%20iPhone%2011%20Pro%20Max%20-%20Select.png) | | | | |

## Dev Stack 
- SwiftUI
- Swift Package Manager (SPM)
- Core Data
- Core ML
- Fastlane

## Schemes
- **Debug:** Mocked animations and network requests (no server)
- **Local:** Requests in local network. Used in pair with local server
- **Release:** App Store 

## CoreML
Most of the ML models were created using CreateML and public datasets. 10K images used per class which can also be improved.

## TODO
- Server API Key Security (using Configuration file)
- Export to different Telegram apps (non-official)
- Accessebility

## Licenses
- [Lottie](https://github.com/airbnb/lottie-ios) - Apache 2.0
- [Fastlane](https://github.com/fastlane/fastlane) - MIT
- [SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI) - MIT
- [GzipSwift](https://github.com/1024jp/GzipSwift) - MIT
- [TelegramStickersImport](https://github.com/TelegramMessenger/TelegramStickersImport) - MIT
- [WhatsApp Stickers](https://github.com/WhatsApp/stickers) - BSD
- [YPImagePicker](https://github.com/Yummypets/YPImagePicker) - MIT
- [ChameleonFramework](https://github.com/vicc/chameleon) - MIT
- [LicensePlist](https://github.com/mono0926/LicensePlist) - MIT
- [IconGenerator](https://github.com/onmyway133/IconGenerator) - MIT
