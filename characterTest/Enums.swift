//
//  Enums.swift
//  characterTest
//
//  Created by Marcel de Siqueira Campos Rebouças on 9/22/15.
//  Copyright © 2015 mscr. All rights reserved.
//

import Foundation


enum TouchAction {
    case TouchActionTap
    case TouchActionSwipeUp
    case TouchActionSwipeDown
    case TouchActionSwipeLeft
    case TouchActionSwipeRight
    
    func description () -> String {
        switch self {
        case .TouchActionTap:
            return "Tap •"
        case .TouchActionSwipeUp:
            return "SwipeUp ↑"
        case .TouchActionSwipeDown:
            return "SwipeDown ↓"
        case .TouchActionSwipeLeft:
            return "SwipeLeft ←"
        case .TouchActionSwipeRight:
            return "SwipeRight →"
        }
    }
}


struct CollisionCategory : OptionSetType {
    let rawValue: Int
    
    static let None   = CollisionCategory(rawValue: 1 << 0)
    static let Player = CollisionCategory(rawValue: 1 << 1)
    static let Ground = CollisionCategory(rawValue: 1 << 2)
}
    