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
    
    public var viewController: GameViewController?
    
    //MARK: Scene TileMapNodes
    public var isPlaying = false
    
    var playButton:UIButton!
    var menuButton:UIButton!
    var restartButton:UIButton!
    var menu:UIView!
    var endGameView:UIView!
    
    
    var poringo:PoringoNode!
    var light:SKLightNode!
    var color:SKSpriteNode!
    
    var initColumn:Int!
    var initRow:Int!
    var initDirection:Direction!
    var totalFoodNeeded:Double!
    var timeToFinish:Int!
    var level:Int!
    
    var pause = true
    
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
        setupUI()
        
    }
    
    //MARK: - Update
    override func update(_ currentTime: TimeInterval) {
        if !pause{
            if !color.hasActions(){
                color.run(SKAction.colorize(with: UIColor.blue, colorBlendFactor: 1, duration: TimeInterval(timeToFinish)))
            }
            poringo.update(tileMap: roadTileMapNode)
            light.ambientColor = color.color
            if poringo.position.y == roadTileMapNode.centerOfTile(atColumn: 0, row: roadTileMapNode.numberOfColumns - 1).y{
                isPlaying = false
            }
            
            if poringo.finished{
                if CurrentLevel.currentPlayingLevel == CurrentLevel.number && poringo.won {
                    CurrentLevel.set(number: CurrentLevel.number + 1)
                }
                endGame()
            }
        }
        
    }
    
    //MARK: - SETUP
    
    func setupUI(){
        //Play Button
        playButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 40))
        playButton.setBackgroundImage(#imageLiteral(resourceName: "Play Button"), for: .normal)
        playButton.setBackgroundImage(#imageLiteral(resourceName: "PlayButton_Selected"), for: .selected)
        playButton.layer.position = CGPoint(x: 60, y: 36)
        playButton.addTarget(self, action: #selector(go(_:)), for: .touchUpInside)
        self.view?.addSubview(playButton)
        
        
        //Menu
        menu = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 250))
        menu.layer.cornerRadius = CGFloat(10)
        menu.center = CGPoint(x: (self.view?.bounds.width)!/2, y: (self.view?.bounds.height)!/2)
        menu.backgroundColor = UIColor.red
        menu.isHidden = true
        
        let levelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 128, height: 40))
        levelButton.center = CGPoint(x: menu.bounds.width/2 - 74, y: menu.bounds.height/2 + 50)
        levelButton.backgroundColor = UIColor.black
        levelButton.addTarget(self, action: #selector(toLevel(_:)), for: .touchUpInside)
        menu.addSubview(levelButton)
        self.view?.addSubview(menu)
        
        let continueButton = UIButton(frame: CGRect(x: 0, y: 0, width: 128, height: 40))
        continueButton.center = CGPoint(x: menu.bounds.width/2 + 74, y: menu.bounds.height/2 + 50)
        continueButton.backgroundColor = UIColor.black
        continueButton.addTarget(self, action: #selector(hideMenu(_:)), for: .touchUpInside)
        menu.addSubview(continueButton)
        self.view?.addSubview(menu)
        
        //Menu Button
        menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 40))
        menuButton.backgroundColor = UIColor.red
        menuButton.addTarget(self, action: #selector(showMenu(_:)), for: .touchUpInside)
        menuButton.center = CGPoint(x: (self.view?.bounds.width)! - 60, y: 36)
        self.view?.addSubview(menuButton)
        
        
        //Restart Button
        restartButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        restartButton.layer.cornerRadius = 50
        restartButton.backgroundColor = UIColor.red
        restartButton.addTarget(self, action: #selector(restart(_:)), for: .touchUpInside)
        restartButton.center = CGPoint(x: (self.view?.bounds.width)! - 130, y: 36)
        self.view?.addSubview(restartButton)
        
    }
    
    
    func setupUserData(){
        if let level = self.userData?.value(forKey: "level") as? Int{
            self.level = level
        }
        if let timeToFinish = self.userData?.value(forKey: "timeToFinish") as? Int{
            self.timeToFinish = timeToFinish
        }else{
            self.timeToFinish = 1000
        }
        if let totalFoodNeeded = self.userData?.value(forKey: "totalFoodNeeded") as? Float{
            self.totalFoodNeeded = Double(totalFoodNeeded)
        }
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
    
    func setupPoringo(){
        //Setup Poringo
        let position = roadTileMapNode.centerOfTile(atColumn: initColumn, row: initRow)
        let size = CGSize(width: 64, height: 64)
        poringo = PoringoNode(moveDistance: 64, timeToCompleteMove: 0.25, initialDirection: initDirection, position: position, size: size, totalFoodNeeded: totalFoodNeeded)
        poringo.zPosition = 4
        poringo.lightingBitMask = 1
        self.addChild(poringo)
    }
    
    func setupNodes(){
        setupPoringo()
        
        roadTileMapNode.lightingBitMask = 1
        grassTileMapNode.lightingBitMask = 1
        
        
        light = SKLightNode()
        light.ambientColor = UIColor.white
        light.falloff = -50
        
        self.addChild(light)
        
        color = SKSpriteNode(color: UIColor.white, size: CGSize(width: 0, height: 0))
        self.addChild(color)
        
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
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        let location = touches.first?.location(in: self)
        guard let touch = touches.first else { return }
        if pause{
            ArrowTileSwitch.toNextArrow(for: touch, in: roadTileMapNode, ruledBy: directionsTileMapNode)
        }
    }
    
    func endGame(){
        pause = true
        //End Game Menu
        endGameView = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 250))
        endGameView.layer.cornerRadius = CGFloat(10)
        endGameView.center = CGPoint(x: (self.view?.bounds.width)!/2, y: (self.view?.bounds.height)!/2)
        endGameView.backgroundColor = UIColor.red
        
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 128, height: 40))
        menuButton.center = CGPoint(x: endGameView.bounds.width/2 - 74, y: endGameView.bounds.height/2 + 50)
        menuButton.backgroundColor = UIColor.black
        menuButton.addTarget(self, action: #selector(toLevel(_:)), for: .touchUpInside)
        endGameView.addSubview(menuButton)
        
        if poringo.won{
            let nextButton = UIButton(frame: CGRect(x: 0, y: 0, width: 128, height: 40))
            nextButton.center = CGPoint(x: endGameView.bounds.width/2 + 74, y: endGameView.bounds.height/2 + 50)
            nextButton.backgroundColor = UIColor.black
            nextButton.addTarget(self, action: #selector(toNextLevel(_:)), for: .touchUpInside)
            endGameView.addSubview(nextButton)
            
            let poringoView = UIImageView(image: #imageLiteral(resourceName: "Porigo_Idle"))
            poringoView.center = CGPoint(x: endGameView.bounds.width/2, y: endGameView.bounds.height/2 - 40)
            poringoView.bounds.size = CGSize(width: 100, height: 100)
            endGameView.addSubview(poringoView)
        }else{
            let poringoView = UIImageView(image: #imageLiteral(resourceName: "Porigo_Idle"))
            poringoView.center = CGPoint(x: endGameView.bounds.width/2, y: endGameView.bounds.height/2 - 40)
            poringoView.bounds.size = CGSize(width: 100, height: 100)
            endGameView.addSubview(poringoView)
            
            self.view?.addSubview(endGameView)
        }
    }
    
    func go(_ sender: Any) {
        self.run(SKAction.playSoundFileNamed("tap", waitForCompletion: false))
        pause = false
        isPlaying = true
        playButton.isHidden = true
    }
    
    func restart(_ sender: Any) {
        self.run(SKAction.playSoundFileNamed("tap", waitForCompletion: false))
        poringo.removeFromParent()
        poringo = nil
        pause = true
        isPlaying = false
        playButton.isHidden = false
        
        setupPoringo()
    }
    
    func showMenu(_ sender: Any){
        self.run(SKAction.playSoundFileNamed("tap", waitForCompletion: false))
        pause = true
        menu.isHidden = false
        menuButton.isHidden = true
        restartButton.isHidden = true
        playButton.isHidden = true
    }
    
    func hideMenu(_ sender: Any){
        self.run(SKAction.playSoundFileNamed("tap", waitForCompletion: false))
        pause = false
        menu.isHidden = true
        menuButton.isHidden = false
        restartButton.isHidden = false
        if isPlaying {
            playButton.isHidden = false
            pause = false
        }
    }
    
    func toNextLevel(_ sender: Any){
        
        self.endGameView.removeFromSuperview()
        
        if let view = self.viewController?.view as? SKView {
            if let scene = SKScene(fileNamed: "level_\(level+1)") as? GameScene {
                scene.viewController = viewController
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
        }else{
            toLevel(sender)
        }
    }
    
    func toLevel(_ sender: Any){
        self.run(SKAction.playSoundFileNamed("tap", waitForCompletion: false))
        viewController?.dismiss(animated: true, completion: nil)
        //        guard let levelMenu = viewController?.storyboard?.instantiateViewController(withIdentifier: "LevelsMenu") as? LevelsMenuCollectionViewController else { return }
        //        viewController?.show(levelMenu, sender: viewController)
    }
    
    func toHome(_ sender: Any){
        
        guard let home = viewController?.storyboard?.instantiateViewController(withIdentifier: "HomeScreen") as? HomeViewController else { return }
        viewController?.show(home, sender: viewController)
        viewController?.dismiss(animated: true, completion: nil)
    }
}
