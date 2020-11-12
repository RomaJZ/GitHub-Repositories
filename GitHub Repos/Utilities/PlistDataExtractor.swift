//
//  PlistDataExtractor.swift
//  GitHub Repos
//
//  Created by Roma Filipenko on 12.11.2020.
//

import Foundation

class PlistDataExtractor {
    
    static func extractFrom(_ file: String, property: String) -> String? {
        
        if let fileUrl = Bundle.main.url(forResource: file, withExtension: "plist"),
           let data = try? Data(contentsOf: fileUrl) {
            
            if let result = try? PropertyListSerialization.propertyList(from: data,
                                                                        options: [],
                                                                        format: nil) as? [String: Any] {
                
                if let foundProperty = result[property] as? String {
                    return foundProperty
                }
            }
        }
        return nil
    }
}
