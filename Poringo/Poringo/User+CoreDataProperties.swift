//
//  User+CoreDataProperties.swift
//  Poringo
//
//  Created by Ricardo Sousa on 02/10/2017.
//  Copyright © 2017 Erick Borges. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    public var currentLevel: Int32

}
