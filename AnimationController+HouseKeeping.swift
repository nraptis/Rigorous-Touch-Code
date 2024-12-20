//
//  AnimationController+HouseKeeping.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/19/24.
//

import UIKit

// [Animation Mode Verify] 12-20-2024
// If somehow the same touch object ends up
// in the purgatory list and regular list,
// it will cause a crazy issue. I have not
// seen that happen and I was checking for it
// for about 2 weeks straight.
//
extension AnimationController {
    
    // [Animation Mode Verify] 12-20-2024
    // Looks good, no problem. I've read each line.
    // There is no safe-guard against the same
    // object being in regular list AND purgatory.
    // If you run into a rare bug later, this might
    // be a possible cause. *POSSIBLE BUG*
    func animationTouchesAddUnique(animationTouch: AnimationTouch) {
        
        for animationTouchIndex in 0..<animationTouchCount {
            if animationTouches[animationTouchIndex] === animationTouch {
                return
            }
        }
        
        while animationTouches.count <= animationTouchCount {
            animationTouches.append(animationTouch)
        }
        animationTouches[animationTouchCount] = animationTouch
        animationTouchCount += 1
    }
    
    // [Animation Mode Verify] 12-20-2024
    // Looks good, no problem. I've read each line.
    func animationTouchesContainsTouch(_ animationTouch: AnimationTouch) -> Bool {
        for animationTouchIndex in 0..<animationTouchCount {
            if animationTouches[animationTouchIndex] === animationTouch {
                return true
            }
        }
        return false
    }
    
    // [Animation Mode Verify] 12-20-2024
    // Looks good, no problem. I've read each line.
    func animationTouchesFind(touch: UITouch) -> AnimationTouch? {
        let touchObjectIdentifier = ObjectIdentifier(touch)
        return animationTouchesFind(touchID: touchObjectIdentifier)
    }
    
    // [Animation Mode Verify] 12-20-2024
    // Looks good, no problem. I've read each line.
    func animationTouchesFind(touchID: ObjectIdentifier) -> AnimationTouch? {
        for animationTouchIndex in 0..<animationTouchCount {
            if animationTouches[animationTouchIndex].touchID == touchID {
                return animationTouches[animationTouchIndex]
            }
        }
        return nil
    }
    
    // [Animation Mode Verify] 12-20-2024
    // Looks good, no problem. I've read each line.
    func animationTouchesCount(jiggle: Jiggle, format: AnimationTouchFormat) -> Int {
        var result = 0
        for animationTouchIndex in 0..<animationTouchCount {
            let animationTouch = animationTouches[animationTouchIndex]
            switch animationTouch.residency {
            case .unassigned:
                break
            case .jiggleContinuous(let residencyJiggle):
                if residencyJiggle === jiggle {
                    switch format {
                    case .grab:
                        break
                    case .continuous:
                        result += 1
                    }
                }
            case .jiggleGrab(let residencyJiggle):
                if residencyJiggle === jiggle {
                    switch format {
                    case .grab:
                        result += 1
                    case .continuous:
                        break
                    }
                }
            }
        }
        return result
    }
    
    // [Animation Mode Verify] 12-20-2024
    // Looks good, no problem. I've read each line.
    @MainActor func animationTouchesRemove(jiggleViewModel: JiggleViewModel,
                                           jiggleDocument: JiggleDocument,
                                           animationTouch: AnimationTouch) {
        var numberRemoved = 0
        var removeLoopIndex = 0
        while removeLoopIndex < animationTouchCount {
            if animationTouches[removeLoopIndex] === animationTouch {
                break
            } else {
                removeLoopIndex += 1
            }
        }
        while removeLoopIndex < animationTouchCount {
            if animationTouches[removeLoopIndex] === animationTouch {
                numberRemoved += 1
            } else {
                animationTouches[removeLoopIndex - numberRemoved] = animationTouches[removeLoopIndex]
            }
            removeLoopIndex += 1
        }
        animationTouchCount -= numberRemoved
        switch animationTouch.residency {
        case .jiggleGrab:
            purgatoryAnimationTouchesAddUnique(animationTouch)
        default:
            AnimationPartsFactory.shared.depositAnimationTouch(animationTouch)
        }
    }
    
