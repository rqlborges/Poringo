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
        self.levelButton.setTitle("", for: .normal)
        
        if number > CurrentLevel.number + 1 {
            self.levelButton.isEnabled = false
        }else{
            self.levelButton.isEnabled = true
        }
        
        if (number > 9){
            self.levelButton.setImage(UIImage(named: "LevelButton_Default_0\(self.number)"), for: .normal)
            self.levelButton.setImage(UIImage(named: "LevelButton_Disabled_0\(self.number)"), for: .disabled)
        } else {
            self.levelButton.setImage(UIImage(named: "LevelButton_Default_00\(self.number)"), for: .normal)
            self.levelButton.setImage(UIImage(named: "LevelButton_Disabled_00\(self.number)"), for: .disabled)
        }
        
    }
    
    
    //MARK: - Actions
    @IBAction func levelButtonAction(_ sender: UIButton) {
        self.delegate?.configureLevel(number: self.number)
        CurrentLevel.currentPlayingLevel = self.number
    }

}
