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

    let modelScale : Float = 50.0
    let characterSpeedFactor : Float = (2/1.3)
    let initialY : Float = 15.0
    
    
    var playerChildNode : SCNNode!
    let playerScene = SCNScene(named: "art.scnassets/panda.scn")
    
    var direction : Float!
    var walk : Bool!
    
    var idleAnimation : CAAnimation!
    var walkAnimation : CAAnimation!
    
    override init(){
        
        
        let playerMaterial = SCNMaterial()
        playerMaterial.diffuse.contents = UIImage(named: "art.scnassets/max_diffuse.png")
        playerMaterial.locksAmbientWithDiffuse = false
       
        playerChildNode = playerScene!.rootNode.childNodes[0]
        //playerChildNode = playerScene!.rootNode.childNodeWithName("Frog", recursively: false)!
        //playerChildNode.geometry!.firstMaterial = playerMaterial
        playerChildNode.scale = SCNVector3Make(playerChildNode.scale.x * modelScale, playerChildNode.scale.y * modelScale, playerChildNode.scale.z * modelScale)
        
        playerChildNode.enumerateChildNodesUsingBlock { (child, stop) -> Void in
            for key in child.animationKeys {
                let animation = child.animationForKey(key)
                
                animation?.usesSceneTimeBase = false
                animation?.repeatCount = Float.infinity
                child.addAnimation(animation!, forKey: key)
            }
        }
        
        walk = false
        
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
        
        // Load and configure the walk animation
        walkAnimation = loadAnimationFromSceneNamed("art.scnassets/walk.scn")
        walkAnimation.usesSceneTimeBase = false
        walkAnimation.fadeInDuration = 0.3
        walkAnimation.fadeOutDuration = 0.3
        walkAnimation.repeatCount = Float.infinity
        walkAnimation.speed = characterSpeedFactor
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setDirectionAndRotate(dir:Float){
        
        if (direction != dir){
            direction = dir
            //rotacao adicionada em  180 graus
            playerChildNode.runAction(SCNAction.rotateToX(0, y: CGFloat(dir), z: 0, duration: 0.1, shortestUnitArc: true))
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
    
    func setWalking (walk : Bool) {
        if (self.walk != walk) {
            self.walk = walk;
            
            // Update node animation.
            if walk {
                self.playerChildNode.addAnimation(walkAnimation, forKey: "walk")
            }
            else {
                //fade out duration
                print("stopped walking")
                self.playerChildNode.removeAnimationForKey("walk", fadeOutDuration: 0.2)
            }
        }
    }
    
    func loadAnimationFromSceneNamed(path : String) -> CAAnimation? {
        
        let scene = SCNScene(named: path)
        
        var animation : CAAnimation?
        
        
        scene?.rootNode.enumerateChildNodesUsingBlock { (child, stop) -> Void in
            
            if child.animationKeys.count > 0 {
                animation = child.animationForKey(child.animationKeys[0])
                stop.memory = true
            }
        }
        
        return animation
    }

    func updateWalkSpeed(speedFactor : Float) {
        let wasWalking = walk!
        
        if wasWalking {
            walk = false
        }
        
        walkAnimation.speed = characterSpeedFactor * speedFactor
        
        if wasWalking {
            walk = true
        }
    }

}