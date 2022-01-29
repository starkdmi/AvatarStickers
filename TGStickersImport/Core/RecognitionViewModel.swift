//
//  RecognitionViewModel.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import SwiftUI
import Combine

class RecognitionViewModel: ObservableObject {
    private var cancellableSet: Set<AnyCancellable> = []
    
    @Published var isModelValid: Bool = false
    
    @Published var string = ""
    @Published var isStringValid: Bool = true
        
    @Published var skinColor: Color = .clear
    @Published var hairColor: Color = .clear
    @Published var bodyColor: Color = .clear
    @Published var textColor: Color = .clear
    var defaultTextColor: Color = .clear
    
    @Published var male = true
    @Published var isTelegram: Bool?
    
    var parameters: [String: String] = [:]
    
    private var isStringValidPublisher: AnyPublisher<Bool, Never> {
        $string
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input  in
                input == "" || (input.count >= 3 && input.count <= 6)
            }
            .eraseToAnyPublisher()
    }
    
    init() {
        isStringValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isStringValid, on: self)
            .store(in: &cancellableSet)
    }
    
    func recognize(_ cgImage: CGImage, completion: @escaping (Bool) -> Void) {
        
        let mock: Bool
        #if targetEnvironment(simulator)
        // Issue (Apple M1) - https://developer.apple.com/forums/thread/667716
        mock = true
        #else
        mock = UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT")
        #endif
        
        if mock {
            self.skinColor = Color(red: 255/255, green: 219/255, blue: 180/255) // pale
            self.hairColor = .night
            self.bodyColor = .night
            self.textColor = .fire
            self.male = true
            completion(true)
            return
        }
        
        DispatchQueue.global(qos: .userInteractive).async {

            // MARK: Face Detection & Cropping
            
            FaceRectangleDetection.detect(cgImage) { rectangle, angle in
                
                guard rectangle != .zero else {
                    completion(false)
                    return
                }
                
                guard let image = cgImage.cropping(to: rectangle) else {
                    completion(false)
                    return
                }

                // Rotation distorts the gender recognition results (!)
                /*if angle != 0.0, let rotated = image.rotated(radians: angle) {
                    DispatchQueue.main.async {
                        withAnimation {
                            self.faceParts.append(UIImage(cgImage: rotated))
                        }
                    }
                    image = rotated
                }*/
                
                guard let resized = image.resized() else {
                    completion(false)
                    return
                }
            
                let group = DispatchGroup()
                
                // MARK: FACE RECOGNITION
                
                let parts = [
                    FaceRecognition.ProcessData(key: .background, image: resized, mode: .delete),
                    FaceRecognition.ProcessData(key: .skin, image: resized, mode: .insert),
                    FaceRecognition.ProcessData(key: .cloth, image: resized, mode: .insert),
                    FaceRecognition.ProcessData(key: .hair, image: resized, mode: .insert),
                ]

                group.enter()
                FaceRecognition.processFace(resized, using: parts) { data in
                    for (key, img) in data {
                        let uiImage = UIImage(cgImage: img)
                        
                        // MARK: COLOR RECOGNITION
                        
                        switch key {
                        case .skin:
                            group.enter()
                            ColorsRecognition.skinColor(uiImage) { orig, key in
                                DispatchQueue.main.async {
                                    self.parameters["skinColor"] = key
                                    self.parameters["skinColorOriginal"] = orig
                                    withAnimation {
                                        if let color = UIColor(hexString: key) {
                                            self.skinColor = Color(color)
                                        }
                                    }
                                }
                                group.leave()
                            }
                        case .hair:
                            group.enter()
                            ColorsRecognition.hairColor(uiImage) { orig, key in
                                DispatchQueue.main.async {
                                    self.parameters["hairColor"] = key
                                    self.parameters["beardColor"] = key
                                    self.parameters["hairColorOriginal"] = orig
                                    withAnimation {
                                        if let color = UIColor(hexString: key) {
                                            self.hairColor = Color(color)
                                        }
                                    }
                                }
                                group.leave()
                            }
                        case .cloth:
                            group.enter()
                            ColorsRecognition.clothesColor(uiImage) { orig, clothes, text in
                                DispatchQueue.main.async {
                                    self.parameters["clothesColor"] = clothes
                                    self.parameters["hatColor"] = clothes
                                    self.parameters["text_color"] = text
                                    self.parameters["clothesColorOriginal"] = orig
                                    withAnimation {
                                        if let color = UIColor(hexString: clothes) {
                                            self.bodyColor = Color(color)
                                        }
                                        
                                        if let color = UIColor(hexString: text) {
                                            self.textColor = Color(color)
                                            self.defaultTextColor = Color(color)
                                        }
                                    }
                                }
                                group.leave()
                            }
                        default: break
                        }
                    }
                    group.leave()
                }
                
                // MARK: PersonRecognition
                   
                group.enter()
                PersonRecognition.detectAll(resized).sink(receiveCompletion: { _ in }, receiveValue: { results in
                    for (key, value) in results {
                        self.parameters[key] = value
                    }
                    group.leave()
                })
                .store(in: &self.cancellableSet)
                
                group.notify(queue: .main) {
                    // Correct gender if beard or mustache -> male (just statistics)
                    if let gender = self.parameters["gender"] {
                        if gender == "female" {
                            if Float(self.parameters["beard2"] ?? "0.0") ?? 0.0 >= 0.4 ||
                                Float(self.parameters["mustache"] ?? "0.0") ?? 0.0 >= 0.4 {
                                self.parameters["gender"] = "male"
                            }
                            else {
                                withAnimation {
                                    self.male = false
                                }
                            }
                        }
                    }

                    completion(true)
                }
            }
        }
    }
            
    var exportParameters: [String: String] {
        if isStringValid {
            parameters["shirt_text"] = string
        }
        
        if skinColor != .clear, let cgColor = skinColor.cgColor {
            parameters["skinColor"] = UIColor(cgColor: cgColor).hexValue()
        }
        
        if hairColor != .clear, let cgColor = hairColor.cgColor {
            let hex = UIColor(cgColor: cgColor).hexValue()
            parameters["hairColor"] = hex
            parameters["beardColor"] = hex
        }
        
        if bodyColor != .clear, let cgColor = bodyColor.cgColor {
            let clothesColor = UIColor(cgColor: cgColor)
            let hex = clothesColor.hexValue()
            parameters["clothesColor"] = hex
            parameters["hatColor"] = hex
            
            if textColor != .clear, textColor != defaultTextColor, let cgColor = textColor.cgColor {
                let textColor = UIColor(cgColor: cgColor)
                parameters["text_color"] = textColor.hexValue()
            } else {
                let textColor = ColorsRecognition.textColor(clothesColor)
                parameters["text_color"] = textColor.hexValue()
            }
        }
                
        parameters["gender"] = male ? "male" : "female"
        
        if let source = isTelegram {
            parameters["service"] = source ? "telegram" : "whatsapp"
        } else {
            parameters["service"] = UserDefaults.standard.bool(forKey: "isWhatsApp") ? "whatsapp" : "telegram"
        }
        parameters["source"] = parameters["service"]

        return parameters
    }
}
