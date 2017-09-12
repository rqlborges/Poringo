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
            if let scene = SKScene(fileNamed: "level_\(number)") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    //MARK: - Actions
    
    @IBAction func go(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
//        gameScene.userData?.addEntries(from: ["isPlaying":true])
    }
}
