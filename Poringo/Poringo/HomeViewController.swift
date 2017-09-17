//
//  HomeViewController.swift
//  Poringo
//
//  Created by Erick Borges on 12/09/17.
//  Copyright © 2017 Erick Borges. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class HomeViewController: UIViewController {

    var homeScene:SKScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MusicHelper.sharedHelper.playBackgroundMusic()
        
        if let view = self.view as! SKView? {
            let scene = HomeScene(size: self.view.frame.size)
            homeScene = scene
            homeScene.scaleMode = .aspectFill
            view.presentScene(homeScene)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
    }
    
    @IBAction func jogarAction(_ sender: UIButton) {
        guard let gameVC = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else { return }
        self.dismiss(animated: false, completion: nil)
        self.show(gameVC, sender: sender)
        gameVC.instantiateLevel(number: CurrentLevel.number)
    }
    
    @IBAction func fasesAction(_ sender: UIButton) {
        guard let levelsMenuVC = storyboard?.instantiateViewController(withIdentifier: "LevelsMenu") as? LevelsMenuCollectionViewController else { return }
        self.dismiss(animated: false, completion: nil)
        self.show(levelsMenuVC, sender: sender)
    }

    
}
