//
//  AnimationTouchStateBag+HouseKeeping.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/18/24.
//

import Foundation

// [Animation Mode Verify] 12-19-2024
// Looks good, no problem. We are using everything
// in this file, it's all working to specification.
//
extension AnimationTouchStateBag {
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    func addStateCommandUnique(stateCommand: AnimationTouchStateCommand) {
        for stateCommandIndex in 0..<stateCommandCount {
            if stateCommands[stateCommandIndex] === stateCommand {
                return
            }
        }
        while stateCommands.count <= stateCommandCount {
            stateCommands.append(stateCommand)
        }
        stateCommands[stateCommandCount] = stateCommand
        stateCommandCount += 1
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    func beforeStatesAddUnique(_ state: AnimationTouchState) {
        for stateIndex in 0..<beforeStateCount {
            if beforeStates[stateIndex] === state {
                return
            }
        }
        while beforeStates.count <= beforeStateCount {
            beforeStates.append(state)
        }
        beforeStates[beforeStateCount] = state
        beforeStateCount += 1
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    func beforeStatesContains(touchID: ObjectIdentifier) -> Bool {
        for stateIndex in 0..<beforeStateCount {
            if beforeStates[stateIndex].touchID == touchID {
                return true
            }
        }
        return false
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    func afterStatesAddUnique(_ state: AnimationTouchState) {
        for stateIndex in 0..<afterStateCount {
            if afterStates[stateIndex] === state {
                return
            }
        }
        while afterStates.count <= afterStateCount {
            afterStates.append(state)
        }
        afterStates[afterStateCount] = state
        afterStateCount += 1
    }
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    func afterStatesContains(touchID: ObjectIdentifier) -> Bool {
        for stateIndex in 0..<afterStateCount {
            if afterStates[stateIndex].touchID == touchID {
                return true
            }
        }
        return false
    }
    
}
