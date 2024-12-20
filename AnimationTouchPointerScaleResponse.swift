//
//  AnimationTouchPointerScaleResponse.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/10/24.
//

import Foundation

// [Animation Mode Verify] 12-18-2024
//
// This is fine, it could also just
// be an optional AnimationTouchPointerScaleData.
// I like this because "invalid" is more specific
// than simply being NULL or nil................
//
enum AnimationTouchPointerScaleResponse {
    case invalid
    case valid(AnimationTouchPointerScaleData)
}
