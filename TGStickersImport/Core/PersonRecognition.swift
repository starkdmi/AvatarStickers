//
//  PersonRecognition.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import UIKit
import Vision
import Combine

struct PersonRecognition {

    enum AIError: Error {
        case image
        case model
        case empty
    }
    
    static func detectAll(_ image: CGImage) -> Future<[String: String], AIError> {
        Future { promise in
            let ciImage = CIImage(cgImage: image)
            
            var results: [String: String] = [:]
            let group = DispatchGroup()
            
            for (name, model) in UpdateML.models {
                guard let model = model else {
                    promise(.failure(.model))
                    return
                }
                
                let request = VNCoreMLRequest(model: model) { request, error in
                    let result = request.results?.first as? VNClassificationObservation
                    guard let identifier = result?.identifier, let confidence = result?.confidence else {
                        promise(.failure(.empty))
                        return
                    }
                                        
                    switch name {
                    case "mustache", "beard":
                        if identifier == String(1) {
                            results[name] = String(confidence)
                        } else {
                            results[name] = String(1.0 - confidence)
                        }
                    case "hairColor":
                        results[identifier] = String(confidence)
                    case "hairStyle":
                        if let values = request.results as? [VNClassificationObservation] {
                            for item in values.filter({ $0.confidence >= 0.25 }) {
                                results[item.identifier] = String(item.confidence)
                            }
                        }
                        results[name] = identifier
                    default:
                        results[name] = identifier
                    }
                }
                
                group.enter()
                let handler = VNImageRequestHandler(ciImage: ciImage)
                DispatchQueue.global(qos: .userInteractive).async {
                    do {
                        try handler.perform([request])
                    } catch {
                        print(error)
                    }
                    group.leave()
                }
            }
                
            group.notify(queue: .main) {
                promise(.success(results))
            }
        }
    }
}
