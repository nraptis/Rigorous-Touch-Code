//
//  AnimationTouchStateCommandType.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/8/24.
//

import Foundation

// [Animation Mode Verify] 12-18-2024
//
// There are exactly 3 commands we can
// do with a touch. We can add it, remove
// it, or move it to another location...
//
enum AnimationTouchStateCommandType {
    case add
    case remove
    case move
}
