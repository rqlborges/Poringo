//
//  CurrentLevel.swift
//  Poringo
//
//  Created by Erick Borges on 10/09/17.
//  Copyright © 2017 Erick Borges. All rights reserved.
//

import UIKit

class CurrentLevel: NSObject {
    
    /**
     Current level key for UserDefaults.
     */
    static let key:String = "CurrentLevel"
    
    /**
     Current level user is playing.
     */
    static var currentPlayingLevel = 0
    
    /**
     Current level number retrieved from UserDefaults.
     */
    static let number:Int = {
        let currentLevel = UserDefaults.standard.integer(forKey: CurrentLevel.key)
        return currentLevel
    }()
    
    /**
     Set a new value to current level at UserDefaults.
     */
    static func set(number: Int) {
        UserDefaults.standard.set(number, forKey: CurrentLevel.key)
    }
    
}
