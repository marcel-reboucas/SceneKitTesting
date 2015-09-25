//
//  ButtonSpriteNode.swift
//  characterTest
//
//  Created by Marcel de Siqueira Campos Rebouças on 9/25/15.
//  Copyright © 2015 mscr. All rights reserved.
//

import SpriteKit

class ButtonSpriteNode : SKSpriteNode {
    
    var action : (() -> Void)?
    
    init(imageNamed path : String) {
        let texture = SKTexture(imageNamed: path)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        action?()
    }
}
