//
//  AnimationController+Touches.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/19/24.
//

import UIKit

// [Animation Mode Verify] 12-19-2024
//
// I would say this is "empirically verified"
// I don't see any problem that happens.
// I don't see any obvious problems with
// the logic. It's a highly chaotic system.
//
extension AnimationController {
    
    // [Animation Mode Verify] 12-19-2024
    //
    // I've read through this, it's a little obtuse.
    // It seems to be working correctly, I would not
    // say that it is guaranteed bullet-proof......
    //
    @MainActor func touchesBegan(jiggleViewModel: JiggleViewModel,
                                 jiggleDocument: JiggleDocument,
                                 animationMode: AnimatonMode,
                                 touches: [UITouch],
                                 points: [Point],
                                 allTouchCount: Int,
                                 displayMode: DisplayMode,
                                 isGraphEnabled: Bool,
                                 touchTargetTouchSource: TouchTargetTouchSource,
                                 isPrecise: Bool) {
        
        // There was an issue with history getting
        // scrambled. We need to prevent touches while
        // any slider is active.
        if checkSliderActiveAndFlushIfNeeded(jiggleViewModel: jiggleViewModel,
                                             jiggleDocument: jiggleDocument,
                                             animationMode: animationMode) {
            return
        }
        
        // This is a user mode to disable "auto continuous"
        // essentially to just use the sliders and *NOT*
        // edit the animation by touching.........
        if checkContinuousDisabledAndFlushIfNeeded(jiggleViewModel: jiggleViewModel,
                                                   jiggleDocument: jiggleDocument,
                                                   animationMode: animationMode) {
            _ = jiggleDocument.attemptSelectJiggle(points: points,
                                                   includingFrozen: true,
                                                   nullifySelectionIfWhiff: false,
                                                   displayMode: displayMode,
                                                   isGraphEnabled: isGraphEnabled,
                                                   touchTargetTouchSource: touchTargetTouchSource,
                                                   isPrecise: isPrecise)
            return
        }
        
        snapshot_pre(jiggleViewModel: jiggleViewModel,
                     jiggleDocument: jiggleDocument,
                     animationMode: animationMode)
        
        // The touches began, so let's make sure no dupe:
        _flushAnimationTouches_TouchMatch(jiggleViewModel: jiggleViewModel,
                                          jiggleDocument: jiggleDocument,
                                          touches: touches)
        _flushPurgatoryAnimationTouches_TouchMatch(jiggleViewModel: jiggleViewModel,
                                                   jiggleDocument: jiggleDocument,
                                                   touches: touches)
        
        for touchIndex in 0..<touches.count {
            let touch = touches[touchIndex]
            let point = points[touchIndex]
            let animationTouch = AnimationPartsFactory.shared.withdrawAnimationTouch(touch: touch)
            animationTouch.x = point.x
            animationTouch.y = point.y
            animationTouchesAddUnique(animationTouch: animationTouch)
        }
        
        _linkAnimationTouches(jiggleViewModel: jiggleViewModel,
                              jiggleDocument: jiggleDocument,
                              animationMode: animationMode,
                              displayMode: displayMode,
                              isGraphEnabled: isGraphEnabled,
                              touchTargetTouchSource: touchTargetTouchSource,
                              isPrecise: isPrecise)
        
        recordHistoryForTouches(touches: touches)
        
        snapshot_post(jiggleViewModel: jiggleViewModel,
                      jiggleDocument: jiggleDocument,
                      animationMode: animationMode)
        
        switch animationMode {
        case .loops:
            _ = jiggleDocument.attemptSelectJiggle(points: points,
                                                   includingFrozen: true,
                                                   nullifySelectionIfWhiff: false,
                                                   displayMode: displayMode,
                                                   isGraphEnabled: isGraphEnabled,
                                                   touchTargetTouchSource: touchTargetTouchSource,
                                                   isPrecise: isPrecise)
        default:
            break
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    //
    // I've read through this, it's a little obtuse.
    // It seems to be working correctly, I would not
    // say that it is guaranteed bullet-proof......
    //
    @MainActor func touchesMoved(jiggleViewModel: JiggleViewModel,
                                 jiggleDocument: JiggleDocument,
                                 animationMode: AnimatonMode,
                                 touches: [UITouch],
                                 points: [Point],
                                 allTouchCount: Int,
                                 displayMode: DisplayMode,
                                 isGraphEnabled: Bool,
                                 touchTargetTouchSource: TouchTargetTouchSource,
                                 isPrecise: Bool) {
        
        // There was an issue with history getting
        // scrambled. We need to prevent touches while
        // any slider is active.
        if checkSliderActiveAndFlushIfNeeded(jiggleViewModel: jiggleViewModel,
                                             jiggleDocument: jiggleDocument,
                                             animationMode: animationMode) {
            return
        }
        
        // This is a user mode to disable "auto continuous"
        // essentially to just use the sliders and *NOT*
        // edit the animation by touching.........
        if checkContinuousDisabledAndFlushIfNeeded(jiggleViewModel: jiggleViewModel,
                                                   jiggleDocument: jiggleDocument,
                                                   animationMode: animationMode) {
            return
        }
        
        snapshot_pre(jiggleViewModel: jiggleViewModel,
                     jiggleDocument: jiggleDocument,
                     animationMode: animationMode)
        
        for touchIndex in 0..<touches.count {
            let touch = touches[touchIndex]
            let point = points[touchIndex]
            for animationTouchIndex in 0..<animationTouchCount {
                let animationTouch = animationTouches[animationTouchIndex]
                if animationTouch.touchID == ObjectIdentifier(touch) {
                    if (animationTouch.x != point.x) || (animationTouch.y != point.y) {
                        animationTouch.x = point.x
                        animationTouch.y = point.y
                        animationTouch.stationaryTime = 0.0
                    }
                }
            }
        }
        
        _linkAnimationTouches(jiggleViewModel: jiggleViewModel,
                              jiggleDocument: jiggleDocument,
                              animationMode: animationMode,
                              displayMode: displayMode,
                              isGraphEnabled: isGraphEnabled,
                              touchTargetTouchSource: touchTargetTouchSource,
                              isPrecise: isPrecise)
        
        recordHistoryForTouches(touches: touches)
        
        snapshot_post(jiggleViewModel: jiggleViewModel,
                      jiggleDocument: jiggleDocument,
                      animationMode: animationMode)
        
    }
    
    // [Animation Mode Verify] 12-19-2024
    //
    // I've read through this, it's a little obtuse.
    // It seems to be working correctly, I would not
    // say that it is guaranteed bullet-proof......
    //
    @MainActor func touchesEnded(jiggleViewModel: JiggleViewModel,
                                 jiggleDocument: JiggleDocument,
                                 animationMode: AnimatonMode,
                                 touches: [UITouch],
                                 points: [Point],
                                 allTouchCount: Int,
                                 displayMode: DisplayMode,
                                 isGraphEnabled: Bool) {
        
        // There was an issue with history getting
        // scrambled. We need to prevent touches while
        // any slider is active.
        if checkSliderActiveAndFlushIfNeeded(jiggleViewModel: jiggleViewModel,
                                             jiggleDocument: jiggleDocument,
                                             animationMode: animationMode) {
            return
        }
        
        
        // This is a user mode to disable "auto continuous"
        // essentially to just use the sliders and *NOT*
        // edit the animation by touching.........
        if checkContinuousDisabledAndFlushIfNeeded(jiggleViewModel: jiggleViewModel,
                                                   jiggleDocument: jiggleDocument,
                                                   animationMode: animationMode) {
            return
        }
        
        snapshot_pre(jiggleViewModel: jiggleViewModel,
                     jiggleDocument: jiggleDocument,
                     animationMode: animationMode)
        
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
        
        snapshot_post(jiggleViewModel: jiggleViewModel,
                      jiggleDocument: jiggleDocument,
                      animationMode: animationMode)
        
    }
    
    // [Touch Routes Verify] 12-13-2024
    //
    // Seems correct; I don't see any possible improvement.
    //
    @MainActor func killDragAll(jiggleViewModel: JiggleViewModel,
                                jiggleDocument: JiggleDocument,
                                animationMode: AnimatonMode) {
        flushAll(jiggleViewModel: jiggleViewModel,
                 jiggleDocument: jiggleDocument,
                 animationMode: animationMode)
    }
    
    // [Animation Mode Verify] 12-19-2024
    //
    // This is pretty straight forward, it works
    // as expected. When the check box is checked,
    // we cannot interact with the scene except select.
    //
    @MainActor private func checkContinuousDisabledAndFlushIfNeeded(jiggleViewModel: JiggleViewModel,
                                                                    jiggleDocument: JiggleDocument,
                                                                    animationMode: AnimatonMode) -> Bool {
        if jiggleDocument.isContinuousDisableGrabEnabled {
            switch animationMode {
            case .unknown:
                return false
            case .grab:
                return false
            case .continuous:
                flushAll(jiggleViewModel: jiggleViewModel,
                         jiggleDocument: jiggleDocument,
                         animationMode: animationMode)
                return true
            case .loops:
                return false
            }
        }
        return false
    }
    
    // [Animation Mode Verify] 12-19-2024
    //
    // This seems to work. Really, it hinges on
    // the "isAnySliderActive" variable, which
    // has some potential for chaos.
    //
    @MainActor private func checkSliderActiveAndFlushIfNeeded(jiggleViewModel: JiggleViewModel,
                                                              jiggleDocument: JiggleDocument,
                                                              animationMode: AnimatonMode) -> Bool {
        if jiggleViewModel.isAnySliderActive {
            flushAll(jiggleViewModel: jiggleViewModel,
                     jiggleDocument: jiggleDocument,
                     animationMode: animationMode)
            return true
        }
        return false
    }
    
}
