//
//  GeneralMenuScene.swift
//  characterTest
//
//  Created by Marcel de Siqueira Campos Rebouças on 9/25/15.
//  Copyright © 2015 mscr. All rights reserved.
//

import SpriteKit

class GeneralMenuScene: GeneralUIScene {
    
    var mustCloseScene : Bool
    var closeAction : (() -> Void)?
    
    override init(scnView: GameView!) {
        
        mustCloseScene = false
        
        super.init(scnView: scnView)
        
        self.userInteractionEnabled = true
        scnView.playing = false
    }

    required init?(coder aDecoder: NSCoder) {
        mustCloseScene = false
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let location = touch.locationInNode(self)
            if self.nodesAtPoint(location).count == 0 {
                mustCloseScene = true
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if mustCloseScene {
            mustCloseScene = false
            scnView.playing = true
            goBackToLastOverlayScene()
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if mustCloseScene {
            mustCloseScene = false
            scnView.playing = true
            goBackToLastOverlayScene()
        }
    }
}
