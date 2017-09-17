//
//  LevelsMenuHeaderCollectionReusableView.swift
//  Poringo
//
//  Created by Erick Borges on 16/09/17.
//  Copyright © 2017 Erick Borges. All rights reserved.
//

protocol LevelsMenuBackButtonDelegate {
    func goBack()
}

import UIKit

class LevelsMenuHeaderCollectionReusableView: UICollectionReusableView {
    
    var delegate:LevelsMenuBackButtonDelegate?
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.delegate?.goBack()
    }  
    
}
