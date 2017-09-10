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
    static func toNextArrow(for touch:UITouch, in tileMapNode:SKTileMapNode) {
        
        let touchPosition = touch.location(in: tileMapNode)
        let row = tileMapNode.tileRowIndex(fromPosition: touchPosition)
        let column = tileMapNode.tileColumnIndex(fromPosition: touchPosition)
        let selectedTileGroup = tileMapNode.tileGroup(atColumn: column, row: row)
        
        if (selectedTileGroup?.name == "ArrowsTileGroup") {
            if let arrowTileGroup = tileMapNode.tileSet.tileGroups.first(where: {$0.name == "ArrowsTileGroup"}){
                let selectedTileDefinition = tileMapNode.tileDefinition(atColumn: column, row: row)
                if let selectedTileDefinitionDirection = selectedTileDefinition?.userData?.value(forKey: "direction") as? Int {
                    
                    switch selectedTileDefinitionDirection {
                    case Direction.left.rawValue:
                        guard let arrowTileDefinition = arrowTileGroup.rules.first?.tileDefinitions.first(where: {$0.name == "arrow_up"}) else { return }
                        tileMapNode.setTileGroup(arrowTileGroup, andTileDefinition: arrowTileDefinition, forColumn: column, row: row)
                    case Direction.up.rawValue:
                        guard let arrowTileDefinition = arrowTileGroup.rules.first?.tileDefinitions.first(where: {$0.name == "arrow_right"}) else { return }
                        tileMapNode.setTileGroup(arrowTileGroup, andTileDefinition: arrowTileDefinition, forColumn: column, row: row)
                    case Direction.right.rawValue:
                        guard let arrowTileDefinition = arrowTileGroup.rules.first?.tileDefinitions.first(where: {$0.name == "arrow_down"}) else { return }
                        tileMapNode.setTileGroup(arrowTileGroup, andTileDefinition: arrowTileDefinition, forColumn: column, row: row)
                    case Direction.down.rawValue:
                        guard let arrowTileDefinition = arrowTileGroup.rules.first?.tileDefinitions.first(where: {$0.name == "arrow_left"}) else { return }
                        tileMapNode.setTileGroup(arrowTileGroup, andTileDefinition: arrowTileDefinition, forColumn: column, row: row)
                    default:
                        print("Arrow tile switch failed")
                        return
                    }
                    
                }
            }
        }

        
    }
    
}