    // [Animation Mode Verify] 12-20-2024
    // Looks good, no problem. I've read each line.
    // There is no safe-guard against the same
    // object being in regular list AND purgatory.
    // If you run into a rare bug later, this might
    // be a possible cause. *POSSIBLE BUG*
    func purgatoryAnimationTouchesAddUnique(_ animationTouch: AnimationTouch) {
        
        for animationTouchIndex in 0..<purgatoryAnimationTouchCount {
            if purgatoryAnimationTouches[animationTouchIndex] === animationTouch {
                return
            }
        }
        
        while purgatoryAnimationTouches.count <= purgatoryAnimationTouchCount {
            purgatoryAnimationTouches.append(animationTouch)
        }
        purgatoryAnimationTouches[purgatoryAnimationTouchCount] = animationTouch
        purgatoryAnimationTouchCount += 1
    }
    
    // [Animation Mode Verify] 12-20-2024
    // Looks good, no problem. I've read each line.
    func purgatoryAnimationTouchesContainsTouch(_ animationTouch: AnimationTouch) -> Bool {
        for animationTouchIndex in 0..<purgatoryAnimationTouchCount {
            if purgatoryAnimationTouches[animationTouchIndex] === animationTouch {
                return true
            }
        }
        return false
    }
    
    // [Animation Mode Verify] 12-20-2024
    // Looks good, no problem. I've read each line.
    func purgatoryAnimationTouchesFind(touch: UITouch) -> AnimationTouch? {
        let touchObjectIdentifier = ObjectIdentifier(touch)
        return purgatoryAnimationTouchesFind(touchID: touchObjectIdentifier)
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    func purgatoryAnimationTouchesFind(touchID: ObjectIdentifier) -> AnimationTouch? {
        for animationTouchIndex in 0..<purgatoryAnimationTouchCount {
            if purgatoryAnimationTouches[animationTouchIndex].touchID == touchID {
                return purgatoryAnimationTouches[animationTouchIndex]
            }
        }
        return nil
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    func purgatoryAnimationTouchesRemove(_ animationTouch: AnimationTouch) {
        var numberRemoved = 0
        var removeLoopIndex = 0
        while removeLoopIndex < purgatoryAnimationTouchCount {
            if purgatoryAnimationTouches[removeLoopIndex] === animationTouch {
                break
            } else {
                removeLoopIndex += 1
            }
        }
        while removeLoopIndex < purgatoryAnimationTouchCount {
            if purgatoryAnimationTouches[removeLoopIndex] === animationTouch {
                numberRemoved += 1
            } else {
                purgatoryAnimationTouches[removeLoopIndex - numberRemoved] = purgatoryAnimationTouches[removeLoopIndex]
            }
            removeLoopIndex += 1
        }
        purgatoryAnimationTouchCount -= numberRemoved
        AnimationPartsFactory.shared.depositAnimationTouch(animationTouch)
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    func tempAnimationTouchesAddUnique(_ animationTouch: AnimationTouch) {
        for animationTouchIndex in 0..<tempAnimationTouchCount {
            if tempAnimationTouches[animationTouchIndex] === animationTouch {
                return
            }
        }
        
        while tempAnimationTouches.count <= tempAnimationTouchCount {
            tempAnimationTouches.append(animationTouch)
        }
        tempAnimationTouches[tempAnimationTouchCount] = animationTouch
        tempAnimationTouchCount += 1
    }
    
    // [Animation Mode Verify] 12-19-2024
    // It's over-safe, I don't think there
    // can be duplicates here. Works fine tho...
    func releaseAnimationTouchesAddUnique(_ animationTouch: AnimationTouch) {
        
        for animationTouchIndex in 0..<releaseAnimationTouchCount {
            if releaseAnimationTouches[animationTouchIndex] === animationTouch {
                return
            }
        }
        
        while releaseAnimationTouches.count <= releaseAnimationTouchCount {
            releaseAnimationTouches.append(animationTouch)
        }
        releaseAnimationTouches[releaseAnimationTouchCount] = animationTouch
        releaseAnimationTouchCount += 1
    }
    
}
