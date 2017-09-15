//
//  GameViewController.swift
//  Poringo
//
//  Created by Erick Borges on 09/09/17.
//  Copyright © 2017 Erick Borges. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var gameScene:SKScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Setup
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func instantiateLevel(number: Int) {
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "level_\(number)") as? GameScene {
                scene.viewController = self
                gameScene = scene
                gameScene.scaleMode = .aspectFill
                view.presentScene(gameScene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    //MARK: - Actions
    
}
