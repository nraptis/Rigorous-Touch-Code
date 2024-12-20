//
//  AnimationInstructionGrab.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/7/24.
//

import Foundation

// [Animation Mode Verify] 12-19-2024
// Looks good, no problem. We are using everything
// in this file, it's all working to specification.
//
class AnimationInstructionGrab: AnimationCommandsCommandable {
    
    static let STEP_COUNT = 32
    static let STEP_COUNTF = Float(STEP_COUNT)
    
    static let flingHangTimeLimit = Float(0.115)
    
    static let snoozeTimeLimit = Float(2.0)
    static let snoozeTickLimit = 3
    
    static let speedHiMin = Float(3218.0)
    static let speedHiMax = Float(5640.0)
    
    static let speedLoMin = Float(144.0 * 3.0)
    static let speedLoMax = Float(276.0 * 3.0)
    
    static let cursorElasticMaxLo = Float(0.12)
    static let cursorElasticMaxRange = Float(2.76)
    
    static let gyroMinLengthPad = Float(0.26)
    static let gyroMaxLengthPad = Float(6.8)
    
    static let gyroMinLengthPhone = Float(0.34)
    static let gyroMaxLengthPhone = Float(9.0)
    
    static let grabDragGyroPowerMultiplierLo = Float(0.2)
    static let grabDragGyroPowerMultiplierRange = Float(0.8)
    
    static let stiffnessMultiplierCap = Float(0.48)
    static let stiffnessMultiplierMinus = Float(0.44)
    
    static let flingLargePhone_000 = Float(0.43721876)
    static let flingLargePhone_025 = Float(0.74833775)
    static let flingLargePhone_050 = Float(0.8921888)
    static let flingLargePhone_075 = Float(0.97450274)
    static let flingLargePhone_100 = Float(1.0308849)
    
    static let flingMediumPhone_000 = Float(0.44604832)
    static let flingMediumPhone_025 = Float(0.7766216)
    static let flingMediumPhone_050 = Float(0.9285125)
    static let flingMediumPhone_075 = Float(1.015327)
    static let flingMediumPhone_100 = Float(1.0747646)
    
    static let flingSmallPhone_000 = Float(0.4608757)
    static let flingSmallPhone_025 = Float(0.82453537)
    static let flingSmallPhone_050 = Float(0.9900773)
    static let flingSmallPhone_075 = Float(1.0845323)
    static let flingSmallPhone_100 = Float(1.1491463)
    
    static let flingLargePad_000 = Float(0.47225678)
    static let flingLargePad_025 = Float(0.8203307)
    static let flingLargePad_050 = Float(0.9812279)
    static let flingLargePad_075 = Float(1.0733016)
    static let flingLargePad_100 = Float(1.1363759)
    
    static let flingMediumPad_000 = Float(0.49242094)
    static let flingMediumPad_025 = Float(0.86781204)
    static let flingMediumPad_050 = Float(1.0402796)
    static let flingMediumPad_075 = Float(1.1388471)
    static let flingMediumPad_100 = Float(1.2063453)
    
    static let flingSmallPad_000 = Float(0.529457)
    static let flingSmallPad_025 = Float(0.9540771)
    static let flingSmallPad_050 = Float(1.1473556)
    static let flingSmallPad_075 = Float(1.2576535)
    static let flingSmallPad_100 = Float(1.3330941)
    
    static let gyroLargePhone_000 = Float(0.225 + (0.225 - 0.168))
    static let gyroLargePhone_025 = Float(0.225)
    static let gyroLargePhone_050 = Float(0.168)
    static let gyroLargePhone_075 = Float(0.129)
    static let gyroLargePhone_100 = Float(0.117)
    
    static let gyroMediumPhone_000 = Float(0.195 + (0.195 - 0.133))
    static let gyroMediumPhone_025 = Float(0.195)
    static let gyroMediumPhone_050 = Float(0.133)
    static let gyroMediumPhone_075 = Float(0.115)
    static let gyroMediumPhone_100 = Float(0.108)
    
    static let gyroSmallPhone_000 = Float(0.176 + (0.176 - 0.113))
    static let gyroSmallPhone_025 = Float(0.176)
    static let gyroSmallPhone_050 = Float(0.113)
    static let gyroSmallPhone_075 = Float(0.107)
    static let gyroSmallPhone_100 = Float(0.105)
    
    static let gyroLargePad_000 = Float(0.192 + (0.192 - 0.159))
    static let gyroLargePad_025 = Float(0.192)
    static let gyroLargePad_050 = Float(0.159)
    static let gyroLargePad_075 = Float(0.140)
    static let gyroLargePad_100 = Float(0.140)
    
    static let gyroMediumPad_000 = Float(0.186 + (0.186 - 0.153))
    static let gyroMediumPad_025 = Float(0.186)
    static let gyroMediumPad_050 = Float(0.153)
    static let gyroMediumPad_075 = Float(0.138)
    static let gyroMediumPad_100 = Float(0.129)
    
