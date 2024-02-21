//
//  Extensions.swift
//  NFTunes
//
//  Created by Gabriele Gortani on 10/01/24.
//

import Foundation


//Encodable permette di convertire in JSON un oggetto
extension Encodable {
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json ?? [:]
        } catch {
            return [:]
        }
    }
}
