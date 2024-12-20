//
//  AnimationController+Flush.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/11/24.
//

import UIKit

// [Animation Mode Verify] 12-18-2024
//
// There isn't any problem here. There is an
// important naming convention. If the fush
// function has a _ at the beginning, then it
// must be called in the following manner:
// 1.) snapshot_pre(...)
// 2.) the function itself.
// 3.) snapshot_post(...)
//
extension AnimationController {
    
    //
    // [Touch Routes Verify] 12-10-2024
    // This looks to be right, there's never
    // a need to keep the old "clock" value!!
    //
    @MainActor func flushAll(jiggleViewModel: JiggleViewModel,
                             jiggleDocument: JiggleDocument,
                             animationMode: AnimatonMode) {
        snapshot_pre(jiggleViewModel: jiggleViewModel,
                     jiggleDocument: jiggleDocument,
                     animationMode: animationMode)
        _flushPurgatoryAnimationTouches_All(jiggleViewModel: jiggleViewModel,
                                            jiggleDocument: jiggleDocument)
        _flushAnimationTouches_All(jiggleViewModel: jiggleViewModel,
                                   jiggleDocument: jiggleDocument)
        snapshot_post(jiggleViewModel: jiggleViewModel,
                      jiggleDocument: jiggleDocument,
                      animationMode: animationMode)
        clock = 0.0
    }
    
    //
    // [Touch Routes Verify] 12-11-2024
    // This looks to be right, there's never
    // a need to keep the old "clock" value!!
    //
    @MainActor func flushAllExpired(jiggleViewModel: JiggleViewModel,
                                    jiggleDocument: JiggleDocument,
                                    animationMode: AnimatonMode) {
        
        var isAnyTouchExpired = false
        for animationTouchIndex in 0..<animationTouchCount {
            let animationTouch = animationTouches[animationTouchIndex]
            if animationTouch.isExpired {
                isAnyTouchExpired = true
            }
        }
        for animationTouchIndex in 0..<purgatoryAnimationTouchCount {
            let animationTouch = purgatoryAnimationTouches[animationTouchIndex]
            if animationTouch.isExpired {
                isAnyTouchExpired = true
            }
        }
        
        if isAnyTouchExpired {
            snapshot_pre(jiggleViewModel: jiggleViewModel,
                         jiggleDocument: jiggleDocument,
                         animationMode: animationMode)
            _flushAnimationTouches_Expired(jiggleViewModel: jiggleViewModel,
                                           jiggleDocument: jiggleDocument)
            _flushPurgatoryAnimationTouches_Expired(jiggleViewModel: jiggleViewModel,
                                                    jiggleDocument: jiggleDocument)
            snapshot_post(jiggleViewModel: jiggleViewModel,
                          jiggleDocument: jiggleDocument,
                          animationMode: animationMode)
        }
    }
    
    // [Touch Routes Verify] 12-9-2024
    // This looks to be right, no change needed.
    //
    @MainActor func _flushAnimationTouches_All(jiggleViewModel: JiggleViewModel,
                                               jiggleDocument: JiggleDocument) {
        
        tempAnimationTouchCount = 0
        for animationTouchIndex in 0..<animationTouchCount {
            let animationTouch = animationTouches[animationTouchIndex]
            tempAnimationTouchesAddUnique(animationTouch)
        }
        
        for animationTouchIndex in 0..<tempAnimationTouchCount {
            let animationTouch = tempAnimationTouches[animationTouchIndex]
            animationTouchesRemove(jiggleViewModel: jiggleViewModel,
                                   jiggleDocument: jiggleDocument,
                                   animationTouch: animationTouch)
        }
    }
    
    // [Touch Routes Verify] 12-9-2024
    // This looks to be right, no change needed.
    //
    // Usage note: This *MUST* be called in the following manner:
    // 1.) snapshot_pre(...)
    // 2.) *THIS*
    // 3.) snapshot_post(...)
    //
    func _flushPurgatoryAnimationTouches_All(jiggleViewModel: JiggleViewModel,
                                             jiggleDocument: JiggleDocument) {
        tempAnimationTouchCount = 0
        for animationTouchIndex in 0..<purgatoryAnimationTouchCount {
            let animationTouch = purgatoryAnimationTouches[animationTouchIndex]
            tempAnimationTouchesAddUnique(animationTouch)
        }
        
        for animationTouchIndex in 0..<tempAnimationTouchCount {
            let animationTouch = tempAnimationTouches[animationTouchIndex]
            //_ =
            purgatoryAnimationTouchesRemove(animationTouch)
        }
    }
    
    // [Touch Routes Verify] 12-9-2024
    // This looks to be right, no change needed.
    //
    // Usage note: This *MUST* be called in the following manner:
    // 1.) snapshot_pre(...)
    // 2.) *THIS*
    // 3.) snapshot_post(...)
    //
    @MainActor func _flushAnimationTouches_Expired(jiggleViewModel: JiggleViewModel,
                                                   jiggleDocument: JiggleDocument) {
        tempAnimationTouchCount = 0
        for animationTouchIndex in 0..<animationTouchCount {
            let animationTouch = animationTouches[animationTouchIndex]
            if animationTouch.isExpired {
                tempAnimationTouchesAddUnique(animationTouch)
            }
            
        }
        
        for animationTouchIndex in 0..<tempAnimationTouchCount {
            let animationTouch = tempAnimationTouches[animationTouchIndex]
            animationTouchesRemove(jiggleViewModel: jiggleViewModel,
                                   jiggleDocument: jiggleDocument,
                                   animationTouch: animationTouch)
        }
    }
    
