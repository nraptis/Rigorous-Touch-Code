//
//  AnimationTouchPointerBag+Rotation.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/11/24.
//

import Foundation

// [Animation Mode Verify] 12-19-2024
//
// This all works correctly.
// I have read each line and verified.
//
extension AnimationTouchPointerBag {
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    func captureStart_PrepareRotate(jiggle: Jiggle,
                                    averageX: Float,
                                    averageY: Float) {
        
        // For each touch pointer...
        for touchPointerIndex in 0..<touchPointerCount {
            let touchPointer = touchPointers[touchPointerIndex]
            
            // If the touch pointer is being considered...
            if touchPointer.isConsidered {
                
                // How far from the average of all touch pointers
                // is *this* touch pointer?
                let diffX = averageX - touchPointer.x
                let diffY = averageY - touchPointer.y
                let captureStartDistanceSquared = diffX * diffX + diffY * diffY
                if captureStartDistanceSquared > AnimationTouchPointerBag.captureTrackDistanceThresholdSquared {
                    
                    // If it's not hugged right up against the average
                    // point, it's a suitable pointer to track angle with.
                    
                    let captureStartAngle = -atan2f(diffX, diffY)
                    
                    // It's not 100% necessary to "fix" the angle in this
                    // case, but it's easier to read the angles near zero...
                    
                    let fixedRotation = fixRotation_NearZero(rotation: captureStartAngle)
                    touchPointer.captureStartAngle = fixedRotation
                    touchPointer.captureTrackAngle = fixedRotation
                    touchPointer.captureTrackAngleDifference = 0.0
                    touchPointer.isCaptureStartRotateValid = true
                    
                } else {
                    
                    // We're on top of the average point, we just
                    // won't use this touch pointer. Invalid capture...
                    
                    touchPointer.isCaptureStartRotateValid = false
                }
            }
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    func captureStart_Rotate(jiggle: Jiggle, rotation: Float) {
        
        // Record the rotation that we start the capture with...
        let fixedRotation = fixRotation_NearZero(rotation: rotation)
        captureStartJiggleAnimationCursorRotation = fixedRotation
        
        // This is the user slider value for "power"...
        let grabDragPowerPercentLinear = Jiggle.getGrabDragPowerPercentLinear(userGrabDragPower: jiggle.grabDragPower)
        
        // We're converting to the range [0.15...1.0]
        // This means that at 0.0, there is still some small effect...
        let grabDragRotateFactor = Jiggle.getGrabDragRotateFactor(grabDragPowerPercentLinear: grabDragPowerPercentLinear)
        
        // We're adjusting the positive rotation based on
        // the power which the user has selected.
        let baseRotationU1 = Jiggle.animationCursorFalloffRotation_U1 * grabDragRotateFactor
        let baseRotationU2 = Jiggle.animationCursorFalloffRotation_U2 * grabDragRotateFactor
        let baseRotationU3 = Jiggle.animationCursorFalloffRotation_U3 * grabDragRotateFactor
        
        // We're adjusting the negative rotation based on
        // the power which the user has selected.
        let baseRotationD1 = Jiggle.animationCursorFalloffRotation_D1 * grabDragRotateFactor
        let baseRotationD2 = Jiggle.animationCursorFalloffRotation_D2 * grabDragRotateFactor
        let baseRotationD3 = Jiggle.animationCursorFalloffRotation_D3 * grabDragRotateFactor
        
        if rotation > baseRotationU2 {
            
            // In this case, we're out of the
            // "allowed range" and the user
            // slammed their fingers down.
            
            // The negtive-rotations all works as normal,
            // but the positive-rotations are all clamped
            // to whichever value the user's finger
            // has dictated to us, moving forward.
            
            captureStartCursorFalloffRotation_U1 = rotation
            captureStartCursorFalloffRotation_U2 = rotation
            captureStartCursorFalloffRotation_U3 = rotation
            captureStartCursorFalloffRotation_D1 = baseRotationD1
            captureStartCursorFalloffRotation_D2 = baseRotationD2
            captureStartCursorFalloffRotation_D3 = baseRotationD3
        } else if rotation > baseRotationU1 {
            
            // In this case, we're inside the
            // "dampen range" and the user
            // slammed their fingers down.
            
            // The negtive-rotations all works as normal,
            // but the lowest positive-rotation is clamped
            // to whichever value the user's finger
            // has dictated to us, moving forward.
            
            captureStartCursorFalloffRotation_U1 = rotation
            captureStartCursorFalloffRotation_U2 = baseRotationU2
            captureStartCursorFalloffRotation_U3 = baseRotationU3
            captureStartCursorFalloffRotation_D1 = baseRotationD1
            captureStartCursorFalloffRotation_D2 = baseRotationD2
            captureStartCursorFalloffRotation_D3 = baseRotationD3
        } else if rotation < baseRotationD2 {
            
            // In this case, we're out of the
            // "allowed range" and the user
            // slammed their fingers down.
            
            // The positive-rotations all works as normal,
            // but the negtive-rotations are all clamped
            // to whichever value the user's finger
            // has dictated to us, moving forward.
            
            captureStartCursorFalloffRotation_U1 = baseRotationU1
            captureStartCursorFalloffRotation_U2 = baseRotationU2
            captureStartCursorFalloffRotation_U3 = baseRotationU3
            captureStartCursorFalloffRotation_D1 = rotation
            captureStartCursorFalloffRotation_D2 = rotation
            captureStartCursorFalloffRotation_D3 = rotation
        } else if rotation < baseRotationD1 {
            
            // In this case, we're inside the
            // "dampen range" and the user
            // slammed their fingers down.
            
            // The positive-rotations all works as normal,
            // but the highest negtive-rotation is clamped
            // to whichever value the user's finger
            // has dictated to us, moving forward.
            
            captureStartCursorFalloffRotation_U1 = baseRotationU1
            captureStartCursorFalloffRotation_U2 = baseRotationU2
            captureStartCursorFalloffRotation_U3 = baseRotationU3
            captureStartCursorFalloffRotation_D1 = rotation
            captureStartCursorFalloffRotation_D2 = baseRotationD2
            captureStartCursorFalloffRotation_D3 = baseRotationD3
        } else {
            
            // The usual case, we don't need to adjust
            // any of the falloff values, it's a
            // regular grabbing event, use the standard.
            
            captureStartCursorFalloffRotation_U1 = baseRotationU1
            captureStartCursorFalloffRotation_U2 = baseRotationU2
            captureStartCursorFalloffRotation_U3 = baseRotationU3
            captureStartCursorFalloffRotation_D1 = baseRotationD1
            captureStartCursorFalloffRotation_D2 = baseRotationD2
            captureStartCursorFalloffRotation_D3 = baseRotationD3
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    func captureTrack_PrepareRotate(jiggle: Jiggle, averageX: Float, averageY: Float) -> Bool {
        
        // We sum up the number of valid touch pointers...
        var numberOfCapturedTouchPointers = 0
        for touchPointerIndex in 0..<touchPointerCount {
            let touchPointer = touchPointers[touchPointerIndex]
            if (touchPointer.isConsidered == true) && (touchPointer.isCaptureStartRotateValid == true) {
                
                // How far from the average of all touch pointers
                // is *this* touch pointer?
                let diffX = averageX - touchPointer.x
                let diffY = averageY - touchPointer.y
                let captureTrackDistanceSquared = diffX * diffX + diffY * diffY
                
                // If the touch pointer is being considered...
                // And the touch pointer was valid when we started the rotate...
                if captureTrackDistanceSquared > Self.captureTrackDistanceThresholdSquared {
                    
                    // If we're not on top of the center point, we update the
                    // track rotation. Otherwise, we'll just keep the previous
                    // value which was valid. This should be a transient state
                    // which ends very quickly, as we are considering 4 pixels "inside..."
                    
                    // We grab the rotation which is closest to our previous
                    // rotation; this way looping past 360 degrees (2 pi)
                    // and other "looping" scenarios don't cause a skip.
                    
                    let currentCaptureTrackAngle = -atan2f(diffX, diffY)
                    let previousCaptureTrackAngle = touchPointer.captureTrackAngle
                    let captureTrackAngle = fixRotation_NearPreviousAngle(previousRotation: previousCaptureTrackAngle,
                                                                          currentRotation: currentCaptureTrackAngle)
                    touchPointer.captureTrackAngle = captureTrackAngle
                    touchPointer.captureTrackAngleDifference = touchPointer.captureStartAngle - captureTrackAngle
                }
                
                // Summing up the valid touch pointers...
                numberOfCapturedTouchPointers += 1
            }
        }
        if numberOfCapturedTouchPointers > 1 {
            
            // If there's at least 2 valid pointers, we're
            // doing a twist to rotate the thing...........
            
            return true
        } else {
            
            // If there's not 2 valid pointers,
            // it's not a valid rotating maneuver...
            
            return false
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    //
    // @Precondition: captureTrack_PrepareRotate
    @MainActor func captureTrack_Rotate(jiggle: Jiggle,
                                        jiggleDocument: JiggleDocument,
                                        averageX: Float,
                                        averageY: Float) {
        
        // We'll take the average of all the "angle differences"
        // that all the valid touch pointers have.
        var rotationShift = Float(0.0)
        var numberOfCapturedTouchPointers = 0
        for touchPointerIndex in 0..<touchPointerCount {
            let touchPointer = touchPointers[touchPointerIndex]
            if (touchPointer.isConsidered == true) && (touchPointer.isCaptureStartRotateValid == true) {
                rotationShift += touchPointer.captureTrackAngleDifference
                numberOfCapturedTouchPointers += 1
            }
        }
        
        if numberOfCapturedTouchPointers > 1 {
            rotationShift /= Float(numberOfCapturedTouchPointers)
        } else if numberOfCapturedTouchPointers == 1 {
            
        } else {
            // This case shouldn't happen, but......
            // if it does, we do not divide by 0....
            return
        }
        
        
        
        var newRotation = captureStartJiggleAnimationCursorRotation + rotationShift
        if newRotation > captureStartCursorFalloffRotation_U1 {
            
            // We're in the positive-rotation damped range. The
            // impact will taper off, based on the U1 U2 U3 ranges
            // we picked at the "capture start..........."
            
            newRotation = Math.fallOffOvershoot(input: newRotation,
                                                falloffStart: captureStartCursorFalloffRotation_U1,
                                                resultMax: captureStartCursorFalloffRotation_U2,
                                                inputMax: captureStartCursorFalloffRotation_U3)
        } else if newRotation < captureStartCursorFalloffRotation_D1 {
            
            // We're in the negative-rotation damped range. The
            // impact will taper off, based on the U1 U2 U3 ranges
            // we picked at the "capture start..........."
            
            newRotation = Math.fallOffUndershoot(input: newRotation,
                                                 falloffStart: captureStartCursorFalloffRotation_D1,
                                                 resultMin: captureStartCursorFalloffRotation_D2,
                                                 inputMin: captureStartCursorFalloffRotation_D3)
        }
        
        // The power slider value which the user has selected...
        let grabDragPowerPercentLinear = Jiggle.getGrabDragPowerPercentLinear(userGrabDragPower: jiggle.grabDragPower)
        
        // We're converting to the range [0.15...1.0]
        // This means that at 0.0, there is still some small effect...
        let grabDragRotateFactor = Jiggle.getGrabDragRotateFactor(grabDragPowerPercentLinear: grabDragPowerPercentLinear)
        
        // This is a little obtuse to follow.
        // If Both:
        // 1.) At the start of our capture session,
        // the rotation was outside of the positive-rotation
        // dampen range.
        // 2.) The new rotation is lower than the U1 that
        // we captured at the start of our capture session...
        //
        // Then, we will start a new capture session.
        // It will give us a wider dampen range......
        //
        let baseRotationU1 = Jiggle.animationCursorFalloffRotation_U1 * grabDragRotateFactor
        if (captureStartJiggleAnimationCursorRotation > baseRotationU1) && (newRotation < captureStartCursorFalloffRotation_U1) {
            captureStart_PrepareRotate(jiggle: jiggle,
                                       averageX: averageX,
                                       averageY: averageY)
            captureStart_Rotate(jiggle: jiggle, rotation: newRotation)
        }
        
        // This is a little obtuse to follow.
        // If Both:
        // 1.) At the start of our capture session,
        // the rotation was outside of the negative-rotation
        // dampen range.
        // 2.) The new rotation is higher than the D1 that
        // we captured at the start of our capture session...
        //
        // Then, we will start a new capture session.
        // It will give us a wider dampen range......
        //
        let baseRotationD1 = Jiggle.animationCursorFalloffRotation_D1 * grabDragRotateFactor
        if (captureStartJiggleAnimationCursorRotation < baseRotationD1) && (newRotation > captureStartCursorFalloffRotation_D1) {
            captureStart_PrepareRotate(jiggle: jiggle,
                                       averageX: averageX,
                                       averageY: averageY)
            captureStart_Rotate(jiggle: jiggle, rotation: newRotation)
        }
        
        // Assign it back to the jiggle.
        jiggle.animationCursorRotation = newRotation
        
        // It's converted to animatable data.
        // We animate the rotation with the same
        // exact math as the position...
        jiggle.animationInstructionGrab.registerCursorRotation(jiggle: jiggle, rotation: jiggle.animationCursorRotation)
        
        
        // In continuous mode, this will route back
        // and change the value of the slider...
        switch format {
        case .grab:
            break
        case .continuous:
            registerContinuousStartRotation(jiggle: jiggle,
                                            jiggleDocument: jiggleDocument)
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    @MainActor func registerContinuousStartRotation(jiggle: Jiggle,
                                                    jiggleDocument: JiggleDocument) {
        
        // We're converting the rotation value to
        // user-slider values. When the slider is
        // at 0% (the left), that's max-negative-value.
        // We get into a range from [0.0...1.0]
        let fixedRotation = fixRotation_NearZero(rotation: jiggle.animationCursorRotation)
        let rotationU2 = Jiggle.animationCursorFalloffRotation_U2
        let rotationD2 = Jiggle.animationCursorFalloffRotation_D2
        var rotationPercent = Float(fixedRotation - rotationD2) / (rotationU2 - rotationD2)
        if rotationPercent > 1.0 { rotationPercent = 1.0 }
        if rotationPercent < 0.0 { rotationPercent = 0.0 }
        
        // Not we get into a range [-180.0...180.0]
        let angleMin = AnimationInstructionContinuous.userContinuousRotationMin
        let angleMax = AnimationInstructionContinuous.userContinuousRotationMax
        jiggle.continuousStartRotation = angleMin + (angleMax - angleMin) * rotationPercent
        
        // This will trigger the slider to update, that is all.
        // It's also the reason we're on the main actor...
        jiggleDocument.animationContinuousRotationPublisher.send(())
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    private func fixRotation_NearZero(rotation: Float) -> Float {
        var result = rotation
        if result >= Math.pi2 || result <= Math._pi2 {
            result = fmodf(rotation, Math.pi2)
        }
        if result > Math.pi { result -= Math.pi2 }
        if result < Math._pi { result += Math.pi2 }
        return result
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    private func fixRotation_NearPreviousAngle(previousRotation: Float,
                                               currentRotation: Float) -> Float {
        
        // We try 8 equivalent rotations and
        // choose the one closest to the previousRotation.
        // It's a little sketchy, but it works!!!
        var result = currentRotation
        var bestDistance = Float(100_000_000.0)
        for step in -4...4 {
            let tryAngle = Float(step) * (Math.pi2) + currentRotation
            let tryDistance = fabsf(tryAngle - previousRotation)
            if tryDistance < bestDistance {
                bestDistance = tryDistance
                result = tryAngle
            }
        }
        return result
    }
    
}
