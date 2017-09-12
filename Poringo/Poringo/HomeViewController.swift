//
//  HomeViewController.swift
//  Poringo
//
//  Created by Erick Borges on 12/09/17.
//  Copyright © 2017 Erick Borges. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func jogarAction(_ sender: UIButton) {
        guard let gameVC = storyboard?.instantiateViewController(withIdentifier: "GameViewControlller") as? GameViewController else { return }
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
