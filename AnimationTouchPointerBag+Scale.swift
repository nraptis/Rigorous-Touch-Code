//
//  AnimationTouchPointerBag+Scale.swift
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
    func captureStart_PrepareScale(jiggle: Jiggle,
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
                    // point, it's a suitable pointer to track distance with.
                    
                    let captureStartDistance = sqrtf(captureStartDistanceSquared)
                    touchPointer.captureStartDistance = captureStartDistance
                    touchPointer.captureTrackDistance = captureStartDistance
                    touchPointer.isCaptureStartScaleValid = true
                } else {
                    
                    // We're on top of the average point, we just
                    // won't use this touch pointer. Invalid capture...
                    
                    touchPointer.isCaptureStartScaleValid = false
                }
            }
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    func captureStart_Scale(jiggle: Jiggle, scale: Float) {
        
        // Record the scale that we start the capture with...
        captureStartJiggleAnimationCursorScale = scale
        
        // This is the user slider value for "power"...
        let grabDragPowerPercentLinear = Jiggle.getGrabDragPowerPercentLinear(userGrabDragPower: jiggle.grabDragPower)
        
        // We're converting to the range [0.20...1.0]
        // This means that at 0.0, there is still some small effect...
        let grabDragScaleFactor = Jiggle.getGrabDragScaleFactor(grabDragPowerPercentLinear: grabDragPowerPercentLinear)
        
        // We're adjusting the up scales based on the
        // power which the user has selected. 1.0 is
        // the resting scale, so we adjust based on
        // how far away the scale is from 1.0...
        let baseScaleStepU1 = Jiggle.animationCursorFalloffScale_U1 - 1.0
        let baseScaleU1 = 1.0 + baseScaleStepU1 * grabDragScaleFactor
        let baseScaleStepU2 = Jiggle.animationCursorFalloffScale_U2 - 1.0
        let baseScaleU2 = 1.0 + baseScaleStepU2 * grabDragScaleFactor
        let baseScaleStepU3 = Jiggle.animationCursorFalloffScale_U3 - 1.0
        let baseScaleU3 = 1.0 + baseScaleStepU3 * grabDragScaleFactor
        
        // We're adjusting the down scales based on the
        // power which the user has selected. 1.0 is
        // the resting scale, so we adjust based on
        // how far away the scale is from 1.0...
        let baseScaleStepD1 = 1.0 - Jiggle.animationCursorFalloffScale_D1
        let baseScaleD1 = 1.0 - baseScaleStepD1 * grabDragScaleFactor
        let baseScaleStepD2 = 1.0 - Jiggle.animationCursorFalloffScale_D2
        let baseScaleD2 = 1.0 - baseScaleStepD2 * grabDragScaleFactor
        let baseScaleStepD3 = 1.0 - Jiggle.animationCursorFalloffScale_D3
        let baseScaleD3 = 1.0 - baseScaleStepD3 * grabDragScaleFactor
        
        if scale > baseScaleU2 {
            
            // In this case, we're out of the
            // "allowed range" and the user
            // slammed their fingers down.
            
            // The down-scales all works as normal,
            // but the up-scales are all clamped
            // to whichever value the user's finger
            // has dictated to us, moving forward.
            
            captureStartCursorFalloffScale_U1 = scale
            captureStartCursorFalloffScale_U2 = scale
            captureStartCursorFalloffScale_U3 = scale
            captureStartCursorFalloffScale_D1 = baseScaleD1
            captureStartCursorFalloffScale_D2 = baseScaleD2
            captureStartCursorFalloffScale_D3 = baseScaleD3
        } else if scale > baseScaleU1 {
            
            // In this case, we're inside the
            // "dampen range" and the user
            // slammed their fingers down.
            
            // The down-scales all works as normal,
            // but the lowest up-scale is clamped
            // to whichever value the user's finger
            // has dictated to us, moving forward.
            
            captureStartCursorFalloffScale_U1 = scale
            captureStartCursorFalloffScale_U2 = baseScaleU2
            captureStartCursorFalloffScale_U3 = baseScaleU3
            captureStartCursorFalloffScale_D1 = baseScaleD1
            captureStartCursorFalloffScale_D2 = baseScaleD2
            captureStartCursorFalloffScale_D3 = baseScaleD3
        } else if scale < baseScaleD2 {
            
            // In this case, we're out of the
            // "allowed range" and the user
            // slammed their fingers down.
            
            // The up-scales all works as normal,
            // but the down-scales are all clamped
            // to whichever value the user's finger
            // has dictated to us, moving forward.
            
            captureStartCursorFalloffScale_U1 = baseScaleU1
            captureStartCursorFalloffScale_U2 = baseScaleU2
            captureStartCursorFalloffScale_U3 = baseScaleU3
            captureStartCursorFalloffScale_D1 = scale
            captureStartCursorFalloffScale_D2 = scale
            captureStartCursorFalloffScale_D3 = scale
        } else if scale < baseScaleD1 {
            
            // In this case, we're inside the
            // "dampen range" and the user
            // slammed their fingers down.
            
            // The up-scales all works as normal,
            // but the highest down-scale is clamped
            // to whichever value the user's finger
            // has dictated to us, moving forward.
            
            captureStartCursorFalloffScale_U1 = baseScaleU1
            captureStartCursorFalloffScale_U2 = baseScaleU2
            captureStartCursorFalloffScale_U3 = baseScaleU3
            captureStartCursorFalloffScale_D1 = scale
            captureStartCursorFalloffScale_D2 = baseScaleD2
            captureStartCursorFalloffScale_D3 = baseScaleD3
        } else {
            
            // The usual case, we don't need to adjust
            // any of the falloff values, it's a
            // regular grabbing event, use the standard.
            
            captureStartCursorFalloffScale_U1 = baseScaleU1
            captureStartCursorFalloffScale_U2 = baseScaleU2
            captureStartCursorFalloffScale_U3 = baseScaleU3
            captureStartCursorFalloffScale_D1 = baseScaleD1
            captureStartCursorFalloffScale_D2 = baseScaleD2
            captureStartCursorFalloffScale_D3 = baseScaleD3
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    func captureTrack_PrepareScale(jiggle: Jiggle, averageX: Float, averageY: Float) -> AnimationTouchPointerScaleResponse {
        
        // This range will be [132.0...318.0] on iPad.
        // This range will be [172.0...440.0] on iPhone.
        // Pretty much what we consider "1 full unit of
        // finger movements that converts to real scale values..."
        let scaleWeightUnit = Jiggle.getAnimationCursorScaleWeightUnit(measuredSize: jiggle.measuredSize)
        
        // We sum up the start distances.
        var startDistanceSum = Float(0.0)
        
        // As we move the touches, we sum up those distances.
        var trackDistanceSum = Float(0.0)
        
        // We also sum up unit weight distance for each touch.
        // so (track - start) / unit gives us an amount to scale by.
        var weightSum = Float(0.0)
        
        // We sum up the number of valid touch pointers...
        var numberOfCapturedTouchPointers = 0
        
        // For each touch pointer...
        for touchPointerIndex in 0..<touchPointerCount {
            let touchPointer = touchPointers[touchPointerIndex]
            
            // If the touch pointer is being considered...
            // And the touch pointer was valid when we started the scale...
            if (touchPointer.isConsidered == true) && (touchPointer.isCaptureStartScaleValid == true) {
                
                // How far from the average of all touch pointers
                // is *this* touch pointer?
                let diffX = averageX - touchPointer.x
                let diffY = averageY - touchPointer.y
                let captureTrackDistanceSquared = diffX * diffX + diffY * diffY
                if captureTrackDistanceSquared > Self.captureTrackDistanceThresholdSquared {
                    
                    // If we're not on top of the center point, we update the
                    // track distance. Otherwise, we'll just keep the previous
                    // value which was valid. This should be a transient state
                    // which ends very quickly, as we are considering 4 pixels "inside..."
                    
                    let captureTrackDistance = sqrtf(captureTrackDistanceSquared)
                    touchPointer.captureTrackDistance = captureTrackDistance
                }
                
                // Summing up the start track distances.
                startDistanceSum += touchPointer.captureStartDistance
                
                // Summing up the active track distances.
                trackDistanceSum += touchPointer.captureTrackDistance
                
                // Summing up the unit weight distances.
                weightSum += scaleWeightUnit
                
                // Summing up the valid touch pointers...
                numberOfCapturedTouchPointers += 1
            }
        }
        
        if numberOfCapturedTouchPointers > 1 {
            
            // If there's at least 2 valid pointers, we're
            // doing a pinch to scale the thing...........
            
            let scaleData = AnimationTouchPointerScaleData(startDistanceSum: startDistanceSum,
                                                         trackDistanceSum: trackDistanceSum,
                                                         weightSum: weightSum)
            return AnimationTouchPointerScaleResponse.valid(scaleData)
        } else {
            
            // If there's not 2 valid pointers,
            // it's not a valid scaling maneuver...
            
            return AnimationTouchPointerScaleResponse.invalid
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    //
    // @Precondition: captureTrack_PrepareScale
    @MainActor func captureTrack_Scale(jiggle: Jiggle,
                                       jiggleDocument: JiggleDocument,
                                       scaleData: AnimationTouchPointerScaleData,
                                       averageX: Float,
                                       averageY: Float) {
        
        if scaleData.weightSum < Math.epsilon {
            // This can't even happen, but if a magic
            // bit pixie manipulates the bits, it's
            // possible. We're basing a "unit of scale movement"
            // on the unit-scale-amount, so it should be
            // a pretty large number. The scale data should
            // have been valid at this point................
            return
        }
        
        // What amount of a "unit scale" did we start at?
        let scaleFractionStart = scaleData.startDistanceSum / scaleData.weightSum
        
        // What amount of a "unit scale" are we currently at?
        let scaleFractionTrack = scaleData.trackDistanceSum / scaleData.weightSum
        
        // The difference between the 2 above...
        let scaleFractionDelta = (scaleFractionTrack - scaleFractionStart)
        
        // Start + Delta = Current
        var newScale = captureStartJiggleAnimationCursorScale + scaleFractionDelta
        
        // The power slider value which the user has selected...
        let grabDragPowerPercentLinear = Jiggle.getGrabDragPowerPercentLinear(userGrabDragPower: jiggle.grabDragPower)
        
        // We're converting to the range [0.20...1.0]
        // This means that at 0.0, there is still some small effect...
        let grabDragScaleFactor = Jiggle.getGrabDragScaleFactor(grabDragPowerPercentLinear: grabDragPowerPercentLinear)
        
        if newScale > captureStartCursorFalloffScale_U1 {
            
            // We're in the up-scale damped range. The impact
            // will taper off, based on the U1 U2 U3 ranges
            // we picked at the "capture start..........."
            
            newScale = Math.fallOffOvershoot(input: newScale,
                                             falloffStart: captureStartCursorFalloffScale_U1,
                                             resultMax: captureStartCursorFalloffScale_U2,
                                             inputMax: captureStartCursorFalloffScale_U3)
        } else if newScale < captureStartCursorFalloffScale_D1 {
            
            // We're in the down-scale damped range. The impact
            // will taper off, based on the D1 D2 D3 ranges
            // we picked at the "capture start..........."
            
            newScale = Math.fallOffUndershoot(input: newScale,
                                              falloffStart: captureStartCursorFalloffScale_D1,
                                              resultMin: captureStartCursorFalloffScale_D2,
                                              inputMin: captureStartCursorFalloffScale_D3)
        }
        
        // This is a little obtuse to follow.
        // If Both:
        // 1.) At the start of our capture session,
        // the scale was outside of the up-scale dampen
        // range.
        // 2.) The new scale is lower than the U1 that
        // we captured at the start of our capture session...
        //
        // Then, we will start a new capture session.
        // It will give us a wider dampen range......
        //
        let baseScaleStepU1 = Jiggle.animationCursorFalloffScale_U1 - 1.0
        let baseScaleU1 = 1.0 + baseScaleStepU1 * grabDragScaleFactor
        
        if (captureStartJiggleAnimationCursorScale > baseScaleU1) && (newScale < captureStartCursorFalloffScale_U1) {
            captureStart_PrepareScale(jiggle: jiggle,
                                      averageX: averageX,
                                      averageY: averageY)
            captureStart_Scale(jiggle: jiggle,
                               scale: newScale)
        }
        
        // This is a little obtuse to follow.
        // If Both:
        // 1.) At the start of our capture session,
        // the scale was outside of the down-scale dampen
        // range.
        // 2.) The new scale is higher than the D1 that
        // we captured at the start of our capture session...
        //
        // Then, we will start a new capture session.
        // It will give us a wider dampen range......
        //
        let baseScaleStepD1 = 1.0 - Jiggle.animationCursorFalloffScale_D1
        let baseScaleD1 = 1.0 - baseScaleStepD1 * grabDragScaleFactor
        if (captureStartJiggleAnimationCursorScale < baseScaleD1) && (newScale > captureStartCursorFalloffScale_D1) {
            captureStart_PrepareScale(jiggle: jiggle,
                                      averageX: averageX,
                                      averageY: averageY)
            captureStart_Scale(jiggle: jiggle,
                               scale: newScale)
        }
        
        // Assign it back to the jiggle.
        jiggle.animationCursorScale = newScale
        
        // It's converted to animatable data.
        // We animate the scale with the same
        // exact math as the position...
        jiggle.animationInstructionGrab.registerCursorScale(jiggle: jiggle, scale: jiggle.animationCursorScale)
        
        // In continuous mode, this will route back
        // and change the value of the slider...
        switch format {
        case .grab:
            break
        case .continuous:
            registerContinuousStartScale(jiggle: jiggle,
                                         jiggleDocument: jiggleDocument)
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    @MainActor func registerContinuousStartScale(jiggle: Jiggle,
                                                 jiggleDocument: JiggleDocument) {
        
        // We're converting the scale value to
        // user-slider values. When the slider is
        // at 50% (the middle), that's "resting" / 1.0
        let scale = jiggle.animationCursorScale
        let scaleU2 = Jiggle.animationCursorFalloffScale_U2
        let scaleD2 = Jiggle.animationCursorFalloffScale_D2
        var scalePercent = Float(0.5)
        if scale > 1.0 {
            var percentUp = (scale - 1.0) / (scaleU2 - 1.0)
            if percentUp > 1.0 { percentUp = 1.0 }
            if percentUp < 0.0 { percentUp = 0.0 }
            scalePercent = 0.5 + percentUp * 0.5
        } else if scale < 1.0 {
            var percentDown = (1.0 - scale) / (1.0 - scaleD2)
            if percentDown > 1.0 { percentDown = 1.0 }
            if percentDown < 0.0 { percentDown = 0.0 }
            scalePercent = 0.5 - percentDown * 0.5
        }
        let scaleMin = AnimationInstructionContinuous.userContinuousScaleMin
        let scaleMax = AnimationInstructionContinuous.userContinuousScaleMax
        jiggle.continuousStartScale = scaleMin + (scaleMax - scaleMin) * scalePercent
        
        // This will trigger the slider to update, that is all.
        // It's also the reason we're on the main actor...
        jiggleDocument.animationContinuousScalePublisher.send(())
    }
}
