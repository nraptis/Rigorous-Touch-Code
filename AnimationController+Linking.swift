//
//  AnimationController+Linking.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/19/24.
//

import Foundation

// [Animation Mode Verify] 12-19-2024
// Looks good, no problem. I've read each line.
//
// There is an important naming convention. If the
// linking function has a _ at the start of it's name,
// then it must be called in the following manner:
//
// 1.) snapshot_pre(...)
// 2.) the function itself.
// 3.) snapshot_post(...)
//
extension AnimationController {
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    @MainActor func _linkAnimationTouches(jiggleViewModel: JiggleViewModel,
                                          jiggleDocument: JiggleDocument,
                                          animationMode: AnimatonMode,
                                          displayMode: DisplayMode,
                                          isGraphEnabled: Bool,
                                          touchTargetTouchSource: TouchTargetTouchSource,
                                          isPrecise: Bool) {
        
        switch animationMode {
        case .unknown:
            // [Touch Routes Verify] 12-7-2024
            // We will never link a touch for "unknown" animation mode.
            break
        case .grab:
            // [Touch Routes Verify] 12-7-2024
            // In the case that we are in grab mode...
            
            // We loop through all the touches...
            for animationTouchIndex in 0..<animationTouchCount {
                let animationTouch = animationTouches[animationTouchIndex]
                
                // If the touch is unassigned, we
                // attempt to link it to "grab" mode...
                switch animationTouch.residency {
                case .unassigned:
                    _ = _attemptLinkingTouchToJiggle_Grab(animationTouch: animationTouch,
                                                          jiggleViewModel: jiggleViewModel,
                                                          jiggleDocument: jiggleDocument,
                                                          displayMode: displayMode,
                                                          isGraphEnabled: isGraphEnabled,
                                                          touchTargetTouchSource: touchTargetTouchSource,
                                                          isPrecise: isPrecise)
                default:
                    break
                }
            }
            
        case .continuous:
            // [Touch Routes Verify] 12-7-2024
            // In the case that we are in continuous mode...
            
            // We loop through all the touches...
            for animationTouchIndex in 0..<animationTouchCount {
                let animationTouch = animationTouches[animationTouchIndex]
                
                // If the touch is unassigned, we
                // attempt to link it to "continuous" mode...
                switch animationTouch.residency {
                case .unassigned:
                    _ = _attemptLinkingTouchToJiggle_Continuous(animationTouch: animationTouch,
                                                                jiggleViewModel: jiggleViewModel,
                                                                jiggleDocument: jiggleDocument,
                                                                displayMode: displayMode,
                                                                isGraphEnabled: isGraphEnabled,
                                                                touchTargetTouchSource: touchTargetTouchSource,
                                                                isPrecise: isPrecise)
                    
                default:
                    break
                }
            }
        case .loops:
            // [Touch Routes Verify] 12-7-2024
            // We will never link a touch for "loops" animation mode.
            break
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    // There is a risk that this would need to be
    // revisited after "getIndexOfJiggleToSelect"
    // is changed. We have a plan to change that.
    @MainActor private func _attemptLinkingTouchToJiggle_Grab(animationTouch: AnimationTouch,
                                                              jiggleViewModel: JiggleViewModel,
                                                              jiggleDocument: JiggleDocument,
                                                              displayMode: DisplayMode,
                                                              isGraphEnabled: Bool,
                                                              touchTargetTouchSource: TouchTargetTouchSource,
                                                              isPrecise: Bool) -> Bool {
        
        if let indexOfJiggleToSelect = jiggleDocument.getIndexOfJiggleToSelect(points: [animationTouch.point],
                                                                               includingFrozen: true,
                                                                               touchTargetTouchSource: touchTargetTouchSource) {
            if let jiggle = jiggleDocument.getJiggle(indexOfJiggleToSelect) {
                animationTouch.linkToResidency(residency: .jiggleGrab(jiggle))
                jiggleDocument.switchSelectedJiggle(newSelectedJiggleIndex: indexOfJiggleToSelect,
                                                    displayMode: displayMode,
                                                    isGraphEnabled: isGraphEnabled,
                                                    isPrecise: isPrecise)
                return true
            }
        }
        return false
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    // There is a risk that this would need to be
    // revisited after "getIndexOfJiggleToSelect"
    // is changed. We have a plan to change that.
    @MainActor private func _attemptLinkingTouchToJiggle_Continuous(animationTouch: AnimationTouch,
                                                                    jiggleViewModel: JiggleViewModel,
                                                                    jiggleDocument: JiggleDocument,
                                                                    displayMode: DisplayMode,
                                                                    isGraphEnabled: Bool,
                                                                    touchTargetTouchSource: TouchTargetTouchSource,
                                                                    isPrecise: Bool) -> Bool {
        if let indexOfJiggleToSelect = jiggleDocument.getIndexOfJiggleToSelect(points: [animationTouch.point],
                                                                               includingFrozen: true,
                                                                               touchTargetTouchSource: touchTargetTouchSource) {
            if let jiggle = jiggleDocument.getJiggle(indexOfJiggleToSelect) {
                animationTouch.linkToResidency(residency: .jiggleContinuous(jiggle))
                jiggleDocument.switchSelectedJiggle(newSelectedJiggleIndex: indexOfJiggleToSelect,
                                                    displayMode: displayMode,
                                                    isGraphEnabled: isGraphEnabled,
                                                    isPrecise: isPrecise)
                return true
            }
        }
        return false
    }
    
}
