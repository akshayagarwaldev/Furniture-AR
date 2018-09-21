//
//  Furniture.swift
//  FurnitureAR
//
//  Created by Apple on 17/05/18.
//  Copyright © 2018 hustle. All rights reserved.
//


import Foundation
import SceneKit

class Furniture {
    
    class func getfurnitureForName(furnitureName: String) -> SCNNode {
        switch furnitureName{
        case "Sofa":
            return Furniture.getSofa()
        case "Sofa Chair":
            return Furniture.getSofaChair()
        case "Chair":
            return Furniture.getChair()
        case "Table":
            return Furniture.getTable()
        default:
            return Furniture.getSofa()
        }
    }
    
    class func getSofa() -> SCNNode {
        let sofaNode = SCNNode()
        
        guard let carScene = SCNScene(named: "art.scnassets/chair.DAE") else { return sofaNode }
        let carSceneChildNodes = carScene.rootNode.childNodes
        
        for childNode in carSceneChildNodes {
            sofaNode.addChildNode(childNode)
        }
        sofaNode.scale = SCNVector3(0.005, 0.005, 0.005)
        sofaNode.position = SCNVector3Make(-1, 0.7, -1)
        sofaNode.name = "pipe"
        return sofaNode
    }
    
    class func getSofaChair() -> SCNNode {
        let sofaNode = SCNNode()
        
        guard let carScene = SCNScene(named: "art.scnassets/LongChair.dae") else { return sofaNode }
        let carSceneChildNodes = carScene.rootNode.childNodes
        
        for childNode in carSceneChildNodes {
            sofaNode.addChildNode(childNode)
        }
        sofaNode.scale = SCNVector3(0.35, 0.35, 0.35)
        sofaNode.position = SCNVector3Make(-0.75, -0.55, -1)
        sofaNode.name = "pyramid"
        return sofaNode
    }
    
    class func getChair() -> SCNNode {
        let obj = SCNScene(named: "art.scnassets/Wood_Table.dae")
        let node = obj?.rootNode.childNode(withName: "Wood_Table", recursively: true)!
        node?.scale = SCNVector3Make(100, 100, 100)
        node?.position = SCNVector3Make(-1, -2.2, -1)
        node?.name = "quarter"
        return node!
        
    }
    
    class func getTable() -> SCNNode {
        let obj = SCNScene(named: "art.scnassets/Wood_Table.dae")
        let node = obj?.rootNode.childNode(withName: "Wood_Table", recursively: true)!
        node?.scale = SCNVector3Make(100, 100, 100)
        node?.position = SCNVector3Make(-1, -2.2, -1)
        node?.name = "quarter"
        return node!
        
    }

}

