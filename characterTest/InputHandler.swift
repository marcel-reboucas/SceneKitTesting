//
//  InputHandler.swift
//  characterTest
//
//  Created by Marcel de Siqueira Campos Rebouças on 9/21/15.
//  Copyright © 2015 mscr. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit

public class InputHandler : EventHandlerDelegate {

    // MARK: Gesture Properties
    
    let DPAD_RADIUS : CGFloat = 80.0
    let MINIMUM_SWIPE_DISTANCE : CGFloat = 70.0
    let MAXIMUM_TAP_DISTANCE : CGFloat = 20.0
    
    //left hand gestures
    var padTouch : UITouch?
    var padRect : CGRect!
    var movementDirection : CGPoint! = CGPointMake(0, 0)
    var movementDirectionCacheValid : Bool! = false
    var movementDirectionCache : SCNVector3!
    
    //right hand
    var actionTouch : UITouch?
    var actionRect : CGRect!
    var initialActionPosition : CGPoint?
    
    var sceneView : GameView
    var screenHeight : CGFloat!
    var screenWidth : CGFloat!
    
    init(scnView: GameView) {

        self.sceneView = scnView
        
        screenWidth = sceneView.bounds.size.width
        screenHeight = sceneView.bounds.size.height
        
        // Support Landscape scape
        if (screenWidth < screenHeight) {
            let wTmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = wTmp;
        }
        
        //action rect pega acoes na tela toda
        actionRect = CGRectMake(0, 0, 1, 1)
   
    }
    
    //Events
    
