//
//  Bundle-Decodable.swift
//  SnowSneeker
//
//  Created by Danjuma Nasiru on 27/03/2023.
//

import Foundation

extension Bundle{
    func decode<T : Decodable> (_ file : String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else{
            fatalError("Failed to locate \(file) in bundle.")
        }
        guard let data = try? Data(contentsOf: url) else{
            fatalError("Failed to locate \(file) in bundle")
        }
        let decoder = JSONDecoder()
        guard let loaded = try? decoder.decode(T.self, from: data) else{
            fatalError("Failed to decode \(file) from bundle.")
        }
        return loaded
    }
}

