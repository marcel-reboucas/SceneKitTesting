//
//  GameScene.swift
//  characterTest
//
//  Created by Marcel de Siqueira Campos Rebouças on 9/18/15.
//  Copyright © 2015 mscr. All rights reserved.
//

import SceneKit
import SpriteKit

class GameScene : SCNScene, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    
    // MARK: Properties
    var sceneView: GameView!
    var inputHandler : InputHandler!
    
    var camera: SCNNode!
    var cameraOrthographicScale = 60.0
    var cameraOffsetFromPlayer = SCNVector3(x: 100, y: 100, z: 100)
    
    var levelData: GameLevel!
    var levelWidth = 200
    var levelHeight = 200
    
    var player: Player!
    
    // MARK: Updates
    var _previousUpdateTime : NSTimeInterval = 0.0
    
    // Simulate gravity
    var _accelerationY : Float = 0.0;
    
    // MARK: Init
    init(view: GameView) {
        sceneView = view
        inputHandler = InputHandler(scnView: sceneView)
        super.init()
        initializeLevel()
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    func initializeLevel() {
        setupLights()
        setupLevel()
        setupPlayer()
        setupCamera()
        setupSKOverlay()
    }
    
    
    func setupPlayer() {
        player = Player()
        rootNode.addChildNode(player)
    }
    
    
    func setupCamera() {
        camera = SCNNode()
        camera.name = "Camera"
        camera.position = cameraOffsetFromPlayer
        camera.camera = SCNCamera()
        camera.camera!.usesOrthographicProjection = true
        camera.camera!.orthographicScale = cameraOrthographicScale
        camera.camera!.zNear = 0.2
        camera.camera!.zFar = 500
        player.addChildNode(camera)
        
        camera.constraints = [SCNLookAtConstraint(target: player)]
        
    }
    
    
    func setupLevel() {
        levelData = GameLevel(width: levelWidth, height: levelHeight)
        levelData.setupLevelAtPosition(SCNVector3Zero, parentNode: rootNode)
    }
    
    func setupSKOverlay(){
        
        let hud = HUDScene(scnView: sceneView, inputHandler: inputHandler)
        hud.show()
    }
    
    func setupLights() {
        
        // Create ambient light
        let ambientLight = SCNLight()
        ambientLight.type = SCNLightTypeAmbient
        ambientLight.color = UIColor.whiteColor()
        let ambientLightNode = SCNNode()
        ambientLightNode.name = "AmbientLight"
        ambientLightNode.light = ambientLight
        rootNode.addChildNode(ambientLightNode)
        
        // Create an omni-directional light
        let omniLight = SCNLight()
        omniLight.type = SCNLightTypeOmni
        omniLight.color = UIColor.whiteColor()
        let omniLightNode = SCNNode()
        omniLightNode.name = "OmniLight"
        omniLightNode.light = omniLight
        omniLightNode.position = SCNVector3(x: -100.0, y: 20, z: 10.0)
        rootNode.addChildNode(omniLightNode)
        
        let spotLight = SCNLight()
        spotLight.type = SCNLightTypeAmbient
        spotLight.color = UIColor.whiteColor()
        spotLight.spotInnerAngle = 0;
        spotLight.spotOuterAngle = 45;
        spotLight.shadowRadius = 100.0;
        spotLight.zFar = 1000;
        spotLight.shadowColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
        spotLight.castsShadow = true
        let spotNode = SCNNode()
        spotNode.name = "SpotLight"
        spotNode.position = SCNVector3Make(100, 100, 170);
        spotNode.light = spotLight
        rootNode.addChildNode(spotNode)
    }
    
    
    // MARK: Delegates
    func renderer(aRenderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: NSTimeInterval) {
        
        // delta time since last update
        if (_previousUpdateTime == 0.0) {
            _previousUpdateTime = time;
        }
        
        let deltaTime : NSTimeInterval = min(max(1/60.0, time - _previousUpdateTime), 1.0)
        _previousUpdateTime = time;
        
        updateCharacterPosition(deltaTime)
    }
    
    func updateCharacterPosition(deltaTime : NSTimeInterval) {
        let direction = inputHandler.getDirection()
        
        let characterSpeedFactor : Float = 0.7
        let characterSpeed : Float = Float(deltaTime) * characterSpeedFactor
        
        //move
        if (direction.x != 0 || direction.z != 0) {
            
            let position  : SCNVector3 = player.position;
            player.position = SCNVector3Make(position.x+direction.x*characterSpeed, position.y+direction.y*characterSpeed, position.z+direction.z*characterSpeed);
            
            // update orientation
            let angle = atan2f(direction.x, direction.z)
            player.setDirectionAndRotate(angle)
            
            player.setWalking(true)
        }
        else {
            player.setWalking(false)
        }
        
        
        //simula a gravidade, fazendo o boneco subir se o chao subir
        
        let highestFall : Float = 20.0
        let highestClimb : Float = 20.0
        
        var position = player.position
        
        
        var p0 = position
        var p1 = position
        p0.y -= highestFall
        p1.y += highestClimb
        
        let results = self.physicsWorld.rayTestWithSegmentFromPoint(p1, toPoint: p0, options: [SCNPhysicsTestCollisionBitMaskKey: CollisionCategory.Ground.rawValue, SCNPhysicsTestSearchModeKey: SCNPhysicsTestSearchModeClosest])
        
        var groundY : Float = 2.0
        
        if (results.count > 0) {
            //o chao está embaixo do player
            let result = results[0]
            groundY = result.worldCoordinates.y
        } else {
            //não há chão embaixo do player
            return
        }
        
        let threshold : Float = 5.0
        let GravityAcceleration : Float = 1.0
        
        if groundY < position.y - threshold {
            //fica caindo
            _accelerationY += Float(deltaTime) * GravityAcceleration
        }else {
            //para de cair
            _accelerationY = 0;
        }
        
        position.y -= _accelerationY;
        
        // reset acceleration if we touch the ground
        if (groundY > position.y) {
            _accelerationY = 0;
            position.y = groundY;
        }
        
        //update the height
        player.position = position;
    }
    
    func physicsWorld(world: SCNPhysicsWorld, didBeginContact contact: SCNPhysicsContact) {
 
    }
    
}