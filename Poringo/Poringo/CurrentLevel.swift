//
//  CurrentLevel.swift
//  Poringo
//
//  Created by Erick Borges on 10/09/17.
//  Copyright © 2017 Erick Borges. All rights reserved.
//

import UIKit
import CoreData

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
    static var number:Int32{
        get{
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Usuario")
            var currentLevel: Int32 = 0
            
            do{
                let level = try context.fetch(userFetch) as! [Usuario]
                if level.count > 0{
                    currentLevel = level[0].currentLevel
                }
                
            }catch{}
            //        let currentLevel = UserDefaults.standard.integer(forKey: CurrentLevel.key)
            return currentLevel
        }
    }
    
    /**
     Set a new value to current level at UserDefaults.
     */
    static func set(number: Int32) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Usuario")
        
        do{
            let list = try context.fetch(userFetch) as! [Usuario]
            if list.count > 0{
                let user = list[0]
                user.setValue(number, forKey: "currentLevel")
            }else{
                if let user = NSEntityDescription.insertNewObject(forEntityName: "Usuario", into: context) as? Usuario{
                    user.currentLevel = number
                }
            }
        }catch{
            
            if let user1 = NSEntityDescription.insertNewObject(forEntityName: "Usuario", into: context) as? Usuario{
                user1.currentLevel = number
            }
        }
        do{
            try context.save()
        }catch{
            print(error)
        }
        //UserDefaults.standard.set(number, forKey: CurrentLevel.key)
    }
    
}
