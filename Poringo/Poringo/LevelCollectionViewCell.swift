//
//  LevelCollectionViewCell.swift
//  Poringo
//
//  Created by Erick Borges on 12/09/17.
//  Copyright © 2017 Erick Borges. All rights reserved.
//

protocol PassSelectedLevelDelegate {
    func configureLevel(number:Int)
}

import UIKit

class LevelCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var levelButton: UIButton!

    //MARK: - Atributes
    var number:Int = 0
    var delegate:PassSelectedLevelDelegate?
    
    func config(number: Int) {
        self.number = number
        self.levelButton.setTitle("\(self.number)", for: .normal)
    }
    
    
    //MARK: - Actions
    @IBAction func levelButtonAction(_ sender: UIButton) {
        self.delegate?.configureLevel(number: self.number)
    }

}
