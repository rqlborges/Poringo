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
    
    @IBOutlet weak var playButton: UIButton!
    var gameScene:SKScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.playButton.setBackgroundImage(#imageLiteral(resourceName: "Play Button"), for: .normal)
            self.playButton.setBackgroundImage(#imageLiteral(resourceName: "PlayButton_Selected"), for: .selected)
        }
        
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "Example") {
                gameScene = scene
                scene.scaleMode = .aspectFill
                
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
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
    @IBAction func go(_ sender: Any) {
        gameScene.userData?.addEntries(from: ["isPlaying":true])
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
