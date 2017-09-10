//
//  GameScene.swift
//  Poringo
//
//  Created by Erick Borges on 09/09/17.
//  Copyright © 2017 Erick Borges. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //MARK: Scene TileMapNodes
    var waterTileMapNode:SKTileMapNode! // z = 0
    var grassTileMapNode:SKTileMapNode! // z = 1
    var roadTileMapNode:SKTileMapNode!  // z = 2
    
    var panGestureRecognizer:UIPanGestureRecognizer!
    var translation:CGPoint = .zero
    
    override func didMove(to view: SKView) {
        // -- SETUP
        setupCamera()
        setupPanGesture()
        instantiateTileMapNodes()
    }
    
    //MARK: - SETUP
    
    /**
     Instantiate every TileMapNode in the scene, and store it in a class atribute.
     */
    func instantiateTileMapNodes() {
        guard let waterTileMapNode = childNode(withName: "Water")
            as? SKTileMapNode else {
                fatalError("Water Background node not loaded")
        }
        guard let grassTileMapNode = childNode(withName: "Grass")
            as? SKTileMapNode else {
                fatalError("Grass Background node not loaded")
        }
        guard let roadTileMapNode = childNode(withName: "Road")
            as? SKTileMapNode else {
                fatalError("Road node not loaded")
        }
        
        self.waterTileMapNode = waterTileMapNode
        self.grassTileMapNode = grassTileMapNode
        self.roadTileMapNode = roadTileMapNode
    }
    
    /**
     Setup a SKCameraNode to be the scene camera.
     */
    func setupCamera(){
        let camera = SKCameraNode()
        self.camera = camera
        self.addChild(camera)
    }
    
    /**
     Setup a UIPanGestureRecognizer that will respond to handlePan(recognizer:)
     */
    func setupPanGesture() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
        self.view?.addGestureRecognizer(panGestureRecognizer)
    }
    
    /**
     Uses the pan gesture translation to drag the camera around the SKTileMapNode. The camera translation is limited by the largest SKTileMapNode frame, so it can't go outo of bounds.
     
     The translation is cumullative, it is a bidimencoinal vector that represents how much the user has dragged it's finger through the screen. In order to make the camera follow the user finger, the method has to reset the translation value everytime it's called. In this specific case the translation is reseted everytime the method is called, and it's state is either .changed or .ended.
     
     
     - Parameters:
     
        - recognizer: The UIPanGestureRecognizer that manages the camera drag.
     
    */
    @objc
    func handlePan(recognizer: UIPanGestureRecognizer){
        let cameraLimitX = self.waterTileMapNode.frame.width/2 - self.frame.width/2
        let cameraLimitY = self.waterTileMapNode.frame.height/2 - self.frame.height/2
        
        if (recognizer.state == .began) {
            
        } else if (recognizer.state == .changed) {
            translation = recognizer.translation(in: recognizer.view)
            
            if ((camera?.position.x)! > cameraLimitX) {
                camera?.position.x = cameraLimitX
            } else{
                camera?.position.x = (camera?.position.x)! - (translation.x * 1.3)
            }
            
            if ((camera?.position.x)! < -cameraLimitX) {
                camera?.position.x = -cameraLimitX
            } else{
                camera?.position.x = (camera?.position.x)! - (translation.x * 1.3)
            }
            
            if ((camera?.position.y)! > cameraLimitY) {
                camera?.position.y = cameraLimitY
            } else {
                camera?.position.y = (camera?.position.y)! + (translation.y * 1.3)
            }
            
            if ((camera?.position.y)! < -cameraLimitY) {
                camera?.position.y = -cameraLimitY
            } else {
                camera?.position.y = (camera?.position.y)! + (translation.y * 1.3)
            }
            // reset the recognizer translation
            recognizer.setTranslation(.zero, in: recognizer.view)
        } else if (recognizer.state == .ended){
            
            if ((camera?.position.x)! > cameraLimitX) {
                camera?.position.x = cameraLimitX
            }
            
            if ((camera?.position.x)! < -cameraLimitX) {
                camera?.position.x = -cameraLimitX
            }
            
            if ((camera?.position.y)! > cameraLimitY) {
                camera?.position.y = cameraLimitY
            }
            
            if ((camera?.position.y)! < -cameraLimitY) {
                camera?.position.y = -cameraLimitY
            }
            
        }
    }
    
    //MARK: - Update
    override func update(_ currentTime: TimeInterval) {
        
    }
    
}
