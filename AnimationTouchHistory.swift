//
//  AnimationTouchHistory.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/7/24.
//

import Foundation

// [Animation Mode Verify] 12-19-2024
// Looks good, no problem. We are using everything
// on this class, it's all working to specification.
//
class AnimationTouchHistory {
    
    static let expireTime = Float(0.075)
    private static let historySize = 9
    var historyCount: Int = 0
    
    var historyX = [Float]()
    var historyY = [Float]()
    var historyTime = [Float]()
    var historyExpired = [Bool]()
    var historyDiffX = [Float]()
    var historyDiffY = [Float]()
    var historyDiffMagnitude = [Float]()
    var historyDiffTime = [Float]()
    
    init() {
        for _ in 0..<AnimationTouchHistory.historySize {
            historyX.append(0.0)
            historyY.append(0.0)
            historyTime.append(0.0)
            historyExpired.append(false)
            historyDiffX.append(0.0)
            historyDiffY.append(0.0)
            historyDiffMagnitude.append(0.0)
            historyDiffTime.append(0.0)
        }
    }
    
    // [Animation Mode Verify] 12-18-2024
    //
    // This is fine; we are expiring the
    // history states once they go stale.
    //
    func update(deltaTime: Float, clock: Float) {
        let historyExpireClock = clock - AnimationTouchHistory.expireTime
        for historyIndex in 0..<historyCount {
            if historyTime[historyIndex] < historyExpireClock {
                historyExpired[historyIndex] = true
            }
        }
    }
    
    // [Deep Dive] 12-7-2024
    //             Developer notes: This seems good.
    //             We waste a little bit of time copying expired
    //             touches, could stop after the first expired touch.
    //             Since there are less than 10,000, it should hardly matter.
    func recordHistory(clock: Float,
                                x: Float,
                                y: Float) {
        if historyCount < AnimationTouchHistory.historySize {
            historyX[historyCount] = x
            historyY[historyCount] = y
            historyTime[historyCount] = clock
            historyExpired[historyCount] = false
            historyCount += 1
        } else {
            for i in 1..<AnimationTouchHistory.historySize {
                historyX[i - 1] = historyX[i]
                historyY[i - 1] = historyY[i]
                historyTime[i - 1] = historyTime[i]
                historyExpired[i - 1] = historyExpired[i]
            }
            historyX[AnimationTouchHistory.historySize - 1] = x
            historyY[AnimationTouchHistory.historySize - 1] = y
            historyTime[AnimationTouchHistory.historySize - 1] = clock
            historyExpired[AnimationTouchHistory.historySize - 1] = false
        }
    }
    
    // [Deep Dive] 12-7-2024
    // [Re-Evaluation] 12-18-2024
    // This is great, no changes needed.
    // Keep in mind, the history size is 9.
    func release() -> ReleaseData {
        
        var isValid = false
        var time = Float(0.0)
        var dirX = Float(0.0)
        var dirY = Float(-1.0)
        var magnitude = Float(0.0)
        var diffCount = 0
        if (historyCount > 0) && (historyExpired[historyCount - 1] == false) {
            var seekIndex = historyCount - 1
            var previousTime = historyTime[seekIndex]
            var previousX = historyX[seekIndex]
            var previousY = historyY[seekIndex]
            seekIndex -= 1
            while (seekIndex >= 0) && (historyExpired[seekIndex] == false) {
                let currentTime = historyTime[seekIndex]
                let timeDifference = previousTime - currentTime
                if timeDifference > Math.epsilon {
                    let currentX = historyX[seekIndex]
                    let currentY = historyY[seekIndex]
                    var diffX = (previousX - currentX)
                    var diffY = (previousY - currentY)
                    let distanceSquared = diffX * diffX + diffY * diffY
                    if distanceSquared > Math.epsilon {
                        let distance = sqrtf(distanceSquared)
                        diffX /= distance
                        diffY /= distance
                        historyDiffX[diffCount] = diffX
                        historyDiffY[diffCount] = diffY
                        historyDiffTime[diffCount] = timeDifference
                        historyDiffMagnitude[diffCount] = distance
                        diffCount += 1
                        previousTime = currentTime
                        previousX = currentX
                        previousY = currentY
                    }
                }
                seekIndex -= 1
            }
        }
        
        if diffCount > 0 {
            var totalTime = Float(0.0)
            for diffIndex in 0..<diffCount {
                totalTime += historyDiffTime[diffIndex]
            }
            if totalTime > Math.epsilon {
                time = totalTime
                for diffIndex in 0..<diffCount {
                    let timePercent = historyDiffTime[diffIndex] / totalTime
                    dirX += historyDiffX[diffIndex] * timePercent * historyDiffMagnitude[diffIndex]
                    dirY += historyDiffY[diffIndex] * timePercent * historyDiffMagnitude[diffIndex]
                }
                
                let magnitudeSquared = dirX * dirX + dirY * dirY
                if magnitudeSquared > Math.epsilon {
                    magnitude = sqrtf(magnitudeSquared)
                    dirX /= magnitude
                    dirY /= magnitude
                    isValid = true
                }
            }
        }
        
        return ReleaseData(isValid: isValid,
                           time: time,
                           dirX: dirX,
                           dirY: dirY,
                           magnitude: magnitude)
    }
}
