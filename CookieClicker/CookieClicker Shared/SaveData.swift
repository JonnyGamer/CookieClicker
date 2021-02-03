//
//  SaveData.swift
//  CookieClicker iOS
//
//  Created by Jonathan Pappas on 2/3/21.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    var wrappedValue: T {
        get { return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}

enum SaveData {
    @UserDefault(key: "iSpySuper", defaultValue: false)
    static var iSpyUnlocked: Bool
    
    //@UserDefault(key: "Total Wins", defaultValue: 0)
    //static var totalWins: Int
    //@UserDefault(key: "totalPerfects", defaultValue: 0)
    //static var totalPerfects: Int
    
    @UserDefault(key: "minimal", defaultValue: false)
    static var minimal: Bool
    
    
    @UserDefault(key: "Current Scene", defaultValue: "Scene1")
    static var currentScene: String
    
}
