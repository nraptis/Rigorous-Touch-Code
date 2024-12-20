//
//  AnimationTouchStateBag.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/8/24.
//

import Foundation

// [Animation Mode Verify] 12-18-2024
//
// This is good to keep; I've gone through
// it all line by line. "before" and "after"
// are very similar, yet a little different.
// The only possible improvement would be to
// re-use some of that same logic. It's fine
// like this. More nested code would make
// the shared code harder to read too.
// So, we opt for redundancy over complexity.
//
class AnimationTouchStateBag {
    
    let format: AnimationTouchFormat
    init(format: AnimationTouchFormat) {
        self.format = format
    }
    
    var beforeStates = [AnimationTouchState]()
    var beforeStateCount = 0
    
    var afterStates = [AnimationTouchState]()
    var afterStateCount = 0
    
    var stateCommands = [AnimationTouchStateCommand]()
    var stateCommandCount = 0
    
    func snapshotBefore(jiggle: Jiggle, controller: AnimationController) {
        
        // Purge the previously existing before states.
        for stateIndex in 0..<beforeStateCount {
            let state = beforeStates[stateIndex]
            AnimationPartsFactory.shared.depositAnimationTouchState(state)
        }
        beforeStateCount = 0
        
        // For each animation touch...
        for animationTouchIndex in 0..<controller.animationTouchCount {
            
            // Get the touch...
            let animationTouch = controller.animationTouches[animationTouchIndex]
            
            // For before state, including an expired touch.
            // If it expired, we will not add it to the after state...
            
            switch animationTouch.residency {
            case .unassigned:
                
                // If it's not related to *THIS* jiggle,
                // it's not in our sphere of influence.
                
                break
            case .jiggleContinuous(let residencyJiggle):
                
                // It's a touch that was registered in
                // continuous mode...
                
                if residencyJiggle === jiggle {
                    
                    // ... With the same jiggle...
                    
                    switch format {
                    case .grab:
                        
                        // We are the state bag for grab, this touch
                        // is for continuous mode. it's not in our
                        // sphere of influence.
                        
                        break
                    case .continuous:
                        
                        // We are the state bag for continuous this touch
                        // is for continuous mode. It's one of our touches...
                        // So, we register the state (in this case, before)
                        
                        let touchID = animationTouch.touchID
                        let newState = AnimationPartsFactory.shared.withdrawAnimationTouchState(touchID: touchID,
                                                                                               x: animationTouch.x,
                                                                                               y: animationTouch.y)
                        beforeStatesAddUnique(newState)
                    }
                }
            case .jiggleGrab(let residencyJiggle):
                
                // It's a touch that was registered in
                // grab mode...
                
                if residencyJiggle === jiggle {
                    
                    // ... With the same jiggle...
                    
                    switch format {
                    case .grab:
                        
                        // We are the state bag for grab this touch
                        // is for grab mode. It's one of our touches...
                        // So, we register the state (in this case, before)
                        
                        let touchID = animationTouch.touchID
                        let newState = AnimationPartsFactory.shared.withdrawAnimationTouchState(touchID: touchID,
                                                                                               x: animationTouch.x,
                                                                                               y: animationTouch.y)
                        beforeStatesAddUnique(newState)
                        
                    case .continuous:
                        
                        // We are the state bag for continuous, this touch
                        // is for grab mode. it's not in our
                        // sphere of influence.
                        
                        break
                    }
                }
            }
        }
    }
    
    func snapshotAfter(jiggle: Jiggle, controller: AnimationController) {
        
        // Purge the previously existing after states.
        for stateIndex in 0..<afterStateCount {
            let state = afterStates[stateIndex]
            AnimationPartsFactory.shared.depositAnimationTouchState(state)
        }
        afterStateCount = 0
        
        // For each animation touch...
        for animationTouchIndex in 0..<controller.animationTouchCount {
            
            // Get the touch...
            let animationTouch = controller.animationTouches[animationTouchIndex]
            
            // For after state, not including an expired touch.
            // This will effectively register as a "remove..." (due to expire)
            if animationTouch.isExpired {
                continue
            }
            
            switch animationTouch.residency {
            case .unassigned:
                
                // If it's not related to *THIS* jiggle,
                // it's not in our sphere of influence.
                
                break
            case .jiggleContinuous(let residencyJiggle):
                
                // It's a touch that was registered in
                // continuous mode...
                
                if residencyJiggle === jiggle {
                    
                    // ... With the same jiggle...
                    
                    switch format {
                    case .grab:
                        
                        // We are the state bag for grab, this touch
                        // is for continuous mode. it's not in our
                        // sphere of influence.
                        
                        break
                    case .continuous:
                        
                        // We are the state bag for continuous this touch
                        // is for continuous mode. It's one of our touches...
                        // So, we register the state (in this case, after)
                        
                        let touchID = animationTouch.touchID
                        let newState = AnimationPartsFactory.shared.withdrawAnimationTouchState(touchID: touchID,
                                                                                               x: animationTouch.x,
                                                                                               y: animationTouch.y)
                        afterStatesAddUnique(newState)
                        
                    }
                }
            case .jiggleGrab(let residencyJiggle):
                
                // It's a touch that was registered in
                // grab mode...
                
                if residencyJiggle === jiggle {
                    
                    // ... With the same jiggle...
                    
                    switch format {
                    case .grab:
                        
                        // We are the state bag for grab this touch
                        // is for grab mode. It's one of our touches...
                        // So, we register the state (in this case, after)
                        
                        let touchID = animationTouch.touchID
                        let newState = AnimationPartsFactory.shared.withdrawAnimationTouchState(touchID: touchID,
                                                                                               x: animationTouch.x,
                                                                                               y: animationTouch.y)
                        afterStatesAddUnique(newState)
                        
                    case .continuous:
                        
                        // We are the state bag for continuous, this touch
                        // is for grab mode. it's not in our
                        // sphere of influence.
                        
                        break
                    }
                }
            }
        }
    }
}
