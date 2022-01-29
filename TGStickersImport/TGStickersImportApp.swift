//
//  TGStickersImportApp.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import SwiftUI
import SDWebImageWebPCoder

class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    
    public var onClose: (() -> ())? = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Update ML models from iCloud
        // UpdateML.update()
        
        // Animated WebP - https://github.com/SDWebImage/SDWebImageWebPCoder
        SDImageCodersManager.shared.addCoder(SDImageWebPCoder.shared)
                             
        // While commented AccentColor from Assets is used
        // UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor.main
        
        #if DEBUG
        if CommandLine.arguments.contains("-LOCAL") {
            AvatarKeys.emotions = ["😂", "❤️", "😍", "✨", "😇", "😊", "😉", "😐", "😡", "😔", "😭", "🏀", "⚽️"]
        }
        // UserDefaults.standard.setValue(true, forKey: "FASTLANE_SNAPSHOT")
        #endif

        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        onClose?()
    }
}

@main
struct TGStickersImportApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) var scenePhase
    
    #if DEBUG
    let persistenceController = PersistenceController.mock
    #else
    let persistenceController = PersistenceController.shared
    #endif
    
    var body: some Scene {
        WindowGroup {
            #if DEBUG
            let processInfo = ProcessInfo.processInfo
            if processInfo.arguments.contains("test") {
                if let view = processInfo.environment["view"] {
                    switch view {
                    case "gallery":
                        ContentView()
                            .preferredColorScheme(.light)
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    case "recognition":
                        if let path = Bundle.main.path(forResource: "avatar", ofType: "jpeg", inDirectory: "MockupAnimations"),
                           let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
                           let image = UIImage(data: data) {
                            RecognitionView(image: .constant(image)).preferredColorScheme(.light)
                        }
                    case "selection":
                        AnimatedStickersView(parameters: [:], image: .constant(nil)).preferredColorScheme(.light)
                    default:
                        EmptyView()
                    }
                }
            } else {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .preferredColorScheme(.light)
            }
            #else
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.light)
            #endif
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
