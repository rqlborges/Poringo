//
//  ArrowTileSwitch.swift
//  RDRescue
//
//  Created by Erick Borges on 09/09/17.
//  Copyright © 2017 Caroline Begbie. All rights reserved.
//

import SpriteKit

/**
 A static class that manages the arrow tiles switch.
 */
class ArrowTileSwitch {
    
    /**
     If the touched tile is an arrow, this method will switch it to the next arrow.
     
     - Parameters:
     
     - touch: The input UITouch that has touched a tile.
     
     - tileMapNode: The tileMapNode that must contain an arrow tile to be modified.
     
     */
    static func toNextArrow(for touch:UITouch, in tileMapNode:SKTileMapNode, ruledBy directions:SKTileMapNode, scene:SKScene) {
        
        let touchPosition = touch.location(in: tileMapNode)
        let row = tileMapNode.tileRowIndex(fromPosition: touchPosition)
        let column = tileMapNode.tileColumnIndex(fromPosition: touchPosition)
        let selectedTileGroup = tileMapNode.tileGroup(atColumn: column, row: row)
        
        if (selectedTileGroup?.name == "ArrowsTileGroup") {
            scene.run(SKAction.playSoundFileNamed("click", waitForCompletion: false))
            if let arrowTileGroup = tileMapNode.tileSet.tileGroups.first(where: {$0.name == "ArrowsTileGroup"}){
                let selectedTileDefinition = tileMapNode.tileDefinition(atColumn: column, row: row)
                if var selectedTileDefinitionDirection = selectedTileDefinition?.userData?.value(forKey: "direction") as? Int {

                    var didSetArrow = false
                    
                    
                    
                    repeat{
                        
                        switch selectedTileDefinitionDirection {
                        case Direction.left.rawValue:
                            if (directions.tileGroup(atColumn: column, row: row + 1) != nil) {
                                guard let arrowTileDefinition = arrowTileGroup.rules.first?.tileDefinitions.first(where: {$0.name == "Arrow_Up"}) else { return }
                                tileMapNode.setTileGroup(arrowTileGroup, andTileDefinition: arrowTileDefinition, forColumn: column, row: row)
                                didSetArrow = true
                            } else {
//                                print("No Up indicator")
                                selectedTileDefinitionDirection = Direction.up.rawValue
                                break
                            }
                        case Direction.up.rawValue:
                            if (directions.tileGroup(atColumn: column + 1, row: row) != nil) {
                                guard let arrowTileDefinition = arrowTileGroup.rules.first?.tileDefinitions.first(where: {$0.name == "Arrow_Right"}) else { return }
                                tileMapNode.setTileGroup(arrowTileGroup, andTileDefinition: arrowTileDefinition, forColumn: column, row: row)
                                didSetArrow = true
                            } else {
//                                print("No Right indicator")
                                selectedTileDefinitionDirection = Direction.right.rawValue
                                break
                            }
                        case Direction.right.rawValue:
                            if (directions.tileGroup(atColumn: column, row: row - 1) != nil) {
                                guard let arrowTileDefinition = arrowTileGroup.rules.first?.tileDefinitions.first(where: {$0.name == "Arrow_Down"}) else { return }
                                tileMapNode.setTileGroup(arrowTileGroup, andTileDefinition: arrowTileDefinition, forColumn: column, row: row)
                                didSetArrow = true
                            } else {
//                                print("No Down indicator")
                                selectedTileDefinitionDirection = Direction.down.rawValue
                                break
                            }
                        case Direction.down.rawValue:
                            if (directions.tileGroup(atColumn: column - 1, row: row) != nil) {
                                guard let arrowTileDefinition = arrowTileGroup.rules.first?.tileDefinitions.first(where: {$0.name == "Arrow_Left"}) else { return }
                                tileMapNode.setTileGroup(arrowTileGroup, andTileDefinition: arrowTileDefinition, forColumn: column, row: row)
                                didSetArrow = true
                            } else {
//                                print("No Left indicator")
                                selectedTileDefinitionDirection = Direction.left.rawValue
                                break
                            }
                        default:
//                            print("Arrow tile switch failed")
                            return
                        }
                        
                    } while (didSetArrow == false)
//                    print("Did set arrow")
                }
            }
        }
        
        
    }
    
}
