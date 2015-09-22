//
//  GameView.swift
//  characterTest
//
//  Created by Marcel de Siqueira Campos Rebouças on 9/21/15.
//  Copyright © 2015 mscr. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

class GameView : SCNView {

    var eventHandlerDelegate : EventHandlerDelegate?
    
    override init(frame: CGRect, options: [String : AnyObject]?) {
        super.init(frame: frame, options: options)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        eventHandlerDelegate?.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        eventHandlerDelegate?.touchesMoved(touches, withEvent: event)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        eventHandlerDelegate?.touchesCancelled(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        eventHandlerDelegate?.touchesEnded(touches, withEvent: event)
    }
    
}

