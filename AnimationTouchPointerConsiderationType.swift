//
//  AnimationTouchPointerActionType.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/8/24.
//

import Foundation

// [Animation Mode Verify] 12-19-2024
//
// This captures all the necessary info;
// We have 5 different types of action.
// The name is a little confusing,
// it seems to blend "state" or "action"
//
enum AnimationTouchPointerActionType {
    case detached
    case retained(Float, Float)
    case add(Float, Float)
    case remove
    case move(Float, Float)
    
    // [Animation Mode Verify] 12-19-2024
    //
    // This could be shortened, but it works fine.
    //
    var isDetachedOrRetained: Bool {
        switch self {
        case .detached:
            return true
        case .retained:
            return true
        default:
            return false
        }
    }
}
