//
//  LevelsMenuCollectionViewController.swift
//  Poringo
//
//  Created by Erick Borges on 12/09/17.
//  Copyright © 2017 Erick Borges. All rights reserved.
//

import UIKit

private let reuseIdentifier = "LevelCell"

class LevelsMenuCollectionViewController: UICollectionViewController, PassSelectedLevelDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 9
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LevelCollectionViewCell
        
        // Configure the cell
        cell.delegate = self
        cell.config(number: indexPath.row + 1)
    
        return cell
    }

    //MARK: - PassSelectedLevelDelegate
    func configureLevel(number: Int) {
        //TODO: Dismiss LevelsMenuCollectionViewController
        guard let gameVC = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else { return }
        self.show(gameVC, sender: self)
        gameVC.instantiateLevel(number: number)

    }
    
}
