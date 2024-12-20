//
//  AnimationTouchPointerBag+Sync.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/19/24.
//

import Foundation

// [Animation Mode Verify] 12-19-2024
// Looks good, no problem. We are using everything
// in this file, it's all working to specification.
//
extension AnimationTouchPointerBag {
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    //
    // 1.) We detach every pointer (it's not associated with a touch or command)
    // 2.) We "gather" up pointers from the touches.
    // 3.) We "gather" up additional pointers from our commands we receive.
    //
    // We may add new pointers...
    // We may end up with unassigned pointers...
    // We may change the action types of pointers...
    //
    // We will *not* remove pointers; they linger until they expire...
    //
    func sync(jiggle: Jiggle,
              controller: AnimationController,
              command: AnimationTouchStateCommand,
              stateBag: AnimationTouchStateBag) {
        
        sync_DetachAllTouchPointers()
        
        sync_GatherFromAnimationTouches(jiggle: jiggle,
                                        controller: controller)
        
        sync_GatherFromCommand(jiggle: jiggle,
                               controller: controller,
                               command: command)
        
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    func sync_DetachAllTouchPointers() {
        for pointerIndex in 0..<touchPointerCount {
            let pointer = touchPointers[pointerIndex]
            pointer.actionType = .detached
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    func sync_GatherFromAnimationTouches(jiggle: Jiggle, controller: AnimationController) {
        
        // We're looking for touches related to both
        // 1.) This particular jiggle.
        // 2.) This particular format (grab or continuous).
        
        // For each touch...
        for animationTouchIndex in 0..<controller.animationTouchCount {
            let animationTouch = controller.animationTouches[animationTouchIndex]
            let touchID = animationTouch.touchID
            
            switch animationTouch.residency {
            case .unassigned:
                break
            case .jiggleContinuous(let residencyJiggle):
                
                // If the touch resides in "continuous"
                
                if residencyJiggle === jiggle {
                    
                    // and the jiggle matches our jiggle...
                    
                    switch format {
                    case .grab:
                        break
                    case .continuous:
                        
                        // and our format is "continuous"...
                        
                        if let touchPointer = touchPointersFind(touchID: touchID) {
                            
                            // and we have the pointer already...
                            
                            // We're now a "retained" touch. Which means
                            // most likely that we did not move, add, or remove
                            // on this cycle. So, we call it "retained..."
                            touchPointer.actionType = .retained(animationTouch.x, animationTouch.y)
                            touchPointer.stationaryTime = 0.0
                            touchPointer.isExpired = false
                        }
                    }
                }
            case .jiggleGrab(let residencyJiggle):
                
                // If the touch resides in "grab"
                
                if residencyJiggle === jiggle {
                    
                    // and the jiggle matches our jiggle...
                    
                    switch format {
                    case .grab:
                        
                        // and our format is "grab"...
                        
                        if let touchPointer = touchPointersFind(touchID: touchID) {
                            
                            // and we have the pointer already...
                            
                            // We're now a "retained" touch. Which means
                            // most likely that we did not move, add, or remove
                            // on this cycle. So, we call it "retained..."
                            touchPointer.actionType = .retained(animationTouch.x, animationTouch.y)
                            touchPointer.stationaryTime = 0.0
                            touchPointer.isExpired = false
                        }
                    case .continuous:
                        break
                    }
                }
            }
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    func sync_GatherFromCommand(jiggle: Jiggle,
                                controller: AnimationController,
                                command: AnimationTouchStateCommand) {
        
        // For each command...
        for chunkIndex in 0..<command.chunkCount {
            let chunk = command.chunks[chunkIndex]
            
            // There's 3 types of chunk:
            // 1.) add(ObjectIdentifier, Float, Float)
            // 2.) remove(ObjectIdentifier)
            // 3.) move(ObjectIdentifier, Float, Float)
            switch chunk {
            case .add(let commandChunktouchID, let x, let y):
                if let touchPointer = touchPointersFind(touchID: commandChunktouchID) {
                    
                    // This is a possible case. The same
                    // memory address is being used for a
                    // new touch, which a previous touch had...
                    
                    // We update the existing touch pointer.
                    // The action type is "add" and
                    // the position is (x, y).
                    //
                    // It's now "add", so we reset
                    // the stationary timer and it's
                    // also not expired.
                    
                    touchPointer.actionType = .add(x, y)
                    touchPointer.x = x
                    touchPointer.y = y
                    touchPointer.stationaryTime = 0.0
                    touchPointer.isExpired = false
                    
                } else {
                    
                    // This is the typical case, we're
                    // adding a touch pointer, for "add",
                    // which doesn't exist.
                    
                    // We update the new touch pointer.
                    // The action type is "add" and
                    // the position is (x, y).
                    
                    // The parts factory will unexpire the touch.
                    
                    let newTouchPointer = AnimationPartsFactory.shared.withdrawAnimationTouchPointer(touchID: commandChunktouchID)
                    newTouchPointer.actionType = .add(x, y)
                    newTouchPointer.x = x
                    newTouchPointer.y = y
                    touchPointersAddUnique(newTouchPointer)
                }
            case .remove(let commandChunktouchID):
                
                if let touchPointer = touchPointersFind(touchID: commandChunktouchID) {
                    
                    // We update the existing touch pointer.
                    // The action type is "remove"
                    //
                    // It's now "remove", so we reset
                    // the stationary timer and it's
                    // also not expired.
                    
                    touchPointer.actionType = .remove
                    touchPointer.stationaryTime = 0.0
                    touchPointer.isExpired = false
                } else {
                    
                    // This shouldn't even be possible. But, if
                    // for some reason, we don't have a pointer...
                    // we simply spin one up for the appropriate touch...
                    
                    // We update the new touch pointer.
                    // The action type is "remove"
                    
                    // The parts factory will unexpire the touch.
                    
                    let newTouchPointer = AnimationPartsFactory.shared.withdrawAnimationTouchPointer(touchID: commandChunktouchID)
                    newTouchPointer.actionType = .remove
                    touchPointersAddUnique(newTouchPointer)
                }
            case .move(let commandChunktouchID, let x, let y):
                if let touchPointer = touchPointersFind(touchID: commandChunktouchID) {
                    
                    // We update the existing touch pointer.
                    // The action type is "move" and
                    // the position is (x, y).
                    
                    // It's now "move", so we reset
                    // the stationary timer and it's
                    // also not expired.
                    
                    touchPointer.actionType = .move(x, y)
                    touchPointer.x = x
                    touchPointer.y = y
                    touchPointer.stationaryTime = 0.0
                    touchPointer.isExpired = false
                    
                } else {
                    
                    // This shouldn't even be possible. But, if
                    // for some reason, we don't have a pointer...
                    // we simply spin one up for the appropriate touch...
                    
                    // We update the new touch pointer.
                    // The action type is "move" and
                    // the position is (x, y).
                    
                    // The parts factory will unexpire the touch.
                    
                    let newTouchPointer = AnimationPartsFactory.shared.withdrawAnimationTouchPointer(touchID: commandChunktouchID)
                    newTouchPointer.actionType = .move(x, y)
                    newTouchPointer.x = x
                    newTouchPointer.y = y
                    touchPointersAddUnique(newTouchPointer)
                }
            }
        }
    }
}
