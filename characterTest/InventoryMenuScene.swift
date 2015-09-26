//
//  InventoryMenuScene.swift
//  characterTest
//
//  Created by Marcel de Siqueira Campos Rebouças on 9/25/15.
//  Copyright © 2015 mscr. All rights reserved.
//

import SpriteKit

class InventoryMenuScene : GeneralMenuScene {

    
    override init(scnView: GameView!) {
        super.init(scnView: scnView)
        self.name = "InventoryMenu"
        setupInventoryElements()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupInventoryElements() {
        
        let backgroundSize = CGSizeMake(w*0.9, h*0.8)
        let backgroundPosition = CGPointMake(w/2 - backgroundSize.width/2, h/2 - backgroundSize.height/2)
        let background = SKShapeNode(rect: CGRectMake(backgroundPosition.x, backgroundPosition.y, backgroundSize.width, backgroundSize.height), cornerRadius: 10)
        background.fillColor = UIColor.redColor()
        background.alpha = 0.95
        addChild(background)
    
        let label = SKLabelNode(text: "Oi")
        label.position = CGPointMake(backgroundPosition.x + label.frame.width/2, backgroundPosition.y + backgroundSize.height - label.frame.height)
        background.addChild(label)
    }
}
