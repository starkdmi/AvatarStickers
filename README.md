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
| Version | Gallery | Recognition | Selection | Intro | Settings | Launch | 
| --- | --- | --- | --- | --- | --- | --- | 
| **1.0** | <img src='Screenshots/v1.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-01GalleryView09.png' height="256"/> | <img src='Screenshots/v1.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-02RecognitionView.png' height="256"/> | <img src='Screenshots/v1.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-03SelectionViewSimulator.png' height="256"/> | | | |
| **2.0** | <img src='Screenshots/v2.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-01GalleryView09.png' height="256"/> | <img src='Screenshots/v2.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-02RecognitionView.png' height="256"/> | <img src='Screenshots/v2.0/iPhone%2011%20Pro%20Max/Simulator%20Screen%20Shot%20-%20iPhone%2011%20Pro%20Max%20-%20Select.png' height="256"/> | <img src='Screenshots/v2.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-IntroView.png' height="256"/> | <img src='Screenshots/v2.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-SettingsView.png' height="256"/> | <img src='Screenshots/v2.0/LaunchScreen.png' height="256"/> |
| **Video** | [<img alt="GalleryView Record" src="Screenshots/v2.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-01GalleryView09.png" height="256">](https://user-images.githubusercontent.com/21260939/152046454-5ebee789-474c-400b-8943-0c323cee3d0a.mp4) | [<img alt="RecognitionView Record" src="Screenshots/v2.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-02RecognitionView.png" height="256">](https://user-images.githubusercontent.com/21260939/152052647-e8679f3a-bb93-47dd-a6a6-c30f36276f89.mp4) | [<img alt="SelectionView Record" src="Screenshots/v2.0/iPhone%2011%20Pro%20Max/Simulator%20Screen%20Shot%20-%20iPhone%2011%20Pro%20Max%20-%20Select.png" height="256">](https://user-images.githubusercontent.com/21260939/152047833-5f4f3756-1cff-4d74-841a-cd0399edeb42.mp4) | [<img alt="IntroView Record" src="Screenshots/v2.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-IntroView.png" height="256">](https://user-images.githubusercontent.com/21260939/152047995-23906c22-6fae-40a9-8f5b-09710cad83a8.mp4) | | |



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
