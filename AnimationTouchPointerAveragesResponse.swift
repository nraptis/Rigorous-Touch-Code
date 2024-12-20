//
//  AnimationTouchPointerAveragesResponse.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/9/24.
//

import Foundation

// [Animation Mode Verify] 12-18-2024
//
// This is fine, it could also just
// be an optional Point. I like this
// because "invalid" is more specific
// than simply being NULL or nil.....
//
enum AnimationTouchPointerAveragesResponse {
    case invalid
    case valid(Math.Point)
}