    static let gyroSmallPad_000 = Float(0.180 + (0.180 - 0.141))
    static let gyroSmallPad_025 = Float(0.180)
    static let gyroSmallPad_050 = Float(0.141)
    static let gyroSmallPad_075 = Float(0.135)
    static let gyroSmallPad_100 = Float(0.120)
    
    var cursorSpeedX = Float(0.0)
    var cursorSpeedY = Float(0.0)
    
    var cursorScaleSamplerX = Float(0.0)
    var cursorScaleSamplerSpeedX = Float(0.0)
    
    var cursorRotationSamplerX = Float(0.0)
    var cursorRotationSamplerSpeedX = Float(0.0)
    
    var cursorElastic = Float(0.0)
    var cursorElasticScaleAndRotation = Float(0.0)
    
    var cursorGyroSleepTime = Float(0.5)
    
    var flingHangTime = Float(0.0)
    var snoozeTime = Float(0.0)
    var snoozeTick = 0
    
    let pointerBag = AnimationTouchPointerBag(format: .grab)
    let stateBag = AnimationTouchStateBag(format: .grab)
    
    init() {
        
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    func update_Inactive(deltaTime: Float) {
        pointerBag.update(deltaTime: deltaTime)
        _ = update_Snooze(deltaTime: deltaTime)
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    // There's some "magic numbers," but I've
    // eliminated the ones that made sense.
    func update_Active(deltaTime: Float,
                       jiggleDocument: JiggleDocument,
                       jiggle: Jiggle,
                       isGyroEnabled: Bool,
                       clock: Float) {
        
        pointerBag.update(deltaTime: deltaTime)
        
        if !update_Snooze(deltaTime: deltaTime) {
            return
        }
        
        let measuredSize = jiggle.measuredSize
        let measurePercentLinear = Jiggle.getMeasurePercentLinear(measuredSize: measuredSize)
        let distanceR2 = Jiggle.getAnimationCursorFalloffDistance_R2(measurePercentLinear: measurePercentLinear)
        
        if !jiggle.isCaptureActiveGrab {
            
            let grabDragSpeedPercentLinear = Jiggle.getGrabDragSpeedPercentLinear(userGrabDragSpeed: jiggle.grabSpeed)
            let grabDragStiffnessPercentLinear = Jiggle.getGrabDragStiffnessPercentLinear(userGrabDragStiffness: jiggle.grabStiffness)
            
            var cursorX = jiggle.animationCursorX
            var cursorY = jiggle.animationCursorY
            
            var cursorXScale = cursorScaleSamplerX
            var cursorXRotation = cursorRotationSamplerX
            
            let gyroX = ApplicationController.gyroSmoothX
            let gyroY = ApplicationController.gyroSmoothY
            
            let gyroDirX: Float
            let gyroDirY: Float
            let gyroLengthSquared = gyroX * gyroX + gyroY * gyroY
            let gyroLength: Float
            if gyroLengthSquared > Math.epsilon {
                gyroLength = sqrtf(gyroLengthSquared)
                gyroDirX = gyroX / gyroLength
                gyroDirY = gyroY / gyroLength
            } else {
                gyroLength = 0.0
                gyroDirX = 0.0
                gyroDirY = 0.0
            }
            
            let gyroMaxLength: Float
            let gyroMinLength: Float
            if Device.isPad {
                gyroMinLength = Self.gyroMinLengthPad
                gyroMaxLength = Self.gyroMaxLengthPad
            } else {
                gyroMinLength = Self.gyroMinLengthPhone
                gyroMaxLength = Self.gyroMaxLengthPhone
            }
            var gyroLengthPercent = (gyroLength - gyroMinLength) / (gyroMaxLength - gyroMinLength)
            if gyroLengthPercent > 1.0 { gyroLengthPercent = 1.0 }
            if gyroLengthPercent < 0.0 { gyroLengthPercent = 0.0 }
            
            let fractionPerStep = deltaTime / AnimationInstructionGrab.STEP_COUNTF
            
            let grabDragSpeedPercent = Math.mixPercentCubicOpposite(percent: grabDragSpeedPercentLinear, linearFactor: 0.5)
            
            let grabDragGyroPowerPercentLinear = Jiggle.getGrabDragGyroPowerPercentLinear(userGrabDragGyroPower: jiggle.grabGyroPower)
            let grabDragGyroPowerMultiplier = Self.grabDragGyroPowerMultiplierLo + Self.grabDragGyroPowerMultiplierRange * grabDragGyroPowerPercentLinear
            
            let gyroMultiplier = grabDragGyroPowerMultiplier * getGyroMultiplier(grabDragSpeedPercent: grabDragSpeedPercentLinear,
                                                                                 measuredSize: measuredSize)
            
            let speedHi = Self.speedHiMin + (Self.speedHiMax - Self.speedHiMin) * measurePercentLinear
            let speedLo = Self.speedLoMin + (Self.speedLoMax - Self.speedLoMin) * measurePercentLinear
            let speed = speedLo + (speedHi - speedLo) * grabDragSpeedPercent
            
            // What we noticed is that in the middle, it makes
            // more sense for the elasticity to be lower. E.G.
            // quicker jiggles by default. Too long is bad.
            
            let cursorElasticRangePercent = Math.mixPercentCubic(percent: grabDragStiffnessPercentLinear, linearFactor: 0.3)
            
            let cursorElasticMin = Float(0.0)
            let cursorElasticMax = Self.cursorElasticMaxLo + cursorElasticRangePercent * Self.cursorElasticMaxRange
            let cursorElasticRange = (cursorElasticMax - cursorElasticMin)
            
            let deltaTime_Count = (deltaTime / AnimationInstructionGrab.STEP_COUNTF)
            
            for _ in 0..<AnimationInstructionGrab.STEP_COUNT {
                
                // ==============================
                // ==============================
                // Chapter Θ - Elastic stuff (position)
                // ==============================
                // ==============================
                
                cursorElastic += fractionPerStep
                if cursorElastic > cursorElasticMax {
                    cursorElastic = cursorElasticMax
                }
                
                let cursorElasticPercentLinear = (cursorElastic - cursorElasticMin) / cursorElasticRange
                let cursorElasticPercent = Math.mixPercentSin(percent: cursorElasticPercentLinear, linearFactor: 0.4)
                let fractionalStiffnessMultiplier = powf(Self.stiffnessMultiplierCap - Self.stiffnessMultiplierMinus * cursorElasticPercent, deltaTime_Count)
                
                
                // ==============================
                // ==============================
                // Chapter Ψ - Elastic stuff (scale AND rotation)
                // ==============================
                // ==============================
                
                cursorElasticScaleAndRotation += fractionPerStep
                if cursorElasticScaleAndRotation > cursorElasticMax {
                    cursorElasticScaleAndRotation = cursorElasticMax
                }
                
                let cursorElasticPercentLinearScaleAndRotation = (cursorElasticScaleAndRotation - cursorElasticMin) / cursorElasticRange
                let cursorElasticPercentScaleAndRotation = Math.mixPercentSin(percent: cursorElasticPercentLinearScaleAndRotation, linearFactor: 0.4)
                let fractionalStiffnessMultiplierScaleAndRotation = powf(Self.stiffnessMultiplierCap - Self.stiffnessMultiplierMinus * cursorElasticPercentScaleAndRotation, deltaTime_Count)
                
                
                // ==============================
                // ==============================
                // Chapter I - The position:
                // ==============================
                // ==============================
                
                // I-A.) Getting the magnitude and direction
                // of the animation cursor (x and y position)
                var diffX1 = -cursorX
                var diffY1 = -cursorY
                let distanceSquared1 = diffX1 * diffX1 + diffY1 * diffY1
                let distance1: Float
                if distanceSquared1 > Math.epsilon {
                    distance1 = sqrtf(distanceSquared1)
                    diffX1 /= distance1
                    diffY1 /= distance1
                } else {
                    diffX1 = 0.0
                    diffY1 = 0.0
                    distance1 = 0.0
                }
                
                let moveAmount = speed * fractionPerStep
                
                // I-B.) Computing how far away from the center
                // we are, as smoothed percent... (x and y position)
                let percentAwayFromCenterLinear = distance1 / distanceR2
                let percentAwayFromCenterLinearInverse = (1.0 - percentAwayFromCenterLinear)
                let percentAwayFromCenter = Math.mixPercentSin(percent: percentAwayFromCenterLinear, linearFactor: 0.4)
                
                
                // I-C.) Applying the gyro, based on stud data. (x and y position)
                let gyroPercentLinear = percentAwayFromCenterLinearInverse
                let gyroPercent = Math.mixPercentQuadratic(percent: gyroPercentLinear, linearFactor: 0.5)
                if isGyroEnabled {
                    
                    // Pretty much, while we're shaking the device
                    // around, it becomes like we just started again.
                    cursorElastic -= gyroLengthPercent * 12.0 * fractionPerStep
                    if cursorElastic < 0.0 {
                        cursorElastic = 0.0
                    }
                    
                    cursorX += gyroDirX * gyroLength * gyroPercent * moveAmount * gyroMultiplier
                    cursorY += gyroDirY * gyroLength * gyroPercent * moveAmount * gyroMultiplier
                }
                
                
                // I-D1.) Updating the cursor speed... (x and y position)
                cursorSpeedX += diffX1 * moveAmount * percentAwayFromCenter
                cursorSpeedY += diffY1 * moveAmount * percentAwayFromCenter
                
                // I-D2.) Moving the cursor by the cursor speed... (x and y position)
                cursorX += cursorSpeedX * deltaTime
                cursorY += cursorSpeedY * deltaTime
                
                // I-D3.) Multiplying the cursor speed by damper... (x and y position)
                cursorSpeedX *= fractionalStiffnessMultiplier
                cursorSpeedY *= fractionalStiffnessMultiplier
                
                
                // I-E.) Getting the *NEW* magnitude and direction
                // of the animation cursor (x and y position)
                let counterForcePercent = Math.mixPercentSin(percent: percentAwayFromCenterLinearInverse, linearFactor: 0.4)
                var diffX2 = -cursorX
                var diffY2 = -cursorY
                let distanceSquared2 = diffX2 * diffX2 + diffY2 * diffY2
                let distance2: Float
                if distanceSquared2 > Math.epsilon {
                    distance2 = sqrtf(distanceSquared2)
                    diffX2 /= distance2
                    diffY2 /= distance2
                } else {
                    diffX2 = 0.0
                    diffY2 = 0.0
                    distance2 = 0.0
                }
                
                // I-F.) Getting the power of the counter force
                // for the moved animation cursor (x and y position)
                var counterStepLength = moveAmount * 0.4 * counterForcePercent
                if counterStepLength > distance2 {
                    counterStepLength = distance2
                }
                
                // I-G.) Applying the counter force (x and y position)
                cursorX += diffX2 * counterStepLength * deltaTime
                cursorY += diffY2 * counterStepLength * deltaTime
                
                
                // ==============================
                // ==============================
                // Chapter II - The scale:
                // ==============================
                // ==============================
                
                // II-A.) Getting the magnitude and direction
                // of the animation cursor (fake scale x position)
                var diffX1Scale = -cursorXScale
                let distance1Scale = fabsf(diffX1Scale)
                if diffX1Scale > 0.0 {
                    diffX1Scale = 1.0
                } else if diffX1Scale < 0.0 {
                    diffX1Scale = -1.0
                } else {
                    diffX1Scale = 0.0
                }
                
                // II-B.) Computing how far away from the center
                // we are, as smoothed percent... (fake scale x position)
                let percentAwayFromCenterLinearScale = distance1Scale / distanceR2
                let percentAwayFromCenterLinearInverseScale = (1.0 - percentAwayFromCenterLinearScale)
                let percentAwayFromCenterScale = Math.mixPercentSin(percent: percentAwayFromCenterLinearScale, linearFactor: 0.4)
                
                // II-D1.) Updating the cursor speed... (fake scale x position)
                cursorScaleSamplerSpeedX += diffX1Scale * moveAmount * percentAwayFromCenterScale
                
                // II-D2.) Moving the cursor by the cursor speed... (fake scale x position)
                cursorXScale += cursorScaleSamplerSpeedX * deltaTime
                
                // II-D3.) Multiplying the cursor speed by damper... (fake scale x position)
                cursorScaleSamplerSpeedX *= fractionalStiffnessMultiplierScaleAndRotation
                
                // II-E.) Getting the *NEW* magnitude and direction
                // of the animation cursor (fake scale x position)
                let counterForcePercentScale = Math.mixPercentSin(percent: percentAwayFromCenterLinearInverseScale, linearFactor: 0.4)
                var diffX2Scale = -cursorXScale
                let distance2Scale = fabsf(diffX2Scale)
                if diffX2Scale > 0.0 {
                    diffX2Scale = 1.0
                } else if diffX2Scale < 0.0 {
                    diffX2Scale = -1.0
                } else {
                    diffX2Scale = 0.0
                }
                
                // II-F.) Getting the power of the counter force
                // for the moved animation cursor (fake scale x position)
                var counterStepLengthScale = moveAmount * 0.4 * counterForcePercentScale
                if counterStepLengthScale > distance2Scale {
                    counterStepLengthScale = distance2Scale
                }
                
                // II-G.) Applying the counter force (fake scale x position)
                cursorXScale += diffX2Scale * counterStepLengthScale * deltaTime
                
                
                // ==============================
                // ==============================
                // Chapter III - The rotation:
                // ==============================
                // ==============================
                
                
                // III-A.) Getting the magnitude and direction
                // of the animation cursor (fake rotation x position)
                var diffX1Rotation = -cursorXRotation
                let distance1Rotation = fabsf(diffX1Rotation)
                if diffX1Rotation > 0.0 {
                    diffX1Rotation = 1.0
                } else if diffX1Rotation < 0.0 {
                    diffX1Rotation = -1.0
                } else {
                    diffX1Rotation = 0.0
                }
                
                // III-B.) Computing how far away from the center
                // we are, as smoothed percent... (fake rotation x position)
                let percentAwayFromCenterLinearRotation = distance1Rotation / distanceR2
                let percentAwayFromCenterLinearInverseRotation = (1.0 - percentAwayFromCenterLinearRotation)
                let percentAwayFromCenterRotation = Math.mixPercentSin(percent: percentAwayFromCenterLinearRotation, linearFactor: 0.4)
                
                // III-D1.) Updating the cursor speed... (fake rotation x position)
                cursorRotationSamplerSpeedX += diffX1Rotation * moveAmount * percentAwayFromCenterRotation
                
                // III-D2.) Moving the cursor by the cursor speed... (fake rotation x position)
                cursorXRotation += cursorRotationSamplerSpeedX * deltaTime
                
                // III-D3.) Multiplying the cursor speed by damper... (fake rotation x position)
                cursorRotationSamplerSpeedX *= fractionalStiffnessMultiplierScaleAndRotation
                
                // III-E.) Getting the *NEW* magnitude and direction
                // of the animation cursor (fake rotation x position)
                let counterForcePercentRotation = Math.mixPercentSin(percent: percentAwayFromCenterLinearInverseRotation, linearFactor: 0.4)
                var diffX2Rotation = -cursorXRotation
                let distance2Rotation = fabsf(diffX2Rotation)
                if diffX2Rotation > 0.0 {
                    diffX2Rotation = 1.0
                } else if diffX2Rotation < 0.0 {
                    diffX2Rotation = -1.0
                } else {
                    diffX2Rotation = 0.0
                }
                
                // III-F.) Getting the power of the counter force
                // for the moved animation cursor (fake rotation x position)
                var counterStepLengthRotation = moveAmount * 0.4 * counterForcePercentRotation
                if counterStepLengthRotation > distance2Rotation {
                    counterStepLengthRotation = distance2Rotation
                }
                
                // III-G.) Applying the counter force (fake rotation x position)
                cursorXRotation += diffX2Rotation * counterStepLengthRotation * deltaTime
                
            }
            
            // Assign x and y back to the jiggle.
            jiggle.animationCursorX = cursorX
            jiggle.animationCursorY = cursorY
            
            
            // Convert scale (fake x value) into
            // a real scale, assign it back to jiggle.
            cursorScaleSamplerX = cursorXScale
            if cursorScaleSamplerX != 0.0 {
                if cursorScaleSamplerX > 0.0 {
                    let percent = cursorScaleSamplerX / distanceR2
                    let climb = Jiggle.animationCursorFalloffScale_U2 - 1.0
                    jiggle.animationCursorScale = 1.0 + percent * climb
                } else {
                    let percent = -(cursorScaleSamplerX / distanceR2)
                    let climb = 1.0 - Jiggle.animationCursorFalloffScale_D2
                    jiggle.animationCursorScale = 1.0 - percent * climb
                }
            } else {
                jiggle.animationCursorScale = 1.0
            }
            
            // Convert rotation (fake x value) into
            // a real rotation, assign it back to jiggle.
            cursorRotationSamplerX = cursorXRotation
            if cursorRotationSamplerX != 0.0 {
                if cursorRotationSamplerX > 0.0 {
                    let percent = cursorRotationSamplerX / distanceR2
                    let climb = Jiggle.animationCursorFalloffRotation_U2
                    jiggle.animationCursorRotation = percent * climb
                } else {
                    let percent = cursorRotationSamplerX / distanceR2
                    let climb = Jiggle.animationCursorFalloffRotation_D2
                    jiggle.animationCursorRotation = -percent * climb
                }
            } else {
                jiggle.animationCursorRotation = 0.0
            }
            
        } else {
            
            // Here the user is holding the jiggle,
            // so all the speeds and stuff reset.
            // The elastic flangers also reset.
            
            cursorSpeedX = Float(0.0)
            cursorSpeedY = Float(0.0)
            cursorScaleSamplerSpeedX = Float(0.0)
            cursorRotationSamplerSpeedX = Float(0.0)
            cursorElastic = Float(0.0)
            cursorElasticScaleAndRotation = Float(0.0)
        }
        
        // Now we're measuring how long we spend
        // at the extreme side of the allowed-motion
        // range. Once we stay "at the edge" for long
        // enough, we will disable "fling"
        //
        // Without this, there can be a weird stutter.
        //
        var distance_R1_Adjusted = Float(0.0)
        var distance_R2_Adjusted = Float(0.0)
        Jiggle.getAnimationCursorFalloffDistance_Radii(measuredSize: jiggle.measuredSize,
                                                       userGrabDragPower: jiggle.grabDragPower,
                                                       distance_R1: &distance_R1_Adjusted,
                                                       distance_R2: &distance_R2_Adjusted)
        let flingHangDistance = distance_R2_Adjusted * 0.975
        let diffX = jiggle.animationCursorX
        let diffY = jiggle.animationCursorY
        let distanceSquared = diffX * diffX + diffY * diffY
        let distance: Float
        if distanceSquared > Math.epsilon {
            distance = sqrtf(distanceSquared)
        } else {
            distance = 0.0
        }
        if distance > flingHangDistance {
            flingHangTime += deltaTime
        } else {
            flingHangTime = 0.0
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    // We don't do anything with the gyro
    // until a few updates have passed and
    // a couple seconds have passed. Without
    // this, we accumulate noise and have
    // a bizarre start. This seems fine.
    private func update_Snooze(deltaTime: Float) -> Bool {
        if snoozeTime < Self.snoozeTimeLimit {
            snoozeTime += deltaTime
            return false
        } else {
            if snoozeTick < Self.snoozeTickLimit {
                snoozeTick += 1
                return false
            } else {
                return true
            }
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    func fling(jiggle: Jiggle,
               releaseAnimationTouches: [AnimationTouch],
               releaseAnimationTouchCount: Int) {
        
        // We get the release data from each touch.
        var releases = [ReleaseData]()
        for animationTouchIndex in 0..<releaseAnimationTouchCount {
            let animationTouch = releaseAnimationTouches[animationTouchIndex]
            if animationTouch.isExpired == false {
                let release = animationTouch.release()
                if release.isValid {
                    releases.append(release)
                }
            }
        }
        
        // We sum up the amount of
        // time that each fling
        // has... These are used
        // to weight the fling...
        var totalTime = Float(0.0)
        for release in releases {
            totalTime += release.time
        }
        
        if totalTime > Math.epsilon {
            
            // We just weight each fling
            // by the time it took. In most
            // cases, the times are all roughly
            // equal, but it's possible to do
            // some weird stuff with the screen.
            
            var powerX = Float(0.0)
            var powerY = Float(0.0)
            for release in releases {
                let timePercent = release.time / totalTime
                powerX += release.dirX * timePercent * release.magnitude
                powerY += release.dirY * timePercent * release.magnitude
            }
            
            fling(jiggle: jiggle,
                  powerX: powerX,
                  powerY: powerY)
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    // There is a potential alternative solution,
    // This is a very good fling, it's built
    // with a rigorous 15-minute-long session
    // of recorded touches and lots of inspecting
    // of the numbers, tweaking, etc.
    //
    // This is pretty simply, it relies mainly on
    // the pre-computed "getFlingMultiplier" results!
    //
    func fling(jiggle: Jiggle,
               powerX: Float,
               powerY: Float) {
        
        if flingHangTime > Self.flingHangTimeLimit {
            
            // Say we drag to the far right and our finger keeps going.
            // The jiggle was "stuck" at the far right, and accumulated
            // more touch history. Then we release. This will cancel out
            // that momentum...
            
            // There is a whole alternative idea that the fling could be
            // done with the recorded position from the jiggle's animation
            // cursor itself... Then we would not need this...
            
            // This methodology will work better for a "flick" or
            // a quick tug, so I think it's fine to keep.
            
            // Admittedly, I haven't really explored the alternative.
            
            return
        }
        
        // size of the jiggle
        let measuredSize = jiggle.measuredSize
        let measurePercentLinear = Jiggle.getMeasurePercentLinear(measuredSize: measuredSize)
        
        // value from the slider
        let grabDragSpeedPercentLinear = Jiggle.getGrabDragSpeedPercentLinear(userGrabDragSpeed: jiggle.grabSpeed)
        
        // our "cap" radius
        let distanceR2 = Jiggle.getAnimationCursorFalloffDistance_R2(measurePercentLinear: measurePercentLinear)
        
        let magnitudeSquared = powerX * powerX + powerY * powerY
        if magnitudeSquared > Math.epsilon {
            
            // we "fling" the speed by the vector,
            // and cap off the value. otherwise
            // at the extreme end, it can cause
            // very bizarre behaviors.
            
            let flingMultiplier = getFlingMultiplier(grabDragSpeedPercent: grabDragSpeedPercentLinear,
                                                     measuredSize: measurePercentLinear)
            
            var magnitude = sqrtf(magnitudeSquared)
            let dirX = powerX / magnitude
            let dirY = powerY / magnitude
            
            let magnitudeCeiling = distanceR2 * 0.66
            if magnitude > magnitudeCeiling {
                magnitude = magnitudeCeiling
            }
            
            cursorSpeedX = dirX * magnitude * flingMultiplier
            cursorSpeedY = dirY * magnitude * flingMultiplier
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    // We're converting our mesurements from recorded
    // sessions back into "how much from percent A to
    // percent B are we?" and re-applying the same.
    func getGyroMultiplier(grabDragSpeedPercent: Float,
                           measuredSize: Float) -> Float {
        let gyroMultiplierLarge: Float
        let gyroMultiplierMedium: Float
        let gyroMultiplierSmall: Float
        if Device.isPhone {
            gyroMultiplierLarge = Math.interpolate5(inputMin: 0.0,
                                                    inputMid1: 0.25,
                                                    inputMid2: 0.5,
                                                    inputMid3: 0.75,
                                                    inputMax: 1.0,
                                                    input: grabDragSpeedPercent,
                                                    outputMin: Self.gyroLargePhone_000,
                                                    outputMid1: Self.gyroLargePhone_025,
                                                    outputMid2: Self.gyroLargePhone_050,
                                                    outputMid3: Self.gyroLargePhone_075,
                                                    outputMax: Self.gyroLargePhone_100)
            gyroMultiplierMedium = Math.interpolate5(inputMin: 0.0,
                                                     inputMid1: 0.25,
                                                     inputMid2: 0.5,
                                                     inputMid3: 0.75,
                                                     inputMax: 1.0,
                                                     input: grabDragSpeedPercent,
                                                     outputMin: Self.gyroMediumPhone_000,
                                                     outputMid1: Self.gyroMediumPhone_025,
                                                     outputMid2: Self.gyroMediumPhone_050,
                                                     outputMid3: Self.gyroMediumPhone_075,
                                                     outputMax: Self.gyroMediumPhone_100)
            gyroMultiplierSmall = Math.interpolate5(inputMin: 0.0,
                                                    inputMid1: 0.25,
                                                    inputMid2: 0.5,
                                                    inputMid3: 0.75,
                                                    inputMax: 1.0,
                                                    input: grabDragSpeedPercent,
                                                    outputMin: Self.gyroSmallPhone_000,
                                                    outputMid1: Self.gyroSmallPhone_025,
                                                    outputMid2: Self.gyroSmallPhone_050,
                                                    outputMid3: Self.gyroSmallPhone_075,
                                                    outputMax: Self.gyroSmallPhone_100)
        } else {
            gyroMultiplierLarge = Math.interpolate5(inputMin: 0.0,
                                                    inputMid1: 0.25,
                                                    inputMid2: 0.5,
                                                    inputMid3: 0.75,
                                                    inputMax: 1.0,
                                                    input: grabDragSpeedPercent,
                                                    outputMin: Self.gyroLargePad_000,
                                                    outputMid1: Self.gyroLargePad_025,
                                                    outputMid2: Self.gyroLargePad_050,
                                                    outputMid3: Self.gyroLargePad_075,
                                                    outputMax: Self.gyroLargePad_100)
            gyroMultiplierMedium = Math.interpolate5(inputMin: 0.0,
                                                     inputMid1: 0.25,
                                                     inputMid2: 0.5,
                                                     inputMid3: 0.75,
                                                     inputMax: 1.0,
                                                     input: grabDragSpeedPercent,
                                                     outputMin: Self.gyroMediumPad_000,
                                                     outputMid1: Self.gyroMediumPad_025,
                                                     outputMid2: Self.gyroMediumPad_050,
                                                     outputMid3: Self.gyroMediumPad_075,
                                                     outputMax: Self.gyroMediumPad_100)
            gyroMultiplierSmall = Math.interpolate5(inputMin: 0.0,
                                                    inputMid1: 0.25,
                                                    inputMid2: 0.5,
                                                    inputMid3: 0.75,
                                                    inputMax: 1.0,
                                                    input: grabDragSpeedPercent,
                                                    outputMin: Self.gyroSmallPad_000,
                                                    outputMid1: Self.gyroSmallPad_025,
                                                    outputMid2: Self.gyroSmallPad_050,
                                                    outputMid3: Self.gyroSmallPad_075,
                                                    outputMax: Self.gyroSmallPad_100)
        }
        
        let gyroMultiplier = Math.interpolate3(inputMin: Jiggle.minMeasuredSize,
                                               inputMid: Jiggle.midMeasuredSize,
                                               inputMax: Jiggle.maxMeasuredSize,
                                               input: measuredSize,
                                               outputMin: gyroMultiplierSmall,
                                               outputMid: gyroMultiplierMedium,
                                               outputMax: gyroMultiplierLarge)
        return gyroMultiplier
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    // We're converting our mesurements from recorded
    // sessions back into "how much from percent A to
    // percent B are we?" and re-applying the same.
    func getFlingMultiplier(grabDragSpeedPercent: Float,
                            measuredSize: Float) -> Float {
        let flingMultiplierLarge: Float
        let flingMultiplierMedium: Float
        let flingMultiplierSmall: Float
        if Device.isPhone {
            flingMultiplierLarge = Math.interpolate5(inputMin: 0.0,
                                                     inputMid1: 0.25,
                                                     inputMid2: 0.5,
                                                     inputMid3: 0.75,
                                                     inputMax: 1.0,
                                                     input: grabDragSpeedPercent,
                                                     outputMin: Self.flingLargePhone_000,
                                                     outputMid1: Self.flingLargePhone_025,
                                                     outputMid2: Self.flingLargePhone_050,
                                                     outputMid3: Self.flingLargePhone_075,
                                                     outputMax: Self.flingLargePhone_100)
            flingMultiplierMedium = Math.interpolate5(inputMin: 0.0,
                                                      inputMid1: 0.25,
                                                      inputMid2: 0.5,
                                                      inputMid3: 0.75,
                                                      inputMax: 1.0,
                                                      input: grabDragSpeedPercent,
                                                      outputMin: Self.flingMediumPhone_000,
                                                      outputMid1: Self.flingMediumPhone_025,
                                                      outputMid2: Self.flingMediumPhone_050,
                                                      outputMid3: Self.flingMediumPhone_075,
                                                      outputMax: Self.flingMediumPhone_100)
            flingMultiplierSmall = Math.interpolate5(inputMin: 0.0,
                                                     inputMid1: 0.25,
                                                     inputMid2: 0.5,
                                                     inputMid3: 0.75,
                                                     inputMax: 1.0,
                                                     input: grabDragSpeedPercent,
                                                     outputMin: Self.flingSmallPhone_000,
                                                     outputMid1: Self.flingSmallPhone_025,
                                                     outputMid2: Self.flingSmallPhone_050,
                                                     outputMid3: Self.flingSmallPhone_075,
                                                     outputMax: Self.flingSmallPhone_100)
        } else {
            flingMultiplierLarge = Math.interpolate5(inputMin: 0.0,
                                                     inputMid1: 0.25,
                                                     inputMid2: 0.5,
                                                     inputMid3: 0.75,
                                                     inputMax: 1.0,
                                                     input: grabDragSpeedPercent,
                                                     outputMin: Self.flingLargePad_000,
                                                     outputMid1: Self.flingLargePad_025,
                                                     outputMid2: Self.flingLargePad_050,
                                                     outputMid3: Self.flingLargePad_075,
                                                     outputMax: Self.flingLargePad_100)
            flingMultiplierMedium = Math.interpolate5(inputMin: 0.0,
                                                      inputMid1: 0.25,
                                                      inputMid2: 0.5,
                                                      inputMid3: 0.75,
                                                      inputMax: 1.0,
                                                      input: grabDragSpeedPercent,
                                                      outputMin: Self.flingMediumPad_000,
                                                      outputMid1: Self.flingMediumPad_025,
                                                      outputMid2: Self.flingMediumPad_050,
                                                      outputMid3: Self.flingMediumPad_075,
                                                      outputMax: Self.flingMediumPad_100)
            flingMultiplierSmall = Math.interpolate5(inputMin: 0.0,
                                                     inputMid1: 0.25,
                                                     inputMid2: 0.5,
                                                     inputMid3: 0.75,
                                                     inputMax: 1.0,
                                                     input: grabDragSpeedPercent,
                                                     outputMin: Self.flingSmallPad_000,
                                                     outputMid1: Self.flingSmallPad_025,
                                                     outputMid2: Self.flingSmallPad_050,
                                                     outputMid3: Self.flingSmallPad_075,
                                                     outputMax: Self.flingSmallPad_100)
        }
        
        let flingMultiplier = Math.interpolate3(inputMin: Jiggle.minMeasuredSize,
                                                inputMid: Jiggle.midMeasuredSize,
                                                inputMax: Jiggle.maxMeasuredSize,
                                                input: measuredSize,
                                                outputMin: flingMultiplierSmall,
                                                outputMid: flingMultiplierMedium,
                                                outputMax: flingMultiplierLarge)
        return flingMultiplier
        
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    // We convert a scale into an equivalent x position
    // based on percentages within the acceptable range.
    func registerCursorScale(jiggle: Jiggle, scale: Float) {
        let measuredSize = jiggle.measuredSize
        let measurePercentLinear = Jiggle.getMeasurePercentLinear(measuredSize: measuredSize)
        let distanceR2 = Jiggle.getAnimationCursorFalloffDistance_R2(measurePercentLinear: measurePercentLinear)
        if scale >= 1.0 {
            let scalePercent = (scale - 1.0) / (Jiggle.animationCursorFalloffScale_U2 - 1.0)
            cursorScaleSamplerX = scalePercent * distanceR2
        } else {
            let scalePercent = (1.0 - scale) / (1.0 - Jiggle.animationCursorFalloffScale_D2)
            cursorScaleSamplerX = -(scalePercent * distanceR2)
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    // We convert a rotation into an equivalent x position
    // based on percentages within the acceptable range.
    func registerCursorRotation(jiggle: Jiggle, rotation: Float) {
        let measuredSize = jiggle.measuredSize
        let measurePercentLinear = Jiggle.getMeasurePercentLinear(measuredSize: measuredSize)
        let distanceR2 = Jiggle.getAnimationCursorFalloffDistance_R2(measurePercentLinear: measurePercentLinear)
        
        // We re-use this same logic in 2 or 3 places.
        var fixedRotation = fmodf(rotation, Math.pi2)
        if fixedRotation > Math.pi { fixedRotation -= Math.pi2 }
        if fixedRotation < Math._pi { fixedRotation += Math.pi2 }
        
        if fixedRotation >= 0.0 {
            let rotationPercent = (fixedRotation) / Jiggle.animationCursorFalloffRotation_U2
            cursorRotationSamplerX = rotationPercent * distanceR2
        } else {
            let rotationPercent = (fixedRotation) / Jiggle.animationCursorFalloffRotation_D2
            cursorRotationSamplerX = -(rotationPercent * distanceR2)
        }
    }
    
}
