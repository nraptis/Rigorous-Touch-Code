//
//  AnimationTouchStateBag+GenerateCommands.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/18/24.
//

import Foundation

// [Animation Mode Verify] 12-19-2024
//
// This pretty much works, it's been
// tested a lot of times. It works
// as prescribed. The code is slightly
// redundant, more helper functions would
// be even worse, so let's stick with it.
//
extension AnimationTouchStateBag {
    
    // [Animation Mode Verify] 12-19-2024
    //
    // This seems good, it needs generate
    // comands in the exact order:
    // 1.) remove
    // 2.) move
    // 3.) add
    //
    // With this ordering, it always works.
    //
    func generateAppropriateCommands() {
        
        // Recycle the commands, start with empty commands.
        for commandIndex in 0..<stateCommandCount {
            let command = stateCommands[commandIndex]
            AnimationPartsFactory.shared.depositAnimationTouchStateCommand(command)
        }
        stateCommandCount = 0

        generateAppropriateCommands_Remove()
        generateAppropriateCommands_Move()
        generateAppropriateCommands_Add()
    }
    
    // [Animation Mode Verify] 12-19-2024
    //
    // This seems good, it's kind of the same
    // logic twice in a row. Once to check if
    // the command is needed, then again to
    // build out the command. Little redundant.
    //
    private func generateAppropriateCommands_Remove() {
        var isRemoveCommandNeeded = false
        for beforeStateIndex in 0..<beforeStateCount {
            let beforeState = beforeStates[beforeStateIndex]
            if afterStatesContains(touchID: beforeState.touchID) == false {
                
                // It's in the before state,
                // It's not in the after state.
                // That's a remove...
                
                isRemoveCommandNeeded = true
                break
            }
        }
        
        if isRemoveCommandNeeded == false {
            return
        }
        
        let newCommand = AnimationPartsFactory.shared.withdrawAnimationTouchStateCommand()
        newCommand.chunkCount = 0
        newCommand.type = .remove
        addStateCommandUnique(stateCommand: newCommand)
        
        for beforeStateIndex in 0..<beforeStateCount {
            let beforeState = beforeStates[beforeStateIndex]
            if afterStatesContains(touchID: beforeState.touchID) == false {
                
                // It's in the before state,
                // It's not in the after state.
                // That's a remove...
                
                let chunk = AnimationTouchStateCommandChunk.remove(beforeState.touchID)
                newCommand.addChunk(chunk: chunk)
            }
        }
        
    }
    
    // [Animation Mode Verify] 12-19-2024
    //
    // This seems good, it's kind of the same
    // logic twice in a row. Once to check if
    // the command is needed, then again to
    // build out the command. Little redundant.
    //
    private func generateAppropriateCommands_Move() {
        var isMoveCommandNeeded = false
        for beforeStateIndex in 0..<beforeStateCount {
            let beforeState = beforeStates[beforeStateIndex]
            var isMoved = false
            for afterStateIndex in 0..<afterStateCount {
                let afterState = afterStates[afterStateIndex]
                if beforeState.touchID == afterState.touchID {
                    if beforeState.x != afterState.x || beforeState.y != afterState.y {
                        
                        // It's in the before state,
                        // It's in the after state.
                        // The x or y has changed.
                        // That's a move............
                        
                        isMoved = true
                    }
                }
            }
            if isMoved {
                isMoveCommandNeeded = true
                break
            }
        }
        
        if isMoveCommandNeeded == false {
            return
        }
        
        let newCommand = AnimationPartsFactory.shared.withdrawAnimationTouchStateCommand()
        newCommand.chunkCount = 0
        newCommand.type = .move
        addStateCommandUnique(stateCommand: newCommand)
        for beforeStateIndex in 0..<beforeStateCount {
            var afterX = Float(0.0)
            var afterY = Float(0.0)
            let beforeState = beforeStates[beforeStateIndex]
            var isMoved = false
            for afterStateIndex in 0..<afterStateCount {
                let afterState = afterStates[afterStateIndex]
                if beforeState.touchID == afterState.touchID {
                    if beforeState.x != afterState.x || beforeState.y != afterState.y {
                        
                        // It's in the before state,
                        // It's in the after state.
                        // The x or y has changed.
                        // That's a move............
                        
                        isMoved = true
                        afterX = afterState.x
                        afterY = afterState.y
                    }
                }
            }
            if isMoved {
                let chunk = AnimationTouchStateCommandChunk.move(beforeState.touchID,
                                                                 afterX,
                                                                 afterY)
                newCommand.addChunk(chunk: chunk)
            }
        }
    }
    
    // [Animation Mode Verify] 12-19-2024
    //
    // This seems good, it's kind of the same
    // logic twice in a row. Once to check if
    // the command is needed, then again to
    // build out the command. Little redundant.
    //
    private func generateAppropriateCommands_Add() {
        var isAddCommandNeeded = false
        for afterStateIndex in 0..<afterStateCount {
            let afterState = afterStates[afterStateIndex]
            if !beforeStatesContains(touchID: afterState.touchID) {
                
                // It's in the after state.
                // It's not in the before state,
                // That's an add...
                
                isAddCommandNeeded = true
                break
            }
        }
        
        if isAddCommandNeeded == false {
            return
        }
        
        let newCommand = AnimationPartsFactory.shared.withdrawAnimationTouchStateCommand()
        newCommand.chunkCount = 0
        newCommand.type = .add
        addStateCommandUnique(stateCommand: newCommand)
        
        for afterStateIndex in 0..<afterStateCount {
            let afterState = afterStates[afterStateIndex]
            if !beforeStatesContains(touchID: afterState.touchID) {
                
                // It's in the after state.
                // It's not in the before state,
                // That's an add...
                
                let chunk = AnimationTouchStateCommandChunk.add(afterState.touchID,
                                                                afterState.x,
                                                                afterState.y)
                newCommand.addChunk(chunk: chunk)
            }
        }
    }
    
}
