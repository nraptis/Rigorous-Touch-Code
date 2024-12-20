//
//  AnimationTouchPointerBag+Position.swift
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
    func captureStart_Position(jiggle: Jiggle,
                               cursorX: Float,
                               cursorY: Float,
                               averageX: Float,
                               averageY: Float) {
        
        // We're considering the average of all the touches
        // to be "where the mouse is..." and that's really
        // the crux of that's going on here.
        
        captureStartAverageTouchPointerPosition.x = averageX
        captureStartAverageTouchPointerPosition.y = averageY
        
        // We get the radii adjusted by the "grab drag power" (user slider)
        // Between R2 and R3, we taper off. The input value gets clamped at R3.
        var baseDistance_R1 = Float(0.0)
        var baseDistance_R2 = Float(0.0)
        var baseDistance_R3 = Float(0.0)
        Jiggle.getAnimationCursorFalloffDistance_Radii(measuredSize: jiggle.measuredSize,
                                                       userGrabDragPower: jiggle.grabDragPower,
                                                       distance_R1: &baseDistance_R1,
                                                       distance_R2: &baseDistance_R2,
                                                       distance_R3: &baseDistance_R3)
        
        // The magnitide of the cursor as a vector...
        let cursorLengthSquared = cursorX * cursorX + cursorY * cursorY
        let cursorLength: Float
        if cursorLengthSquared > Math.epsilon {
            
            // If the cursor is not right on the average point...
            // We make this distinction just to not take sqrt(0)...
            
            // sqrt(dx^2 + dy^2) = distance
            cursorLength = sqrtf(cursorLengthSquared)
            
            
            if cursorLength <= baseDistance_R1 {
                
                // This is our "normal range" so no adjustments are
                // needed for our damper falloff values...
                
                captureStartCursorFalloffDistance_R1 = baseDistance_R1
                captureStartCursorFalloffDistance_R2 = baseDistance_R2
                captureStartCursorFalloffDistance_R3 = baseDistance_R3
            } else if cursorLength <= baseDistance_R2 {
                
                // This is within our damping range, so we adjust
                // R1 to be the exact length of the cursor when
                // the user's finget slams down on the screen.
                
                captureStartCursorFalloffDistance_R1 = cursorLength
                captureStartCursorFalloffDistance_R2 = baseDistance_R2
                captureStartCursorFalloffDistance_R3 = baseDistance_R3
            } else {
                
                // We are outside of the valid range, meaning
                // the user's finger slammed down when the
                // motion was at an awkward moment. We adjust
                //all of our dampers to be this user-dictated value.
                
                captureStartCursorFalloffDistance_R1 = cursorLength
                captureStartCursorFalloffDistance_R2 = cursorLength
                captureStartCursorFalloffDistance_R3 = cursorLength
            }
            
            // Record the starting position (cursorX, cursorY)
            
            captureStartJiggleAnimationCursorPosition.x = cursorX
            captureStartJiggleAnimationCursorPosition.y = cursorY
        } else {
            
            // We are effectively at (0, 0) with the cursor,
            // so we are within the R1 circle (can use regular
            // damping values) and consider the positon (0, 0)
            
            captureStartJiggleAnimationCursorPosition.x = 0.0
            captureStartJiggleAnimationCursorPosition.y = 0.0
            captureStartCursorFalloffDistance_R1 = baseDistance_R1
            captureStartCursorFalloffDistance_R2 = baseDistance_R2
            captureStartCursorFalloffDistance_R3 = baseDistance_R3
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    @MainActor func captureTrack_Position(jiggle: Jiggle,
                                          jiggleDocument: JiggleDocument,
                                          averageX: Float,
                                          averageY: Float) {
        
        // How far have we moved away from where we were
        // when we started the capture? This is our delta...
        let diffX = averageX - captureStartAverageTouchPointerPosition.x
        let diffY = averageY - captureStartAverageTouchPointerPosition.y
        
        // We "propose" the new position to be
        // start_position + delta_position
        let proposedX = captureStartJiggleAnimationCursorPosition.x + diffX
        let proposedY = captureStartJiggleAnimationCursorPosition.y + diffY
        var cursorDirX = proposedX
        var cursorDirY = proposedY
        
        // Let's figure out the magnitide of
        // the vector defined by our proposed location.
        let cursorLengthSquared = cursorDirX * cursorDirX + cursorDirY * cursorDirY
        if cursorLengthSquared > Math.epsilon {
            
            // sqrt(dx^2 + dy^2) = distance
            let cursorLength = sqrtf(cursorLengthSquared)
            
            // This is the start of our dampen radius, adjusted
            // by the user-defined slider value (grab drag power)...
            let baseDistance_R1 = Jiggle.getAnimationCursorFalloffDistance_R1(format: format,
                                                                              measuredSize: jiggle.measuredSize,
                                                                              userGrabDragPower: jiggle.grabDragPower)
            
            // This is a little obtuse to follow.
            // If Both:
            // 1.) At the start of our capture session,
            // the position's length was outside of the
            // position radius dampen range. (R1...INFINITY)
            // 2.) The new position's length is higher than
            // the R1 that we captured at the start of our
            // capture session...
            //
            // Then, we will start a new capture session.
            // It will give us a wider dampen range......
            //
            if (captureStartCursorFalloffDistance_R1 > baseDistance_R1) && (cursorLength < captureStartCursorFalloffDistance_R1) {
                jiggle.animationCursorX = proposedX
                jiggle.animationCursorY = proposedY
                captureStart_Position(jiggle: jiggle,
                                      cursorX: proposedX,
                                      cursorY: proposedY,
                                      averageX: averageX,
                                      averageY: averageY)
            } else if cursorLength > captureStartCursorFalloffDistance_R1 {
                
                // We're in the position length damped range. The
                //impact will taper off, based on the D1 D2 D3 ranges
                // we picked at the "capture start..........."
                
                cursorDirX /= cursorLength
                cursorDirY /= cursorLength
                let fixedDistance = Math.fallOffOvershoot(input: cursorLength,
                                                          falloffStart: captureStartCursorFalloffDistance_R1,
                                                          resultMax: captureStartCursorFalloffDistance_R2,
                                                          inputMax: captureStartCursorFalloffDistance_R3)
                jiggle.animationCursorX = cursorDirX * fixedDistance
                jiggle.animationCursorY = cursorDirY * fixedDistance
            } else {
                
                // We're lower than R1, so we do not need any
                // dampening or tapering. Just use the recorded position.
                
                jiggle.animationCursorX = cursorDirX
                jiggle.animationCursorY = cursorDirY
            }
        } else {
            
            // In this case, we are proposing
            // that the position is (0, 0).
            // Hard to argue against that...
            
            jiggle.animationCursorX = 0.0
            jiggle.animationCursorY = 0.0
        }
        
        // In continuous mode, this will route back
        // and change the value of the sliders...
        switch format {
        case .grab:
            break
        case .continuous:
            registerContinuousStartPosition(jiggle: jiggle,
                                            jiggleDocument: jiggleDocument)
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    @MainActor func registerContinuousStartPosition(jiggle: Jiggle,
                                                    jiggleDocument: JiggleDocument) {
        
        // We're converting the distance into
        // the "power" of our continuous slider...
        let cursorDirX = jiggle.animationCursorX
        let cursorDirY = jiggle.animationCursorY
        let cursorLengthSquared = cursorDirX * cursorDirX + cursorDirY * cursorDirY
        let cursorLength: Float
        if cursorLengthSquared > Math.epsilon {
            cursorLength = sqrtf(cursorLengthSquared)
        } else {
            cursorLength = 0.0
        }
        
        // Adjusted by the size of the Jiggle...
        let measurePercentLinear = Jiggle.getMeasurePercentLinear(measuredSize: jiggle.measuredSize)
        
        // R2 is considered max-power (100%)
        let distanceR2 = Jiggle.getAnimationCursorFalloffDistance_R2(measurePercentLinear: measurePercentLinear)
        
        // We also get the angle for the
        // "direction" continuous slider...
        let angle: Float
        if cursorLength > Math.epsilon {
            angle = -atan2f(-jiggle.animationCursorX, -jiggle.animationCursorY)
        } else {
            angle = 0.0
        }
        
        // We convert angle to the range [0.0...1.0]
        let fixedAngle = fixRotation_GreaterThanZero(rotation: angle)
        var anglePercent = fixedAngle / Math.pi2
        if anglePercent < 0.0 { anglePercent = 0.0 }
        if anglePercent > 1.0 { anglePercent = 1.0 }
        
        // We convert power to the range [0.0...1.0]
        var powerPercent = cursorLength / distanceR2
        if powerPercent < 0.0 { powerPercent = 0.0 }
        if powerPercent > 1.0 { powerPercent = 1.0 }
        
        // We convert angle to slider value [-180.0...180.0]
        let angleMin = AnimationInstructionContinuous.userContinuousAngleMin
        let angleMax = AnimationInstructionContinuous.userContinuousAngleMax
        jiggle.continuousAngle = angleMin + (angleMax - angleMin) * anglePercent
        
        // We convert power to slider value [0.0...100.0]
        let powerMin = AnimationInstructionContinuous.userContinuousPowerMin
        let powerMax = AnimationInstructionContinuous.userContinuousPowerMax
        jiggle.continuousPower = powerMin + (powerMax - powerMin) * powerPercent
        
        // This will trigger the sliders to update, that is all.
        // It's also the reason we're on the main actor...
        jiggleDocument.animationContinuousDraggingPublisher.send(())
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    private func fixRotation_GreaterThanZero(rotation: Float) -> Float {
        var result = rotation
        if result >= Math.pi2 || result <= Math._pi2 {
            result = fmodf(rotation, Math.pi2)
        }
        if result < 0.0 {
            result += Math.pi2
        }
        return result
    }
    
}
