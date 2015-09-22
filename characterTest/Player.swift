//
//  Character.swift
//  characterTest
//
//  Created by Marcel de Siqueira Campos Rebouças on 9/18/15.
//  Copyright © 2015 mscr. All rights reserved.
//

import Foundation
import SceneKit

class Player : SCNNode {

    let modelScale : Float = 100.0
    let initialY : Float = 15.0
    
    
    var playerChildNode : SCNNode!
    let playerScene = SCNScene(named: "art.scnassets/frog.dae")
    //let playerScene = SCNScene(named: "art.scnassets/char.dae")
    
    var direction : Float!
    
    var idleAnimation : CAAnimation!
    var walkAnimation : CAAnimation!
    
    override init(){
        
        let playerMaterial = SCNMaterial()
        playerMaterial.diffuse.contents = UIImage(named: "art.scnassets/model_texture.tga")
        playerMaterial.locksAmbientWithDiffuse = false
       
        
        playerChildNode = playerScene!.rootNode.childNodeWithName("Frog", recursively: false)!
        //playerChildNode = playerScene!.rootNode.childNodeWithName("pCube1", recursively: false)!
        playerChildNode.geometry!.firstMaterial = playerMaterial
        playerChildNode.scale = SCNVector3Make(playerChildNode.scale.x * modelScale, playerChildNode.scale.y * modelScale, playerChildNode.scale.z * modelScale)
 
        super.init()
        
        self.name = "Player"
        self.position.y = initialY
        self.addChildNode(playerChildNode)
        self.direction = 0.0
        
        let boundingBoxSize = sizeOfBoundingBoxFromNode(playerChildNode)
        print("Player bounding box \(boundingBoxSize)")
        
        
        self.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Kinematic, shape: SCNPhysicsShape(geometry: SCNBox(width: CGFloat(boundingBoxSize.width * modelScale), height: CGFloat(boundingBoxSize.height * modelScale), length: CGFloat(boundingBoxSize.depth * modelScale), chamferRadius: 0), options: nil))
        
        self.physicsBody?.categoryBitMask = CollisionCategory.Player.rawValue
        self.physicsBody?.collisionBitMask = CollisionCategory.Ground.rawValue
        self.physicsBody?.contactTestBitMask = CollisionCategory.Ground.rawValue
        
        
        //idleAnimation = self.loa
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setDirectionAndRotate(dir:Float){
        
        if (direction != dir){
            direction = dir
            //rotacao adicionada em  180 graus
            playerChildNode.runAction(SCNAction.rotateToX(0, y: CGFloat(Float(M_PI) + dir), z: 0, duration: 0.1, shortestUnitArc: true))
        }
    }
    
    func sizeOfBoundingBoxFromNode(node: SCNNode) -> (width: Float, height: Float, depth: Float) {
        var boundingBoxMin = SCNVector3Zero
        var boundingBoxMax = SCNVector3Zero
        _ = node.getBoundingBoxMin(&boundingBoxMin, max: &boundingBoxMax)
        
        let width = boundingBoxMax.x - boundingBoxMin.x
        let height = boundingBoxMax.y - boundingBoxMin.y
        let depth = boundingBoxMax.z - boundingBoxMin.z
        
        return (width, height, depth)
    }
}