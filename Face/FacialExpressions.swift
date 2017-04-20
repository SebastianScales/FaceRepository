//
//  FacialExpressions.swift
//  Face
//
//  Created by Madison Heck on 3/21/17.
//  Copyright © 2017 SebastianScales. All rights reserved.
//

import Foundation

struct FacialExpressions {
    
    enum Eyes: Int {
        case open
        case closed
        case squinting
    }
    
    
    enum Mouth: Int {
        case frown
        case smirk
        case neutral
        case grin
        case smile
       
    }
    
    
    var eyes: Eyes
    var mouth: Mouth
}
