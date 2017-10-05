//
//  Usuario+CoreDataProperties.swift
//  Poringo
//
//  Created by Ricardo Sousa on 02/10/2017.
//  Copyright © 2017 Erick Borges. All rights reserved.
//
//

import Foundation
import CoreData


extension Usuario {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Usuario> {
        return NSFetchRequest<Usuario>(entityName: "Usuario")
    }

    @NSManaged public var currentLevel: Int32

}
