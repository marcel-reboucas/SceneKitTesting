//
//  EventHandlerDelegate.swift
//  characterTest
//
//  Created by Marcel de Siqueira Campos Rebouças on 9/21/15.
//  Copyright © 2015 mscr. All rights reserved.
//

import Foundation
import UIKit

protocol EventHandlerDelegate {

    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    
    func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    
    func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?)
    
    func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
}
