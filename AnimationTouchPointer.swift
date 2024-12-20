//
//  AnimationTouchPointer.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/8/24.
//

import Foundation

// [Animation Mode Verify] 12-19-2024
// Looks good, no problem. We are using everything
// on this class, it's all working to specification.
//
class AnimationTouchPointer {
    
    //
    // These should always take longer to expire than the regular touch.
    // Otherwise, we may end up out of sync (the touch stayed existing, the pointer poofed)
    //
    static let expireTime = (AnimationTouch.expireTime + AnimationTouch.expireTime * 0.5)
    
    var touchID: ObjectIdentifier
    var x = Float(0.0)
    var y = Float(0.0)
    
    var stationaryTime = Float(0.0)
    var isExpired = false
    
    var actionType = AnimationTouchPointerActionType.detached
    
    var isConsidered = false
    
    var isCaptureStartScaleValid = false
    var captureStartDistance = Float(0.0)
    var captureTrackDistance = Float(0.0)
    
    var isCaptureStartRotateValid = false
    var captureStartAngle = Float(0.0)
    var captureTrackAngle = Float(0.0)
    var captureTrackAngleDifference = Float(0.0)
    
    init(touchID: ObjectIdentifier) {
        self.touchID = touchID
    }
    
    // [Animation Mode Verify] 12-18-2024
    //
    // This is fine; we are expiring the
    // touch pointer after about 10 seconds.
    //
    func update(deltaTime: Float) {
        stationaryTime += deltaTime
        if stationaryTime >= Self.expireTime {
            isExpired = true
        }
    }
}
