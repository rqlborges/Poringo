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

    private var action:SKAction
    
    
    public init(moveDistance:Float, position:CGPoint,size:CGSize){
        super.init(texture: <#T##SKTexture?#>, color: UIColor.green, size: size)
        self.moveDistance = moveDistance
        self.position = position

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
