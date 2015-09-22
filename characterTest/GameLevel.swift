//
//  GameLevel.swift
//  characterTest
//
//  Created by Marcel de Siqueira Campos Rebouças on 9/18/15.
//  Copyright © 2015 mscr. All rights reserved.
//

import SceneKit

class GameLevel: CustomStringConvertible {
 
    let segmentSize: Float = 0.2
    var maxObstaclesPerRow: Int = 3
    var width : Int
    var height : Int
    // Outputs the data structure to the console - great for debugging
    
    var description: String {
        return "\(width) \(height)"
    }
    
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    
    func setupLevelAtPosition(position: SCNVector3, parentNode: SCNNode) {
        
        let levelNode = SCNNode()
        
        // Create light grass material
        let lightGrassMaterial = SCNMaterial()
        lightGrassMaterial.diffuse.contents = UIColor(red: 190.0/255.0, green: 244.0/255.0, blue: 104.0/255.0, alpha: 1.0)
        lightGrassMaterial.locksAmbientWithDiffuse = false
        
        
        let floorGeometry = SCNBox(width: CGFloat(width), height: 10.0, length: CGFloat(height), chamferRadius: 0.0)
        floorGeometry.firstMaterial = lightGrassMaterial
        
        let floorNode = SCNNode(geometry: floorGeometry)
        floorNode.position = SCNVector3Make(0, 0, 0)
        levelNode.addChildNode(floorNode)
        
        levelNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Kinematic, shape: SCNPhysicsShape(geometry: floorGeometry, options: nil))
        levelNode.physicsBody?.categoryBitMask = CollisionCategory.Ground.rawValue
        levelNode.physicsBody?.collisionBitMask = CollisionCategory.Player.rawValue
        

        // Combine all the geometry into one - this will reduce the number of draw calls and improve performance
        let flatLevelNode = levelNode.flattenedClone()
        flatLevelNode.name = "Level"
        
        // Add the flattened node
        parentNode.position = position
        parentNode.addChildNode(flatLevelNode)
    }
}