    // [Touch Routes Verify] 12-9-2024
    // This looks to be right, no change needed.
    //
    // Usage note: This *MUST* be called in the following manner:
    // 1.) snapshot_pre(...)
    // 2.) *THIS*
    // 3.) snapshot_post(...)
    //
    func _flushPurgatoryAnimationTouches_Expired(jiggleViewModel: JiggleViewModel,
                                                 jiggleDocument: JiggleDocument) {
        
        tempAnimationTouchCount = 0
        for animationTouchIndex in 0..<purgatoryAnimationTouchCount {
            let animationTouch = purgatoryAnimationTouches[animationTouchIndex]
            if animationTouch.isExpired {
                tempAnimationTouchesAddUnique(animationTouch)
            }
        }
        
        
        for animationTouchIndex in 0..<tempAnimationTouchCount {
            let animationTouch = tempAnimationTouches[animationTouchIndex]
            //_ =
            purgatoryAnimationTouchesRemove(animationTouch)
        }
        
    }
    
    // [Touch Routes Verify] 12-11-2024
    // This looks to be right, no change needed.
    //
    // Usage note: This *MUST* be called in the following manner:
    // 1.) snapshot_pre(...)
    // 2.) *THIS*
    // 3.) snapshot_post(...)
    @MainActor func _flushAnimationTouches_TouchMatch(jiggleViewModel: JiggleViewModel,
                                                      jiggleDocument: JiggleDocument,
                                                      touches: [UITouch]) {
        
        tempAnimationTouchCount = 0
        for touchIndex in 0..<touches.count {
            let touch = touches[touchIndex]
            if let animationTouch = animationTouchesFind(touch: touch) {
                tempAnimationTouchesAddUnique(animationTouch)
            }
        }
        
        for animationTouchIndex in 0..<tempAnimationTouchCount {
            let animationTouch = tempAnimationTouches[animationTouchIndex]
            animationTouchesRemove(jiggleViewModel: jiggleViewModel,
                                   jiggleDocument: jiggleDocument,
                                   animationTouch: animationTouch)
        }
    }
    
    // [Touch Routes Verify] 12-10-2024
    // This looks to be right, just note the comment.
    //
    @MainActor func _flushPurgatoryAnimationTouches_TouchMatch(jiggleViewModel: JiggleViewModel,
                                                               jiggleDocument: JiggleDocument,
                                                               touches: [UITouch]) {
        
        tempAnimationTouchCount = 0
        for touchIndex in 0..<touches.count {
            let touch = touches[touchIndex]
            if let animationTouch = purgatoryAnimationTouchesFind(touch: touch) {
                tempAnimationTouchesAddUnique(animationTouch)
            }
        }
        
        for animationTouchIndex in 0..<tempAnimationTouchCount {
            let animationTouch = tempAnimationTouches[animationTouchIndex]
            //_ =
            purgatoryAnimationTouchesRemove(animationTouch)
        }
    }
    
    
    // [Touch Routes Verify] 12-9-2024
    // This looks to be right, however, please
    // note. It hinges on "matchesMode" from residency...
    // So, we're assuming that is exactly right!!!
    //
    @MainActor func _flushAnimationTouches_ModeMismatch(jiggleViewModel: JiggleViewModel,
                                                        jiggleDocument: JiggleDocument,
                                                        animationMode: AnimatonMode) {
        tempAnimationTouchCount = 0
        for animationTouchIndex in 0..<animationTouchCount {
            let animationTouch = animationTouches[animationTouchIndex]
            if !animationTouch.residency.matchesMode(animationMode: animationMode,
                                                     includingUnassigned: true) {
                tempAnimationTouchesAddUnique(animationTouch)
            }
        }
        
        for animationTouchIndex in 0..<tempAnimationTouchCount {
            let animationTouch = tempAnimationTouches[animationTouchIndex]
            animationTouchesRemove(jiggleViewModel: jiggleViewModel,
                                   jiggleDocument: jiggleDocument,
                                   animationTouch: animationTouch)
        }
    }
    
    // [Touch Routes Verify] 12-9-2024
    // This looks to be right, no change
    // should be needed, ever. Not ever.
    //
    @MainActor func _flushAnimationTouches_Orphaned(jiggleViewModel: JiggleViewModel,
                                                    jiggleDocument: JiggleDocument) {
        tempAnimationTouchCount = 0
        for animationTouchIndex in 0..<animationTouchCount {
            let animationTouch = animationTouches[animationTouchIndex]
            switch animationTouch.residency {
            case .unassigned:
                break
            case .jiggleContinuous(let jiggle):
                if jiggleDocument.getJiggleIndex(jiggle) == nil {
                    tempAnimationTouchesAddUnique(animationTouch)
                }
            case .jiggleGrab(let jiggle):
                if jiggleDocument.getJiggleIndex(jiggle) == nil {
                    tempAnimationTouchesAddUnique(animationTouch)
                }
            }
        }
        
        for animationTouchIndex in 0..<tempAnimationTouchCount {
            let animationTouch = tempAnimationTouches[animationTouchIndex]
            animationTouchesRemove(jiggleViewModel: jiggleViewModel,
                                   jiggleDocument: jiggleDocument,
                                   animationTouch: animationTouch)
        }
    }
    
}
