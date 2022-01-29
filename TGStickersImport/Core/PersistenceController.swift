//
//  PersistenceController.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    // Storage for Core Data
    var container: NSPersistentContainer
    
    #if DEBUG
    static var mock: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
                
        for index in 1...13 {
            var name = "", emotion = ""
            switch index {
            case 1:
                name = "Amazing"
                emotion = "😍"
            case 3:
                name = "Excited"
                emotion = "✨"
            case 4:
                name = "Laugh" // Crying
                emotion = "😂" // 😭
            case 5:
                name = "Please" // Wink, Angry
                emotion = "😇" // 😉, 😡
            case 7:
                name = "Love" // Laugh
                emotion = "❤️" // 😂
            case 8:
                name = "Sad" // Amazing
                emotion = "😔" // 😍
            case 11:
                name = "Angry" // Amazing
                emotion = "😡" // 😍
            case 12:
                 name = "Crying" // Laugh, Crying
                 emotion = "😭" // 😂, 😭
            case 13:
                name = "Excited" // Sad
                emotion = "✨" // 😔
            default:
                continue
            }
            
            let stickerSet = StickerSet(context: controller.container.viewContext)
            stickerSet.source = "telegram"
                        
            stickerSet.date = Date().addingTimeInterval(-TimeInterval(7000*index))

            let sticker = Sticker(context: controller.container.viewContext)
            sticker.emotion = emotion

            if let path = Bundle.main.path(forResource: "\(name)_\(index)", ofType: "json", inDirectory: "MockupAnimations/avatar_\(index)"),
               let escaped = try? Data(contentsOf: URL(fileURLWithPath: path)),
               let string = String(data: escaped, encoding: .utf8),
               let data = String(string.unescaped.dropFirst().dropLast()).data(using: .utf8) {
                sticker.animation = data
            }

            stickerSet.addToStickers(sticker)
            
            // Additional stickers for 3D touch preview screenshot
            /*if index == 3 {
                for name in ["Amazing", "Angry", "Crying", "Emotionless", "Laugh", "Love", "Please", "Sad", "Smile", "Wink"] {
                    if let path = Bundle.main.path(forResource: "\(name)_\(index)", ofType: "json", inDirectory: "MockupAnimations/avatar_\(index)"),
                       let escaped = try? Data(contentsOf: URL(fileURLWithPath: path)),
                       let string = String(data: escaped, encoding: .utf8),
                       let data = String(string.unescaped.dropFirst().dropLast()).data(using: .utf8) {
                        
                        let sticker = Sticker(context: controller.container.viewContext)
                        sticker.emotion = emotion
                        sticker.animation = data
                        stickerSet.addToStickers(sticker)
                    }
                }
            }*/
            
            /*for (name, emotion) in ["Amazing": "😍", "Angry": "😡", "Crying": "😭", "Emotionless": "😐", "Excited": "✨", "Laugh": "😂", "Love": "❤️", "Please": "😇", "Sad": "😔", "Smile": "😊", "Wink": "😉"] {
                let sticker = Sticker(context: controller.container.viewContext)
                sticker.emotion = emotion

                if let path = Bundle.main.path(forResource: "\(name)_\(index)", ofType: "json", inDirectory: "MockupAnimations/avatar_\(index)"),
                   let escaped = try? Data(contentsOf: URL(fileURLWithPath: path)),
                   let string = String(data: escaped, encoding: .utf8),
                   let data = String(string.unescaped.dropFirst().dropLast()).data(using: .utf8) {
                    sticker.animation = data
                }

                stickerSet.addToStickers(sticker)
            }*/
        }
        
        controller.save()

        return controller
    }()
    #endif

    // An initializer to load Core Data, optionally able
    // to use an in-memory store
    init(inMemory: Bool = false) {
        #if DEBUG
        container = NSPersistentContainer(name: "Animations")
        container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        #else
        container = NSPersistentCloudKitContainer(name: "Animations")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        // App Group shared location
        else {
            container.persistentStoreDescriptions = Self.getDescriptions()
        }
        #endif

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    static func getDescriptions() -> [NSPersistentStoreDescription] {
        var persistentDescriptions: [NSPersistentStoreDescription] = []
        
        if let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.starkdmi.TGStickers") {
                        
            // Local
            let localStoreDescription = NSPersistentStoreDescription(url: storeURL.appendingPathComponent("local.sqlite"))
            localStoreDescription.configuration = "Local"
            persistentDescriptions.append(localStoreDescription)
            
            // CloudKit
            if UserDefaults.standard.bool(forKey: "iCloudSync") == true {
                let cloudDescription = NSPersistentStoreDescription(url: storeURL.appendingPathComponent("icloud.sqlite"))
                cloudDescription.configuration = "Cloud"

                // Set the container options on the cloud store
                cloudDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.starkdmi.TGStickers")
                
                persistentDescriptions.append(cloudDescription)
            }
        }
        
        return persistentDescriptions
    }
    
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show some error here
            }
        }
    }
}
