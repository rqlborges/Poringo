//
//  PoringoNode.swift
//  Poringo
//
//  Created by Ricardo Sousa on 09/09/17.
//  Copyright © 2017 Erick Borges. All rights reserved.
//

import UIKit
import SpriteKit

class PoringoNode: SKSpriteNode {
    
    private var moveDistance:Float?
    
    private var action:SKAction?
    
    private var timeToCompleteMove:TimeInterval?
    
    private var totalFoodNeeded:Double?
    
    public var finished = false
    
    public var won = false
    //    private var lastColumnPosition:Int = 0
    //    private var lastRowPosition:Int = 0
    private var lastDirection:Direction?
    
    public var totalFoodEaten:Double = 0
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    /**
     Instantiates a Poringo Node
     
     
     - Parameters:
     
     - moveDistance: The distance Poringo should move. It should be equal to your tile size.
     - initialDirection: The direction which poringo should head first.
     - position: Center of the tile poringo should start.
     - size: Poringo's size.
     */
    public init(moveDistance:Float, timeToCompleteMove:TimeInterval, initialDirection:Direction, position:CGPoint, size:CGSize, totalFoodNeeded:Double){
        let texture = SKTexture(image: #imageLiteral(resourceName: "Porigo_Idle"))
        super.init(texture: texture, color: UIColor.green, size: size)
        self.moveDistance = moveDistance
        self.position = position
        self.timeToCompleteMove = timeToCompleteMove
        self.totalFoodNeeded = totalFoodNeeded
        
        
        self.action = getAction(from: initialDirection)
        
    }
    
    /**
     Should be called on every update.
     
     
     */
    public func update(tileMap:SKTileMapNode){
        if !finished {
            
            let pos = tileMap.convert(position, from: self.parent!)
            
            let column = tileMap.tileColumnIndex(fromPosition: pos)
//            print(column)
            let row = tileMap.tileRowIndex(fromPosition: pos)
//            print(row)
            
            let tile = tileMap.tileDefinition(atColumn: column, row: row)
            
            if let arrow = tile?.userData?.value(forKey: "direction") as? Int{
                action = getAction(from: Direction(rawValue: arrow)!)
                if !(self.hasActions()){
                    self.run(action!)
                }
            }else if let _ = tile?.userData?.value(forKey: "finish"){
                if !(self.hasActions()){
                    if totalFoodEaten == totalFoodNeeded {
                        won = true
                        finished = true
                        print("GANHOU")
                    }else{
                        print("PERDEU")
                        finished = true
                    }
                }
            }else if let num = tile?.userData?.value(forKey: "num") as? Double{
                let signal = tile?.userData?.value(forKey: "signal") as! String
                if !(self.hasActions()){
                    totalFoodEaten = calculate(with: num, signal: signal)
                    action = getAction(from: getNextDirection(tileMap: tileMap, column: column, row: row)!)
                    self.run(action!)
                }
            }else if let _ = tile?.userData?.value(forKey: "road"){
                if !(self.hasActions()){
                    action = getAction(from: getNextDirection(tileMap: tileMap, column: column, row: row)!)
                    self.run(action!)
                    
                }
            }
            
        }
    }
    
    func calculate(with num:Double, signal:String) -> Double{
        switch signal {
        case "plus":
            return totalFoodEaten + num
        case "minus":
            return totalFoodEaten - num
        case "times":
            return totalFoodEaten * num
        case "dividedBy":
            return totalFoodEaten / num
        default:
            return 0
        }
    }
    
    private func getNextDirection(tileMap:SKTileMapNode, column:Int, row:Int) -> Direction?{
        
        if lastDirection == .right {
            if let _ = tileMap.tileDefinition(atColumn: column+1, row: row)?.userData?.value(forKey: "road"){
                
                return Direction.right
            }
            if let _ = tileMap.tileDefinition(atColumn: column+1, row: row)?.userData?.value(forKey: "direction"){
                
                return Direction.right
            }
            if let _ = tileMap.tileDefinition(atColumn: column+1, row: row)?.userData?.value(forKey: "num"){
                
                return Direction.right
            }
            if let _ = tileMap.tileDefinition(atColumn: column+1, row: row)?.userData?.value(forKey: "finish"){
                
                return Direction.right
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row+1)?.userData?.value(forKey: "road"){
                
                return Direction.up
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row+1)?.userData?.value(forKey: "direction"){
                
                return Direction.up
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row+1)?.userData?.value(forKey: "num"){
                
                return Direction.up
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row+1)?.userData?.value(forKey: "finish"){
                
                return Direction.up
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row-1)?.userData?.value(forKey: "road"){
                
                return Direction.down
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row-1)?.userData?.value(forKey: "direction"){
                
                return Direction.down
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row-1)?.userData?.value(forKey: "num"){
                
                return Direction.down
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row-1)?.userData?.value(forKey: "finish"){
                
                return Direction.down
            }
        }
        
        if lastDirection == .left {
            if let _ = tileMap.tileDefinition(atColumn: column-1, row: row)?.userData?.value(forKey: "road"){
                
                return Direction.left
            }
            if let _ = tileMap.tileDefinition(atColumn: column-1, row: row)?.userData?.value(forKey: "direction"){
                
                return Direction.left
            }
            if let _ = tileMap.tileDefinition(atColumn: column-1, row: row)?.userData?.value(forKey: "num"){
                
                return Direction.left
            }
            if let _ = tileMap.tileDefinition(atColumn: column-1, row: row)?.userData?.value(forKey: "finish"){
                
                return Direction.left
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row+1)?.userData?.value(forKey: "road"){
                
                return Direction.up
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row+1)?.userData?.value(forKey: "direction"){
                
                return Direction.up
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row+1)?.userData?.value(forKey: "num"){
                
                return Direction.up
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row+1)?.userData?.value(forKey: "finish"){
                
                return Direction.up
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row-1)?.userData?.value(forKey: "road"){
                
                return Direction.down
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row-1)?.userData?.value(forKey: "direction"){
                
                return Direction.down
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row-1)?.userData?.value(forKey: "num"){
                
                return Direction.down
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row-1)?.userData?.value(forKey: "finish"){
                
                return Direction.down
            }
        }
        
        if lastDirection == .up {
            if let _ = tileMap.tileDefinition(atColumn: column, row: row+1)?.userData?.value(forKey: "road"){
                
                return Direction.up
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row+1)?.userData?.value(forKey: "direction"){
                
                return Direction.up
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row+1)?.userData?.value(forKey: "num"){
                
                return Direction.up
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row+1)?.userData?.value(forKey: "finish"){
                
                return Direction.up
            }
            if let _ = tileMap.tileDefinition(atColumn: column-1, row: row)?.userData?.value(forKey: "road"){
                
                return Direction.left
            }
            if let _ = tileMap.tileDefinition(atColumn: column-1, row: row)?.userData?.value(forKey: "direction"){
                
                return Direction.left
            }
            if let _ = tileMap.tileDefinition(atColumn: column-1, row: row)?.userData?.value(forKey: "num"){
                
                return Direction.left
            }
            if let _ = tileMap.tileDefinition(atColumn: column-1, row: row)?.userData?.value(forKey: "finish"){
                
                return Direction.left
            }
            if let _ = tileMap.tileDefinition(atColumn: column+1, row: row)?.userData?.value(forKey: "road"){
                
                return Direction.right
            }
            if let _ = tileMap.tileDefinition(atColumn: column+1, row: row)?.userData?.value(forKey: "direction"){
                
                return Direction.right
            }
            if let _ = tileMap.tileDefinition(atColumn: column+1, row: row)?.userData?.value(forKey: "num"){
                
                return Direction.right
            }
            if let _ = tileMap.tileDefinition(atColumn: column+1, row: row)?.userData?.value(forKey: "finish"){
                
                return Direction.right
            }
        }
        
        if lastDirection == .down {
            if let _ = tileMap.tileDefinition(atColumn: column, row: row-1)?.userData?.value(forKey: "road"){
                
                return Direction.down
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row-1)?.userData?.value(forKey: "direction"){
                
                return Direction.down
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row-1)?.userData?.value(forKey: "num"){
                
                return Direction.down
            }
            if let _ = tileMap.tileDefinition(atColumn: column, row: row-1)?.userData?.value(forKey: "finish"){
                
                return Direction.down
            }
            if let _ = tileMap.tileDefinition(atColumn: column-1, row: row)?.userData?.value(forKey: "road"){
                
                return Direction.left
            }
            if let _ = tileMap.tileDefinition(atColumn: column-1, row: row)?.userData?.value(forKey: "direction"){
                
                return Direction.left
            }
            if let _ = tileMap.tileDefinition(atColumn: column-1, row: row)?.userData?.value(forKey: "num"){
                
                return Direction.left
            }
            if let _ = tileMap.tileDefinition(atColumn: column-1, row: row)?.userData?.value(forKey: "num"){
                
                return Direction.left
            }
            if let _ = tileMap.tileDefinition(atColumn: column+1, row: row)?.userData?.value(forKey: "road"){
                
                return Direction.right
            }
            if let _ = tileMap.tileDefinition(atColumn: column+1, row: row)?.userData?.value(forKey: "direction"){
                
                return Direction.right
            }
            if let _ = tileMap.tileDefinition(atColumn: column+1, row: row)?.userData?.value(forKey: "num"){
                
                return Direction.right
            }
            if let _ = tileMap.tileDefinition(atColumn: column+1, row: row)?.userData?.value(forKey: "finish"){
                
                return Direction.right
            }
        }
        
        return nil
    }
    
    private func getAction(from direction:Direction) -> SKAction?{
        var action:SKAction?
        switch direction {
        case .left:
            lastDirection = .left
            
            action = SKAction.sequence([SKAction.move(by: CGVector(dx: Int(-moveDistance!), dy: 0), duration: timeToCompleteMove!),SKAction.wait(forDuration: timeToCompleteMove!), SKAction.run({self.removeAllActions()})])
        case .up:
            lastDirection = .up
            action = SKAction.sequence([SKAction.move(by: CGVector(dx: 0, dy: Int(moveDistance!)), duration: timeToCompleteMove!),SKAction.wait(forDuration: timeToCompleteMove!), SKAction.run({self.removeAllActions()})])
        case .right:
            lastDirection = .right
            action = SKAction.sequence([SKAction.move(by: CGVector(dx: Int(moveDistance!), dy: 0), duration: timeToCompleteMove!),SKAction.wait(forDuration: timeToCompleteMove!), SKAction.run({self.removeAllActions()})])
        case .down:
            lastDirection = .down
            action = SKAction.sequence([SKAction.move(by: CGVector(dx: 0, dy: Int(-moveDistance!)), duration: timeToCompleteMove!),SKAction.wait(forDuration: timeToCompleteMove!), SKAction.run({self.removeAllActions()})])
        }
        
        return action
    }
    
}
