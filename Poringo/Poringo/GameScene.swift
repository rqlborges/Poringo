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
    var rightPanel:UIView!
    var restartButton:UIButton!
    var menu:UIView!
    var endGameView:UIView!
    var placar:UIImageView!
    
    
    var poringo:PoringoNode!
    var light:SKLightNode!
    var color:SKSpriteNode!
    
    var initColumn:Int!
    var initRow:Int!
    var initDirection:Direction!
    var initFood:Int!
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
        
        //        MusicHelper.sharedHelper.playLevelMusic()
    }
    
    //MARK: - Update
    override func update(_ currentTime: TimeInterval) {
        if !pause{
            if !color.hasActions(){
                color.run(SKAction.colorize(with: UIColor.blue, colorBlendFactor: 1, duration: TimeInterval(timeToFinish)))
            }
            poringo.update(tileMap: roadTileMapNode, directionsTileMapNode)
            setupPlacar()
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
        playButton = UIButton(frame: CGRect(x: 0, y: 0, width: 62, height: 64))
        playButton.setBackgroundImage(#imageLiteral(resourceName: "Go_Button"), for: .normal)
        //        playButton.setBackgroundImage(#imageLiteral(resourceName: "PlayButton_Selected")s, for: .selected)
        playButton.frame.origin = CGPoint(x: 188, y: -9)
        playButton.addTarget(self, action: #selector(go(_:)), for: .touchUpInside)
        self.view?.addSubview(playButton)
        
        
        //Menu
        menu = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 250))
        menu.layer.cornerRadius = CGFloat(10)
        menu.center = CGPoint(x: (self.view?.bounds.width)!/2, y: (self.view?.bounds.height)!/2)
        menu.backgroundColor = UIColor(red:0.91, green:0.49, blue:0.13, alpha:1.0)
        menu.isHidden = true
        
        let levelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 128, height: 40))
        levelButton.center = CGPoint(x: menu.bounds.width/2 - 90, y: menu.bounds.height/2)
        levelButton.addTarget(self, action: #selector(toLevel(_:)), for: .touchUpInside)
        let levelImage = UIImageView(image: #imageLiteral(resourceName: "LevelsMenu_Button"))
        levelImage.layer.position = CGPoint(x: levelButton.bounds.width/2, y: levelButton.bounds.height/2)
        levelImage.sizeThatFits(CGSize(width: 64, height: 64))
        levelButton.addSubview(levelImage)
        
        menu.addSubview(levelButton)
        
        let continueButton = UIButton(frame: CGRect(x: 0, y: 0, width: 128, height: 40))
        continueButton.center = CGPoint(x: menu.bounds.width/2 + 90, y: menu.bounds.height/2)
        continueButton.addTarget(self, action: #selector(hideMenu(_:)), for: .touchUpInside)
        let continueImage = UIImageView(image: #imageLiteral(resourceName: "NextLevel_Button"))
        continueImage.layer.position = CGPoint(x: continueButton.bounds.width/2, y: continueButton.bounds.height/2)
        continueImage.sizeThatFits(CGSize(width: 64, height: 64))
        continueButton.addSubview(continueImage)
        
        menu.addSubview(continueButton)
        
        
        //Restart Button
        restartButton = UIButton(frame: CGRect(x: 0, y: 0, width: 128, height: 40))
        restartButton.center = CGPoint(x: menu.bounds.width/2, y: menu.bounds.height/2)
        restartButton.addTarget(self, action: #selector(restart(_:)), for: .touchUpInside)
        let restartImage = UIImageView(image: #imageLiteral(resourceName: "Restart_Button"))
        restartImage.layer.position = CGPoint(x: restartButton.bounds.width/2, y: restartButton.bounds.height/2)
        restartImage.sizeThatFits(CGSize(width: 64, height: 64))
        restartButton.addSubview(restartImage)
        
        menu.addSubview(restartButton)
        
        self.view?.addSubview(menu)
        
        
        
        //Menu Button
        rightPanel = UIView(frame: CGRect(x: 563, y: -5, width: 109, height: 67))
        let rightPanelBg = UIImageView(image: #imageLiteral(resourceName: "Right_Panel"))
        rightPanel.addSubview(rightPanelBg)
        
        let pauseButton = UIButton(frame: CGRect(x: 0, y: 0, width: 27, height: 31))
        pauseButton.setBackgroundImage(#imageLiteral(resourceName: "Pause_Button"), for: .normal)
        pauseButton.addTarget(self, action: #selector(showMenu(_:)), for: .touchUpInside)
        pauseButton.frame.origin = CGPoint(x: 65, y: 17)
        rightPanel.addSubview(pauseButton)
        
        let resetButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 34))
        resetButton.setBackgroundImage(#imageLiteral(resourceName: "Restart_Button"), for: .normal)
        resetButton.frame.origin = CGPoint(x: 15, y: 17)
        resetButton.addTarget(self, action: #selector(restart(_:)), for: .touchUpInside)
        rightPanel.addSubview(resetButton)
        
        
        self.view?.addSubview(rightPanel)
        
        //Placar 109x67
        
        //33 × 41
        
        placar = UIImageView(image: #imageLiteral(resourceName: "Left_Panel"))
        placar.frame.size = CGSize(width: 200, height: 67)
        placar.sizeThatFits(CGSize(width: 200, height: 67))
        placar.frame.origin = CGPoint(x: -14, y: -12)
        
        setupPlacar()
        
        self.view?.addSubview(placar)
        
    }
    
    func setupPlacar(){
        for num in placar.subviews{
            num.removeFromSuperview()
        }
        
        let signal = UIImageView(image: #imageLiteral(resourceName: "Green_Food"))
        signal.frame.origin = CGPoint(x: 30, y: 27)
        signal.frame.size = CGSize(width: 21, height: 21)
        
        var food = poringo.totalFoodEaten
        if food < 0 {
            food = abs(food)
            signal.image = #imageLiteral(resourceName: "Red_Food")
        }
        
        placar.addSubview(signal)
        
        
        var centena: String
        if food >= 100{
            centena = String(food).characters.map { String($0) }[2]
        }else{
            centena = "0"
        }
        let centenaImg = UIImageView(image: UIImage(named: centena))
        centenaImg.frame.origin = CGPoint(x: 60, y: 15)
        centenaImg.frame.size = CGSize(width: 33, height: 41)
        centenaImg.sizeThatFits(centenaImg.frame.size)
        placar.addSubview(centenaImg)
        
        var dezena: String
        if food >= 100{
            dezena = String(food).characters.map { String($0) }[1]
        }else if food >= 10{
            dezena = String(food).characters.map { String($0) }[0]
        }else{
            dezena = "0"
        }
        let dezenaImg = UIImageView(image: UIImage(named: String(dezena)))
        dezenaImg.frame.origin = CGPoint(x: 99, y: 15)
        dezenaImg.frame.size = CGSize(width: 33, height: 41)
        dezenaImg.sizeThatFits(dezenaImg.frame.size)
        placar.addSubview(dezenaImg)
        
        
        var unidade: String
        if food >= 100{
            unidade = String(food).characters.map { String($0) }[2]
        }else if food >= 10{
            unidade = String(food).characters.map { String($0) }[1]
        }else{
            unidade = String(food).characters.map { String($0) }[0]
        }
        let unidadeImg = UIImageView(image: UIImage(named: String(unidade)))
        unidadeImg.frame.origin = CGPoint(x: 138, y: 15)
        unidadeImg.frame.size = CGSize(width: 33, height: 41)
        unidadeImg.sizeThatFits(unidadeImg.frame.size)
        placar.addSubview(unidadeImg)
        
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
        poringo.zPosition = 100
        poringo.lightingBitMask = 1
        if let food = self.userData?.value(forKey: "initFood") as? Int{
            initFood = food
            self.poringo.totalFoodEaten = Double(initFood)
        }
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
        if !isPlaying{
            ArrowTileSwitch.toNextArrow(for: touch, in: roadTileMapNode, ruledBy: directionsTileMapNode, scene: self)
        }
    }
    
    func endGame(){
        pause = true
        restartButton.isHidden = true
        self.rightPanel.isHidden = true
        playButton.isHidden = true
        
        endGameView = UIView(frame: CGRect(x: 0, y: 0, width: 289, height: 187))
        var endGameBg:UIImageView?
        
        //End Game Menu
        if poringo.won{
            endGameView = UIView(frame: CGRect(x: 0, y: 0, width: 289, height: 187))
            endGameBg = UIImageView(image: #imageLiteral(resourceName: "Success_Message"))
        }else if poringo.totalFoodEaten > totalFoodNeeded {
            endGameBg = UIImageView(image: #imageLiteral(resourceName: "Fail_Message_exceed"))
        }else if poringo.totalFoodEaten < totalFoodNeeded{
            endGameBg = UIImageView(image: #imageLiteral(resourceName: "Fail_Message_below"))
        }else{
            endGameBg = UIImageView(image: #imageLiteral(resourceName: "Fail_Message_time"))
        }
        
        endGameView.addSubview(endGameBg!)
        
        endGameView.center = CGPoint(x: (self.view?.bounds.width)!/2, y: (self.view?.bounds.height)!/2)
        
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 45, height: 46))
        menuButton.center = CGPoint(x: endGameView.bounds.width/2 - 74, y: endGameView.bounds.height/2 + 50)
        menuButton.setBackgroundImage(#imageLiteral(resourceName: "LevelsMenu_Button"), for: .normal)
        menuButton.addTarget(self, action: #selector(toLevel(_:)), for: .touchUpInside)
        endGameView.addSubview(menuButton)
        
        if poringo.won{
            let nextButton = UIButton(frame: CGRect(x: 0, y: 0, width: 59, height: 44))
            nextButton.center = CGPoint(x: endGameView.bounds.width/2 + 74, y: endGameView.bounds.height/2 + 50)
            nextButton.setBackgroundImage(#imageLiteral(resourceName: "NextLevel_Button"), for: .normal)
            nextButton.addTarget(self, action: #selector(toNextLevel(_:)), for: .touchUpInside)
            endGameView.addSubview(nextButton)
            
        }else{
            let nextButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 34))
            nextButton.center = CGPoint(x: endGameView.bounds.width/2 + 74, y: endGameView.bounds.height/2 + 50)
            nextButton.setBackgroundImage(#imageLiteral(resourceName: "Restart_Button"), for: .normal)
            nextButton.addTarget(self, action: #selector(restart(_:)), for: .touchUpInside)
            endGameView.addSubview(nextButton)

        }
        self.view?.addSubview(endGameView)
        
        
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
        hideMenu(sender)
        if let _ = endGameView{
            endGameView.isHidden = true
        }
        setupPoringo()
        setupPlacar()
    }
    
    func showMenu(_ sender: Any){
        self.run(SKAction.playSoundFileNamed("tap", waitForCompletion: false))
        pause = true
        menu.isHidden = false
        rightPanel.isHidden = true
        //        restartButton.isHidden = true
        playButton.isHidden = true
    }
    
    func hideMenu(_ sender: Any){
        self.run(SKAction.playSoundFileNamed("tap", waitForCompletion: false))
        menu.isHidden = true
        rightPanel.isHidden = false
        //        restartButton.isHidden = false
        playButton.isHidden = false
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
