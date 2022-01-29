//
//  CameraView.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import SwiftUI
import YPImagePicker

struct CameraView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var image: UIImage?
    var dismissOnSuccess = false
    static var screens: [YPPickerScreen] = [.library, .photo]
    static var hideCancelButton: Bool = false
    
    @State var picker: YPImagePicker = {
        var config = YPImagePickerConfiguration()

        let tintColor = UIColor.night
        let backgroundColor = UIColor.night

        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = true
        config.showsPhotoFilters = false
        config.showsVideoTrimmer = false
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "Avatar Stickers"
        config.startOnScreen = YPPickerScreen.photo
        config.screens = screens
        config.showsCrop = .none
        config.targetImageSize = YPImageSize.cappedTo(size: 512)
        config.hidesStatusBar = true
        config.hidesBottomBar = false
        config.hidesCancelButton = hideCancelButton
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        config.maxCameraZoomFactor = 1.0

        config.library.options = nil
        config.library.onlySquare = true
        config.library.isSquareByDefault = true
        config.library.mediaType = YPlibraryMediaType.photo
        config.library.defaultMultipleSelection = false
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 3
        config.library.spacingBetweenItems = 2.0
        config.library.skipSelectionsGallery = false
               
        config.colors.tintColor = tintColor
        config.colors.photoVideoScreenBackgroundColor = backgroundColor // shutter button background color
        config.icons.capturePhotoImage = config.icons.capturePhotoImage.tintedWithLinearGradientColors(colorsArr: [UIColor.grass.cgColor, UIColor.sea.cgColor])
               
        config.colors.libraryScreenBackgroundColor = backgroundColor // divider between grid items in library

        let buttonsFont = UIFont.systemFont(ofSize: 18, weight: .bold)
        config.fonts.leftBarButtonFont = buttonsFont
        config.fonts.rightBarButtonFont = buttonsFont
        let font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        let titleFont = UIFont.systemFont(ofSize: 20, weight: .heavy)
        config.fonts.pickerTitleFont = titleFont
        config.fonts.menuItemFont = font
        config.fonts.navigationBarTitleFont = font
        config.fonts.albumCellTitleFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
        config.fonts.albumCellNumberOfItemsFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        UINavigationBar.appearance().titleTextAttributes = [.font: titleFont, .foregroundColor: tintColor]

        config.colors.bottomMenuItemSelectedTextColor = tintColor
        config.bottomMenuItemUnSelectedTextColour = tintColor // .withAlphaComponent(0.86)

        let picker = YPImagePicker(configuration: config)

        picker.navigationBar.setGradientBackground(colors: [.sea.withAlphaComponent(0.825), .grass.withAlphaComponent(0.825)], startPoint: .bottomLeft, endPoint: .topRight) // nav bar gradient background
        
        return picker
    }()

    var body: some View {
        picker.toSwiftUI()
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .preferredColorScheme(.dark)
            .statusBar(hidden: true)
            .onAppear {
                picker.didFinishPicking { items, cancelled in
                    if cancelled {
                        self.presentationMode.wrappedValue.dismiss()
                    } else if let photo = items.singlePhoto {
                        self.image = photo.image
                        
                        if dismissOnSuccess {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(image: .constant(UIImage()))
    }
}
