//
//  HUDScene.swift
//  characterTest
//
//  Created by Marcel de Siqueira Campos Rebouças on 9/25/15.
//  Copyright © 2015 mscr. All rights reserved.
//

import SpriteKit

class HUDScene : SKScene {
    
    var scnView : GameView!
    var inputHandler : InputHandler!
    
    var w : CGFloat!
    var h : CGFloat!
    
    init(scnView : GameView!, inputHandler : InputHandler!){
    
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
        self.inputHandler = inputHandler
    
        setupHUD()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupHUD() {
        
        self.scaleMode = SKSceneScaleMode.ResizeFill
        self.shouldEnableEffects = true
        self.backgroundColor = SKColor.clearColor()
        self.blendMode = .Alpha
        
        // The D-Pad
        let dpadSprite = SKSpriteNode(imageNamed: "dpad.png")
        dpadSprite.name = "dpad"
        dpadSprite.position = CGPointMake(100, 120)
        dpadSprite.xScale = 0.5
        dpadSprite.yScale = 0.5
        self.addChild(dpadSprite)
        
         inputHandler.padRect = CGRectMake((dpadSprite.position.y-inputHandler.DPAD_RADIUS)/w, 1.0 - ((dpadSprite.position.y + inputHandler.DPAD_RADIUS) / h), 2 * inputHandler.DPAD_RADIUS/w, 2 * inputHandler.DPAD_RADIUS/h);
        
        
        let bagSprite = ButtonSpriteNode(imageNamed: "bag.jpg")
        bagSprite.name = "bag"
        bagSprite.xScale = 0.5
        bagSprite.yScale = 0.5
        bagSprite.position = CGPointMake(bagSprite.size.width/2, h - bagSprite.size
        .height/2)
        self.addChild(bagSprite)
        bagSprite.userInteractionEnabled = true
        bagSprite.action = { arg in
            print("Pressed bag!")
        }
        
        
    }
    
}