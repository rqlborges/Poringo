//
//  PoringoNode.swift
//  Poringo
//
//  Created by Ricardo Sousa on 09/09/17.
//  Copyright © 2017 Erick Borges. All rights reserved.
//

import UIKit
import SpriteKit

class PoringoNode: SKSpriteNode {

    private var moveDistance:Float!
    
    
    
    public init(moveDistance:Float, size:CGSize){
        super.init(texture: <#T##SKTexture?#>, color: UIColor.green, size: size)
        self.moveDistance = moveDistance
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
