//
//  AnimationTouchSkeleton.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/8/24.
//

import UIKit

// [Animation Mode Verify] 12-18-2024
//
// This seems fine. Perhaps the name
// could be improved? Why is it a "state?"
// I can't think of a better name yet.
//
class AnimationTouchState {
    init(x: Float,
         y: Float,
         touchID: ObjectIdentifier) {
        self.x = x
        self.y = y
        self.touchID = touchID
    }
    var x: Float
    var y: Float
    var touchID: ObjectIdentifier
}
