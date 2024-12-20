//
//  AnimationTouchPointerBag.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/8/24.
//

import Foundation

// [Animation Mode Verify] 12-19-2024
// Looks good, no problem. We are using everything
// in this file, it's all working to specification.
//
// Touch pointers are like references to "animation touches"
// They generally will switch into a ghost / unused state after
// the touch goes away. They will then be recycled once they are
// inactive for some time... That is, unless new touches re-claim
// the same pointers.
//
// The main reason for this pointer bag is because multiple
// "animation instruction" objects share the same pointers.
// In this architecture, the "animation instruction" objects
// will never "own" or "retain" the "animation touch" objects...
//
class AnimationTouchPointerBag {
    
    static let captureTrackDistanceThreshold = Float(4.0)
    static let captureTrackDistanceThresholdSquared = (captureTrackDistanceThreshold * captureTrackDistanceThreshold)
    
    typealias Point = Math.Point
    
    var touchPointerCount = 0
    var touchPointers = [AnimationTouchPointer]()
    
    var tempTouchPointerCount = 0
    var tempTouchPointers = [AnimationTouchPointer]()
    
    var isCaptureValid = false
    
    // Position Tracking
    var captureStartAverageTouchPointerPosition = Point(x: 0.0, y: 0.0)
    var captureStartJiggleAnimationCursorPosition = Point(x: 0.0, y: 0.0)
    var captureStartCursorFalloffDistance_R1 = Float(0.0)
    var captureStartCursorFalloffDistance_R2 = Float(0.0)
    var captureStartCursorFalloffDistance_R3 = Float(0.0)
    
    // Scale Tracking
    var captureStartJiggleAnimationCursorScale = Float(1.0)
    var captureStartCursorFalloffScale_U1 = Float(0.0)
    var captureStartCursorFalloffScale_U2 = Float(0.0)
    var captureStartCursorFalloffScale_U3 = Float(0.0)
    var captureStartCursorFalloffScale_D1 = Float(0.0)
    var captureStartCursorFalloffScale_D2 = Float(0.0)
    var captureStartCursorFalloffScale_D3 = Float(0.0)
    
    // Rotation Tracking
    var captureStartJiggleAnimationCursorRotation = Float(0.0)
    var captureStartCursorFalloffRotation_U1 = Float(0.0)
    var captureStartCursorFalloffRotation_U2 = Float(0.0)
    var captureStartCursorFalloffRotation_U3 = Float(0.0)
    var captureStartCursorFalloffRotation_D1 = Float(0.0)
    var captureStartCursorFalloffRotation_D2 = Float(0.0)
    var captureStartCursorFalloffRotation_D3 = Float(0.0)
    
    let format: AnimationTouchFormat
    init(format: AnimationTouchFormat) {
        self.format = format
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    func update(deltaTime: Float) {
        
        // Update each pointer...
        for pointerIndex in 0..<touchPointerCount {
            touchPointers[pointerIndex].update(deltaTime: deltaTime)
        }
        
        touchPointersRemoveExpired()
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    // This is a very handsome way to share logic.
    @MainActor func continuousRegisterAllStartValues(jiggle: Jiggle,
                                                     jiggleDocument: JiggleDocument) {
        registerContinuousStartPosition(jiggle: jiggle,
                                        jiggleDocument: jiggleDocument)
        registerContinuousStartScale(jiggle: jiggle,
                                     jiggleDocument: jiggleDocument)
        registerContinuousStartRotation(jiggle: jiggle,
                                        jiggleDocument: jiggleDocument)
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    func captureStart(jiggle: Jiggle) {
        
        // Let's try to get the average of all
        // the touches... Most of this is based
        // on the "center of all touches..."
        
        let avaragesResponse = calculateConsiderTouchPointersAndGetAverages()
        let averageX: Float
        let averageY: Float
        switch avaragesResponse {
        case .invalid:
            isCaptureValid = false
            return
        case .valid(let point):
            isCaptureValid = true
            averageX = point.x
            averageY = point.y
        }
        
        // ==============================
        // ==============================
        // Chapter I - The position:
        // ==============================
        // ==============================
        captureStart_Position(jiggle: jiggle,
                              cursorX: jiggle.animationCursorX,
                              cursorY: jiggle.animationCursorY,
                              averageX: averageX,
                              averageY: averageY)
        
        // ==============================
        // ==============================
        // Chapter II - The scale:
        // ==============================
        // ==============================
        captureStart_PrepareScale(jiggle: jiggle,
                                  averageX: averageX,
                                  averageY: averageY)
        captureStart_Scale(jiggle: jiggle,
                           scale: jiggle.animationCursorScale)
        
        // ==============================
        // ==============================
        // Chapter III - The rotation:
        // ==============================
        // ==============================
        captureStart_PrepareRotate(jiggle: jiggle,
                                   averageX: averageX,
                                   averageY: averageY)
        captureStart_Rotate(jiggle: jiggle,
                            rotation: jiggle.animationCursorRotation)
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    @MainActor func captureTrack(jiggle: Jiggle,
                                 jiggleDocument: JiggleDocument) {
        
        // Did we start out with good conditions?
        // If no, we can skip the fun parts.
        
        if !isCaptureValid {
            return
        }
        
        // Let's try to get the average of all
        // the touches... Most of this is based
        // on the "center of all touches..."
        
        let avaragesResponse = calculateConsiderTouchPointersAndGetAverages()
        let averageX: Float
        let averageY: Float
        switch avaragesResponse {
        case .invalid:
            // In practice this doesn't happen, but if
            // it does, it just means the drag bliffs.
            // I've tested it with an invalid response
            // and it's not a life-ending thing. Nor
            // does it appear to even happen. Therefore,
            // this requires no more thought. It's fine!
            isCaptureValid = false
            return
        case .valid(let point):
            averageX = point.x
            averageY = point.y
        }
        
        // ==============================
        // ==============================
        // Chapter I - The position:
        // ==============================
        // ==============================
        captureTrack_Position(jiggle: jiggle,
                              jiggleDocument: jiggleDocument,
                              averageX: averageX,
                              averageY: averageY)
        
        // ==============================
        // ==============================
        // Chapter II - The scale:
        // ==============================
        // ==============================
        let scaleResponse = captureTrack_PrepareScale(jiggle: jiggle,
                                                      averageX: averageX,
                                                      averageY: averageY)
        switch scaleResponse {
        case .invalid:
            break
        case .valid(let scaleData):
            captureTrack_Scale(jiggle: jiggle,
                               jiggleDocument: jiggleDocument,
                               scaleData: scaleData,
                               averageX: averageX,
                               averageY: averageY)
        }
        
        // ==============================
        // ==============================
        // Chapter III - The rotation:
        // ==============================
        // ==============================
        let rotateResponse = captureTrack_PrepareRotate(jiggle: jiggle, averageX: averageX,
                                                        averageY: averageY)
        if rotateResponse {
            captureTrack_Rotate(jiggle: jiggle,
                                jiggleDocument: jiggleDocument,
                                averageX: averageX,
                                averageY: averageY)
        }
    }
    
}
