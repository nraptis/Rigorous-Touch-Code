//
//  AnimationTouch.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/7/24.
//

import UIKit

// [Animation Mode Verify] 12-18-2024
// Looks good, no problem. We are using everything
// on this class, it's all working to specification.
//
class AnimationTouch {
    
    static let expireTime = Float(8.0)
    
    typealias Point = Math.Point
    
    var x = Float(0.0)
    var y = Float(0.0)
    var touchID: ObjectIdentifier
    var residency = AnimationTouchResidency.unassigned
    var stationaryTime = Float(0.0)
    var isExpired = false
    var history = AnimationTouchHistory()
    
    init(touchID: ObjectIdentifier) {
        self.touchID = touchID
    }
    
    var point: Point {
        Point(x: x, y: y)
    }
    
    // [Animation Mode Verify] 12-18-2024
    // Looks good, no problem.
    func update(deltaTime: Float, clock: Float) {
        if isExpired == false {
            stationaryTime += deltaTime
            history.update(deltaTime: deltaTime, clock: clock)
            if stationaryTime >= Self.expireTime {
                isExpired = true
            }
        }
    }
    
    // [Animation Mode Verify] 12-18-2024
    // Looks good, no problem.
    func linkToResidency(residency: AnimationTouchResidency) {
        self.residency = residency
        stationaryTime = 0.0
        isExpired = false
    }
    
    // [Animation Mode Verify] 12-18-2024
    // Looks good, no problem.
    func recordHistory(clock: Float) {
        history.recordHistory(clock: clock, x: x, y: y)
    }
    
    // [Animation Mode Verify] 12-18-2024
    // Looks good, no problem.
    func release() -> ReleaseData {
        history.release()
    }
    
}
