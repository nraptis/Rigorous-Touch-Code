//
//  AnimationController.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/7/24.
//

import UIKit

// [Animation Mode Verify] 12-20-2024
// Looks good, no problem. We are using everything
// in this protocol, it's all working to specification.
//
class AnimationController {
    
    typealias Point = Math.Point
    typealias Vector = Math.Vector
    
    // This list retains the touches.
    var animationTouches = [AnimationTouch]()
    var animationTouchCount = 0
    
    // This list retains the touches.
    var purgatoryAnimationTouches = [AnimationTouch]()
    var purgatoryAnimationTouchCount = 0
    
    // This list does not retain the touches.
    var tempAnimationTouchCount = 0
    var tempAnimationTouches = [AnimationTouch]()
    
    // This list does not retain the touches.
    var releaseAnimationTouches = [AnimationTouch]()
    var releaseAnimationTouchCount = 0
    
    var clock = Float(0.0)
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    @MainActor func update(deltaTime: Float,
                           jiggleViewModel: JiggleViewModel,
                           jiggleDocument: JiggleDocument,
                           isGyroEnabled: Bool,
                           animationMode: AnimatonMode) {
        
        clock += deltaTime
        
        for animationTouchIndex in 0..<purgatoryAnimationTouchCount {
            let animationTouch = purgatoryAnimationTouches[animationTouchIndex]
            animationTouch.update(deltaTime: deltaTime, clock: clock)
        }
        
        for animationTouchIndex in 0..<animationTouchCount {
            let animationTouch = animationTouches[animationTouchIndex]
            animationTouch.update(deltaTime: deltaTime, clock: clock)
        }
        
        flushAllExpired(jiggleViewModel: jiggleViewModel,
                        jiggleDocument: jiggleDocument,
                        animationMode: animationMode)
        
        // [Animation Mode Verify] 12-18-2024
        // This seems a little bit like rabbit hole
        // logic. The alternative is to do this
        // same loop on JiggleDocument immediately
        // after this update. I like this choice better.
        for jiggleIndex in 0..<jiggleDocument.jiggleCount {
            let jiggle = jiggleDocument.jiggles[jiggleIndex]
            jiggle.updateAnimationInstructions(deltaTime: deltaTime,
                                               jiggleViewModel: jiggleViewModel,
                                               jiggleDocument: jiggleDocument,
                                               controller: self,
                                               animationMode: animationMode,
                                               isGyroEnabled: isGyroEnabled,
                                               clock: clock)
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    // The function seems a little lonely, it's not
    // really grouped with any similar function.
    // I don't think it needs its own extension.
    func notifyJiggleUngrabbed_Grab(animationMode: AnimatonMode, jiggle: Jiggle) {
        
        // We copy all the "purgatory touches"
        // which are "grab" and "same jiggle"
        // into our "release touches," these
        // will be used to compute the "fling...!!!"
        releaseAnimationTouchCount = 0
        for animationTouchIndex in 0..<purgatoryAnimationTouchCount {
            let animationTouch = purgatoryAnimationTouches[animationTouchIndex]
            switch animationTouch.residency {
            case .unassigned:
                break
            case .jiggleContinuous:
                break
            case .jiggleGrab(let residencyJiggle):
                if residencyJiggle === jiggle {
                    releaseAnimationTouchesAddUnique(animationTouch)
                }
            }
        }
        
        // Execute the fling.
        jiggle.animationInstructionGrab.fling(jiggle: jiggle,
                                              releaseAnimationTouches: releaseAnimationTouches,
                                              releaseAnimationTouchCount: releaseAnimationTouchCount)
        
        // Then we can remove them from purgatory.
        // We have no further use for these touches.
        // We only kept them around for this very purpose.
        //
        for animationTouchIndex in 0..<releaseAnimationTouchCount {
            let animationTouch = releaseAnimationTouches[animationTouchIndex]
            purgatoryAnimationTouchesRemove(animationTouch)
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    //
    // We've explored both alternatives.
    // 1.) Only Recording history for a linked touch.
    // 2.) Recording history for all the touches.
    //
    func recordHistoryForTouches(touches: [UITouch]) {
        for touchIndex in 0..<touches.count {
            let touch = touches[touchIndex]
            if let animationTouch = animationTouchesFind(touch: touch) {
                animationTouch.recordHistory(clock: clock)
            }
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    // A good candidate for a better name...
    @MainActor func snapshot_pre(jiggleViewModel: JiggleViewModel,
                                 jiggleDocument: JiggleDocument,
                                 animationMode: AnimatonMode) {
        for jiggleIndex in 0..<jiggleDocument.jiggleCount {
            let jiggle = jiggleDocument.jiggles[jiggleIndex]
            jiggle.snapshotAnimationBefore(controller: self, animationMode: animationMode)
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    // A good candidate for a better name...
    @MainActor func snapshot_post(jiggleViewModel: JiggleViewModel,
                                  jiggleDocument: JiggleDocument,
                                  animationMode: AnimatonMode) {
        for jiggleIndex in 0..<jiggleDocument.jiggleCount {
            let jiggle = jiggleDocument.jiggles[jiggleIndex]
            jiggle.snapshotAnimationAfterThenReconcileAndPerform(controller: self,
                                                                 jiggleViewModel: jiggleViewModel,
                                                                 jiggleDocument: jiggleDocument,
                                                                 animationMode: animationMode)
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    // We need to flush the orphaned touches in-case
    // the same Jiggle is recycled. The user would have
    // to be clicking things very fast, lol, but it's possible.
    @MainActor func handleJigglesDidChange(jiggleViewModel: JiggleViewModel,
                                           jiggleDocument: JiggleDocument,
                                           animationMode: AnimatonMode) {
        snapshot_pre(jiggleViewModel: jiggleViewModel,
                     jiggleDocument: jiggleDocument,
                     animationMode: animationMode)
        _flushAnimationTouches_Orphaned(jiggleViewModel: jiggleViewModel,
                                        jiggleDocument: jiggleDocument)
        snapshot_post(jiggleViewModel: jiggleViewModel,
                      jiggleDocument: jiggleDocument,
                      animationMode: animationMode)
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    // "handleAnimationModeDidChange" does same
    // "handleDocumentModeDidChange" does same
    // "applicationWillResignActive" does same
    @MainActor func handleAnimationModeDidChange(jiggleViewModel: JiggleViewModel,
                                                 jiggleDocument: JiggleDocument,
                                                 animationMode: AnimatonMode) {
        flushAll(jiggleViewModel: jiggleViewModel,
                 jiggleDocument: jiggleDocument,
                 animationMode: animationMode)
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    // "handleAnimationModeDidChange" does same
    // "handleDocumentModeDidChange" does same
    // "applicationWillResignActive" does same
    @MainActor func handleDocumentModeDidChange(jiggleViewModel: JiggleViewModel,
                                                jiggleDocument: JiggleDocument,
                                                animationMode: AnimatonMode) {
        flushAll(jiggleViewModel: jiggleViewModel,
                 jiggleDocument: jiggleDocument,
                 animationMode: animationMode)
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    // "handleAnimationModeDidChange" does same
    // "handleDocumentModeDidChange" does same
    // "applicationWillResignActive" does same
    @MainActor func applicationWillResignActive(jiggleViewModel: JiggleViewModel,
                                                jiggleDocument: JiggleDocument,
                                                animationMode: AnimatonMode) {
        flushAll(jiggleViewModel: jiggleViewModel,
                 jiggleDocument: jiggleDocument,
                 animationMode: animationMode)
    }
    
}
