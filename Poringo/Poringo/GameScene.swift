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
    var isPlaying = false
    
    var poringo:PoringoNode!
    var playButton:SKNode!
    
    var initColumn:Int!
    var initRow:Int!
    var initDirection:Direction!
    
    var directionsTileMapNode:SKTileMapNode!// z = 0
    var waterTileMapNode:SKTileMapNode!     // z = 1
    var grassTileMapNode:SKTileMapNode!     // z = 2
    var roadTileMapNode:SKTileMapNode!      // z = 3
    
    var panGestureRecognizer:UIPanGestureRecognizer!
    var translation:CGPoint = .zero
    
    override func didMove(to view: SKView) {
        // -- SETUP
        setupCamera()
        setupPanGesture()
        setupUserData()
        instantiateTileMapNodes()
        setupNodes()
        
    }
    
    //MARK: - Update
    override func update(_ currentTime: TimeInterval) {
        if isPlaying {
            poringo.update(tileMap: roadTileMapNode)
        }
    }
    
    //MARK: - SETUP
    
    func setupUserData(){
        if let column = self.userData?.value(forKey: "initColumn") as? Int{
            initColumn = column
        }
        if let row = self.userData?.value(forKey: "initRow") as? Int{
            initRow = row
        }
        if let direction = self.userData?.value(forKey: "initDirection") as? Int{
            initDirection = Direction(rawValue: direction)
        }else{
            initDirection = Direction.right
        }
    }
    
    
    /**
     Instantiate every TileMapNode in the scene, and store it in a class atribute.
     */
    func instantiateTileMapNodes() {
        guard let directionsTileMapNode = childNode(withName: "DirectionIndicators")
            as? SKTileMapNode else {
                fatalError("Direction Indicators node not loaded")
        }
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
        
        self.directionsTileMapNode = directionsTileMapNode 
        self.waterTileMapNode = waterTileMapNode
        self.grassTileMapNode = grassTileMapNode
        self.roadTileMapNode = roadTileMapNode
    }
    
    func setupNodes(){
        //Setup Poringo
        let position = roadTileMapNode.centerOfTile(atColumn: initColumn, row: initRow)
        
        let size = CGSize(width: 64, height: 64)
        poringo = PoringoNode(moveDistance: 64, timeToCompleteMove: 0.5, initialDirection: initDirection, position: position, size: size)
        poringo.zPosition = 4
        self.addChild(poringo)
        
        playButton = SKSpriteNode(color: UIColor.red, size: CGSize(width: 100, height: 44))
        playButton.position = CGPoint(x:self.frame.midX, y:self.frame.midX);
        playButton.zPosition = 5
        self.addChild(playButton)
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
//        ArrowTileSwitch.toNextArrow(for: touch, in: roadTileMapNode, ruledBy: directionsTileMapNode)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        // Check if the location of the touch is within the button's bounds
        if playButton.contains(location!) {
            isPlaying = true
            playButton.isHidden = true
        }
    }
    
    
}
