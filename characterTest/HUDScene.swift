//
//  HUDScene.swift
//  characterTest
//
//  Created by Marcel de Siqueira Campos Rebouças on 9/25/15.
//  Copyright © 2015 mscr. All rights reserved.
//
// HUDScene is the scene that shows the HUD (inventory icon, dpad icon etc)
import SpriteKit

class HUDScene : GeneralUIScene {
    
    var inputHandler : InputHandler!
    
    init(scnView : GameView!, inputHandler : InputHandler!){

        super.init(scnView: scnView)
        
        self.inputHandler = inputHandler
        setupHUD()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupHUD() {
        
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
            let inventoryMenu = InventoryMenuScene(scnView: self.scnView)
            inventoryMenu.show()
        }
        
    }
    
}