    func touchIsInRect(touch : UITouch, rect : CGRect) -> Bool{
        let bounds = sceneView.bounds
        
        let rectCopy = CGRectApplyAffineTransform(rect, CGAffineTransformMakeScale(bounds.size.width, bounds.size.height))
        
        return CGRectContainsPoint(rectCopy, touch.locationInView(sceneView))
    }
    
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if sceneView.playing {
            for touch in touches {
                
                print("inputhandler")
                //checa primeiro se o toque iniciou no padrect. com isso, se começou no padrect, não vai criar um actiontouch.
                if touchIsInRect(touch, rect: padRect) {
                    //We're in the dpad
                    if padTouch == nil {
                        padTouch = touch
                        //print("Starting pad touch.")
                    }
                } else if touchIsInRect(touch, rect: actionRect) {
                    //We're in the right area of the screen
                    if actionTouch == nil {
                        actionTouch = touch
                        initialActionPosition = actionTouch!.locationInView(sceneView)
                        //print("Starting action touch.")
                    }
                }
            }
        }
    }
    
    func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //print("Moved")
        
        if sceneView.playing {
            movementDirectionCacheValid = false;
            
            if padTouch != nil {
                let p0 = padTouch!.previousLocationInView(sceneView)
                let p1 = padTouch!.locationInView(sceneView)
                
                let SPEED : CGFloat = 1.0 / 10.0
                let LIMIT : CGFloat = 1.0
                movementDirection.x += (p1.x-p0.x) * SPEED;
                movementDirection.y += (p1.y-p0.y) * SPEED;
                
                if (movementDirection.x > LIMIT){
                    movementDirection.x = LIMIT
                }
                
                if (movementDirection.x < -LIMIT){
                    movementDirection.x = -LIMIT;
                }
                
                if (movementDirection.y > LIMIT){
                    movementDirection.y = LIMIT;
                }
                
                if (movementDirection.y < -LIMIT){
                    movementDirection.y = -LIMIT;
                }
                
                directionDidChange()
            }
            
            
            if actionTouch != nil {
                
                //let p1 = actionTouch!.locationInView(sceneView)
                
                //print("actionTouch went from \(initialActionPosition) to \(p1)")
                
            }
        }
    }
    
    func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if sceneView.playing {
            commonTouchesEnded(touches, withEvent: event)
        }
    }
    
    func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if sceneView.playing {
            commonTouchesEnded(touches, withEvent: event)
        }
    }
    
    func commonTouchesEnded(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        if let tchs = touches {
            
            if padTouch != nil {
                if tchs.contains(padTouch!) || (event?.touchesForView(sceneView)?.contains(padTouch!))! == false {
                    padTouch = nil
                    movementDirection = CGPointMake(0, 0);
                    directionDidChange()
                    //print("Ending pad touch.")
                }
            }
            
            if actionTouch != nil {
                if tchs.contains(actionTouch!) || (event?.touchesForView(sceneView)?.contains(actionTouch!))! == false {
                    
                    let point = actionTouch!.locationInView(sceneView)
                    let touchAction = calculateTouchAction(initialActionPosition!, endingPoint: point)
                    //print("Action Ended: \(touchAction.action.description()) \(touchAction.intensity)")
                    
                    //testing
                    addTextToAction(point, action: touchAction.action)
                    
                    actionTouch = nil
                    initialActionPosition = nil
                }
            }
        }
    }
    
    func directionDidChange() {
        movementDirectionCacheValid = false
    }
    
    func computeDirection() -> SCNVector3 {
        
        let point = movementDirection
        var dir = SCNVector3Make(Float(point.x), 0, Float(point.y))
        var p0 = SCNVector3Make(0, 0, 0)
        
        dir = (sceneView.pointOfView?.presentationNode.convertPosition(dir, toNode: nil))!
        p0 = (sceneView.pointOfView?.presentationNode.convertPosition(p0, toNode: nil))!
        
        dir = SCNVector3Make((dir.x - p0.x)*100, 0, (dir.z - p0.z)*100);
        
        return dir
    }
    
    func getDirection() -> SCNVector3 {
        if !movementDirectionCacheValid {
            movementDirectionCache = computeDirection()
            movementDirectionCacheValid = true
        }
        
        return movementDirectionCache
    }

    func calculateTouchAction(startingPoint : CGPoint, endingPoint : CGPoint) -> (action : TouchAction, intensity : CGFloat) {
    
        var resultAction = TouchAction.TouchActionTap
        var intensity : CGFloat = 0.0
        
        let deltaX = endingPoint.x - startingPoint.x
        let deltaY = endingPoint.y - startingPoint.y
        
        //dedice which axis was moved longer
        if abs(deltaX) > abs(deltaY) {
            if deltaX < 0 {
                //swipe left
                
                if (abs(deltaX) > MAXIMUM_TAP_DISTANCE) {
                    resultAction = TouchAction.TouchActionSwipeLeft
                    intensity = abs(deltaX) > MINIMUM_SWIPE_DISTANCE ? 1.0 : abs(deltaX)/MINIMUM_SWIPE_DISTANCE
                }
            } else {
                //swipe right
                
                if (abs(deltaX) > MAXIMUM_TAP_DISTANCE) {
                    resultAction = TouchAction.TouchActionSwipeRight
                    intensity = abs(deltaX) > MINIMUM_SWIPE_DISTANCE ? 1.0 : abs(deltaX)/MINIMUM_SWIPE_DISTANCE
                }
            }
        } else {
            if deltaY < 0 {
                //swipe up
                
                if (abs(deltaY) > MAXIMUM_TAP_DISTANCE) {
                    resultAction = TouchAction.TouchActionSwipeUp
                    intensity = abs(deltaY) > MINIMUM_SWIPE_DISTANCE ? 1.0 : abs(deltaY)/MINIMUM_SWIPE_DISTANCE
                }
                
            }else {
                //swipe down
                
                if (abs(deltaY) > MAXIMUM_TAP_DISTANCE) {
                    resultAction = TouchAction.TouchActionSwipeDown
                    intensity = abs(deltaY) > MINIMUM_SWIPE_DISTANCE ? 1.0 : abs(deltaY)/MINIMUM_SWIPE_DISTANCE
                }
            }
        }
        
        return (resultAction,intensity)
    }

    //testing
    func addTextToAction(position : CGPoint, action : TouchAction) {
    
        let sprite = SKLabelNode(text: action.description())
        sprite.position = CGPointMake(position.x, screenHeight - position.y)
        sceneView.overlaySKScene!.addChild(sprite)
       
        
        var deltaX : CGFloat = 0.0
        var deltaY : CGFloat = 0.0
        let animationDistance : CGFloat = 40.0
        
        switch action {
            
        case .TouchActionTap:
            break
        case .TouchActionSwipeUp:
            deltaY = animationDistance
            break
        case .TouchActionSwipeDown:
            deltaY = -animationDistance
            break
        case .TouchActionSwipeLeft:
            deltaX = -animationDistance
            break
        case .TouchActionSwipeRight:
            deltaX = animationDistance
            break
        }
        
        let moveAction = SKAction.moveByX(deltaX, y: deltaY, duration: 0.4)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveAction, removeAction])
        sprite.runAction(sequence)
    }

}