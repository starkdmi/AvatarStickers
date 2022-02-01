## About
[**Avatar Stickers**](https://apps.apple.com/us/app/avatar-stickers/id1574023061) - iOS application that allows you to create an animated stickers and export them to **Telegram** and **WhatsApp** messengers. The application was created while participating in the [contest](https://contest.com/sticker-app). Server code is available [here](https://github.com/starkdmi/AvatarStickersServer).

## Features
- [x] **Generate animated stickers**
- [x] **In-app stickers preview**
- [x] **Export to Telegram and WhatsApp**
- [x] **Sync sticker collections with iCloud**
- [x] **Share raw files (Lottie and TGS)**
- [x] **Available without network connection (Except the export)**

## Screenshots
|  Version  |  Gallery  | Recognition | Selection  |   Intro   | Settings  |   Launch   | 
| --- | --- | --- | --- | --- | --- | --- | 
| **1.0** | <img src='Screenshots/v1.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-01GalleryView09.png' height="225px"/> | <img src='Screenshots/v1.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-02RecognitionView.png' height="225px"/> | <img src='Screenshots/v1.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-03SelectionViewSimulator.png' height="225px"/> | | | |
| **2.0** | <img src='Screenshots/v2.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-01GalleryView09.png' height="225px"/> | <img src='Screenshots/v2.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-02RecognitionView.png' height="225px"/> | <img src='Screenshots/v2.0/iPhone%2011%20Pro%20Max/Simulator%20Screen%20Shot%20-%20iPhone%2011%20Pro%20Max%20-%20Select.png' height="225px"/> | <img src='Screenshots/v2.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-IntroView.png' height="225px"/> | <img src='Screenshots/v2.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-SettingsView.png' height="225px"/> | <img src='Screenshots/v2.0/LaunchScreen.png' height="225px"/> |
| **Video** | [<img alt="GalleryView Record" src="Screenshots/v2.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-01GalleryView09.png" height="225px">](https://user-images.githubusercontent.com/21260939/152046454-5ebee789-474c-400b-8943-0c323cee3d0a.mp4) | [<img alt="RecognitionView Record" src="Screenshots/v2.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-02RecognitionView.png" height="225px">](https://user-images.githubusercontent.com/21260939/152052647-e8679f3a-bb93-47dd-a6a6-c30f36276f89.mp4) | [<img alt="SelectionView Record" src="Screenshots/v2.0/iPhone%2011%20Pro%20Max/Simulator%20Screen%20Shot%20-%20iPhone%2011%20Pro%20Max%20-%20Select.png" height="225px">](https://user-images.githubusercontent.com/21260939/152047833-5f4f3756-1cff-4d74-841a-cd0399edeb42.mp4) | [<img alt="IntroView Record" src="Screenshots/v2.0/iPhone%2011%20Pro%20Max/iPhone%2011%20Pro%20Max-IntroView.png" height="225px">](https://user-images.githubusercontent.com/21260939/152047995-23906c22-6fae-40a9-8f5b-09710cad83a8.mp4) | | |

## Stack 
- SwiftUI
- Combine
- Core Data
- Core ML
- Swift Package Manager
- Fastlane

## Build
Clone the project and open it in Xcode. Xcode will download Swift Packages automatically. You will need to provide an iCloud identifier in **TGStickersImport.entitlements** for Core Data cloud synchronization.

## Schemes
- **Debug** - Mocked animations and network requests (no server)
- **Local** - Requests in local network. Used in pair with local server
- **Release** - App Store 

## Xcode Previews
With power of SwiftUI the previews works as expected including mocked animations and Core Data.
<table align="center">
    <tr>
        <td align="center"><img height="348px" alt="Xcode IntroView" src="https://user-images.githubusercontent.com/21260939/152054776-fc7e7f19-6bbe-4635-81c1-b215cd8f0200.png"></td>
        <td align="center"><img height="348px" alt="Xcode ContentView" src="https://user-images.githubusercontent.com/21260939/152057189-a7a24a46-0164-45b4-b016-1d12d5730da5.png"></td>
    </tr>
    <tr>
        <td align="center"><img height="348px" alt="Xcode RecognitionView" src="https://user-images.githubusercontent.com/21260939/152057114-4a8649ee-497a-4427-bfae-2649f7fba297.png"></td>
        <td align="center"><img height="348px" alt="Xcode GalleryView" src="https://user-images.githubusercontent.com/21260939/152056861-c930803f-a55c-4a88-93e7-3b36730134cf.png"></td>
    </tr>
</table>

## Core ML
Most of the ML models were created using CreateML and public datasets. 10K images used per class which can also be improved.

## TODO
- [ ] Server API Key Security (using Configuration file)
- [ ] Export to different Telegram apps (non-official)
- [ ] Accessebility

## App Store
- Application main features was released during **Telegram contest from June 25 to July 4**. 
- The application was published in App Store in **August 2021** (after two weeks review). 
- In **Semptember** new updates were blocked due the **Guideline 4.3 - Design**
 
    >Same feature set as other apps submitted to the App Store
- In **January 2022** I've decided to **Open Source** it.

The application is still in App Store and available for **free** but will not receive any updates because of the App Store vague rules.

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
