//
//  Data+Extensions.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import Foundation

extension Data {
    func file(named fileName: String) -> URL? {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let filePath = documentsUrl.appendingPathComponent(fileName)
        
        guard let _ = try? self.write(to: filePath) else {
            return nil
        }
        
        return filePath
    }
}
