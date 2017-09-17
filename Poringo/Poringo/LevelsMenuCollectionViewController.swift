//
//  LevelsMenuCollectionViewController.swift
//  Poringo
//
//  Created by Erick Borges on 12/09/17.
//  Copyright © 2017 Erick Borges. All rights reserved.
//

import UIKit
import SpriteKit

private let reuseIdentifier = "LevelCell"

class LevelsMenuCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout ,PassSelectedLevelDelegate, LevelsMenuBackButtonDelegate {
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named:"LevelsMenuBackground")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let bgView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundView = imageView
        
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LevelCollectionViewCell
        
        // Configure the cell
        cell.delegate = self
        cell.config(number: indexPath.row + 1)
        
        return cell
    }
    
    
    let headerReuseIdentifier = "Header"
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var header:LevelsMenuHeaderCollectionReusableView!
        
        if (kind == UICollectionElementKindSectionHeader){
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! LevelsMenuHeaderCollectionReusableView
            header.delegate = self
        }
        
        return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = (self.collectionView?.frame.width)!/4 - 30
        return CGSize(width: cellSize, height: cellSize)
    }
    
    //MARK: - PassSelectedLevelDelegate
    func configureLevel(number: Int) {
        //TODO: Dismiss LevelsMenuCollectionViewController
        guard let gameVC = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else { return }
        self.show(gameVC, sender: self)
        gameVC.instantiateLevel(number: number)
        
    }
    
    //MARK: - LevelsMenuBackButtonDelegate
    func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
