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
        
        
//        self.playButton.setBackgroundImage(#imageLiteral(resourceName: "Play Button"), for: .normal)
//        self.playButton.setBackgroundImage(#imageLiteral(resourceName: "PlayButton_Selected"), for: .selected)
        
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
    
    
    
    func endGameUI(){
        let square = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 250))
        square.layer.cornerRadius = CGFloat(10)
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        square.addSubview(button)
    }
    
}
