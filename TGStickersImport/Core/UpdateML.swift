//
//  UpdateML.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import Vision

// https://ml.developer.apple.com/core-ml/

struct UpdateML {
    static let configuration = MLModelConfiguration()
    static var models: [String: VNCoreMLModel?] = [
        //"gender2": try? VNCoreMLModel(for: GenderClassifier(configuration: configuration).model),
        "gender": try? VNCoreMLModel(for: GenderGoogleNet(configuration: configuration).model),
        "glasses": try? VNCoreMLModel(for: GlassesClassifier(configuration: configuration).model),
        "hairColor": try? VNCoreMLModel(for: HairColorClassifier(configuration: configuration).model),
        "hairStyle": try? VNCoreMLModel(for: HairStyleClassifier(configuration: configuration).model),
        "mustache": try? VNCoreMLModel(for: MustacheClassifier(configuration: configuration).model),
        "beard": try? VNCoreMLModel(for: BeardClassifier(configuration: configuration).model),
    ]
    
    // MARK: Code for updating models from the cloud
    
    /*static let lock = NSLock()
    
    static func update() {
        _ = MLModelCollection.beginAccessing(identifier: "TGStickers") { result in
            switch result {
            case .success(let collection):
                print("Model collection \(collection.identifier) is now available.")
                
                /*if let deploymentID = UserDefaults.standard.string(forKey: "deploymentID") {
                    if collection.deploymentID == deploymentID {
                        // Do not update if already downloaded
                        return
                    }
                }*/
                                
                // Load models from the collection
                for (name, _) in collection.entries {
                    loadModel(name, from: collection)
                }
            
                // End accessing after all updated
                /*MLModelCollection.endAccessing(identifier: collection.identifier) { result in
                    switch result {
                    case .success():
                        print("Successfully ended access to `\(collection.identifier)`.")
                    case .failure(let error):
                        print("Error ending access to `\(collection.identifier)`: \(error)")
                    }
                }*/
                   
            case .failure(let error):
               print("Error accessing a model collection: \(error)")
            }
        }
    }
    
    static func loadModel(_ modelName: String, from collection: MLModelCollection) {
        guard let entry = collection.entries[modelName] else {
            print("Couldn't find model \(modelName) in `\(collection.identifier)`.")
            return
        }

        MLModel.load(contentsOf: entry.modelURL) { result in
            switch result {
            case .success(let modelFromCollection):
                lock.lock()
                switch modelName {
                case "Gender":
                    models["gender"] = try? VNCoreMLModel(for: modelFromCollection)
                //case "FacialHairStyle":
                //    models["facialHair"] = try? VNCoreMLModel(for: modelFromCollection)
                case "HairStyle":
                    models["hairStyle"] = try? VNCoreMLModel(for: modelFromCollection)
                case "Glasses":
                    models["glasses"] = try? VNCoreMLModel(for: modelFromCollection)
                case "HairColor":
                    models["hairColor"] = try? VNCoreMLModel(for: modelFromCollection)
                case "Mustache":
                    models["mustache"] = try? VNCoreMLModel(for: modelFromCollection)
                case "Beard":
                    models["beard"] = try? VNCoreMLModel(for: modelFromCollection)
                case "FaceParsing":
                    // FaceRecognition.faceModel = try? VNCoreMLModel(for: modelFromCollection)
                    break
                default:
                    models[modelName] = try? VNCoreMLModel(for: modelFromCollection)
                }
                lock.unlock()
                print("Model \(modelName) was downloaded and ready to use")
            
            case .failure(let error):
                print("Error loading model `\(modelName)` in `\(collection.identifier)`: \(error).")
            }
        }
    }*/
}
