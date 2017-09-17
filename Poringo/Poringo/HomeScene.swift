//
//  HomeScene.swift
//  Poringo
//
//  Created by Erick Borges on 15/09/17.
//  Copyright © 2017 Erick Borges. All rights reserved.
//

import UIKit
import SpriteKit

class HomeScene: SKScene {

    var backgroundNode:SKSpriteNode!
    var backgrounds:[SKSpriteNode] = []
    var isFirstBackGround = true
    
    override func didMove(to view: SKView) {
        self.backgroundColor = #colorLiteral(red: 0.1873555183, green: 0.7902091146, blue: 0.4378808737, alpha: 1)
        setupBackground()
        
    }
    
    func setupBackground(){
        backgroundNode = SKSpriteNode()
        backgroundNode.texture = SKTexture(imageNamed: "HomescreenBackground")
        backgroundNode.size = CGSize(width: self.size.width * 2, height: self.size.height)
        backgroundNode.anchorPoint = CGPoint(x: 0 , y: 0)
        
        let translation = SKAction.move(by: CGVector(dx: -self.size.width * 4, dy: 0), duration: 80)
        backgroundNode.run(translation)
        
        if (!isFirstBackGround) {
            backgroundNode.position.x = (backgrounds.last?.position.x)! + (backgrounds.first?.size.width)!
        }
        
        self.addChild(backgroundNode)
        backgrounds.append(backgroundNode)
        
        if backgrounds.count > 2 {
            backgrounds.first?.removeFromParent()
            backgrounds.removeFirst()
        }
        
        isFirstBackGround = false
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if backgroundNode.position.x < -self.size.width {
            setupBackground()
        }
        
    }

}
