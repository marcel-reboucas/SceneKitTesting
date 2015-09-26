//
//  GeneralMenuScene.swift
//  characterTest
//
//  Created by Marcel de Siqueira Campos Rebouças on 9/25/15.
//  Copyright © 2015 mscr. All rights reserved.
//

import SpriteKit

// This is the base class for the SKScenes used in the project

class GeneralUIScene : SKScene {

    var scnView : GameView!
    var lastOverlayScene : SKScene?
    
    var w : CGFloat!
    var h : CGFloat!
    
    init(scnView : GameView!){
        
        w = scnView.bounds.size.width
        h = scnView.bounds.size.height
        
        
        // Support Landscape scape
        if (w < h) {
            let wTmp = w;
            w = h;
            h = wTmp;
        }
        
        super.init(size: CGSizeMake(w,h))
        
        self.scnView = scnView
        self.scaleMode = SKSceneScaleMode.ResizeFill
        self.shouldEnableEffects = true
        self.backgroundColor = SKColor.clearColor()
        self.blendMode = .Alpha
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func show() {
        lastOverlayScene = scnView.overlaySKScene
        scnView.overlaySKScene = self
    }
    
    func goBackToLastOverlayScene(){
        scnView.overlaySKScene = lastOverlayScene
    }
}
