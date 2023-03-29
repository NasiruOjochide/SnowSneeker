//
//  Favorites.swift
//  SnowSneeker
//
//  Created by Danjuma Nasiru on 28/03/2023.
//

import Foundation

class Favorites: ObservableObject {
    // the actual resorts the user has favorited
    private var resorts: Set<String>

    // the key we're using to read/write in UserDefaults
    private let saveKey = "Favorites"

    init() {
        // load our saved data
        if let data = UserDefaults.standard.data(forKey: saveKey){
            if let decodedResort = try? JSONDecoder().decode(Set<String>.self, from: data){
                resorts = decodedResort
                return
            }
        }
        
        // still here? Use an empty array
        resorts = []
    }

    // returns true if our set contains this resort
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }

    // adds the resort to our set, updates all views, and saves the change
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }

    // removes the resort from our set, updates all views, and saves the change
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }

    func save() {
        // write out our data
        guard let data = try? JSONEncoder().encode(resorts) else{return}
        UserDefaults.standard.set(data, forKey: saveKey)
    }
}
