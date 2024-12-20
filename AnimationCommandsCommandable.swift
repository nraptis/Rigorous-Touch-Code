//
//  AnimationCommandsCommandable.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/20/24.
//

import Foundation

// [Animation Mode Verify] 12-20-2024
// Looks good, no problem. We are using everything
// in this protocol, it's all working to specification.
//
protocol AnimationCommandsCommandable {
    var pointerBag: AnimationTouchPointerBag { get }
    var stateBag: AnimationTouchStateBag { get }
}

extension AnimationCommandsCommandable {
    
    // [Animation Mode Verify] 12-19-2024
    // Looks good, no problem. I've read each line.
    // We perform each command in order.
    // We sync, then onto the next command/
    @MainActor func performStateCommands(jiggle: Jiggle,
                                         jiggleDocument: JiggleDocument,
                                         controller: AnimationController) {
        for commandIndex in 0..<stateBag.stateCommandCount {
            let command = stateBag.stateCommands[commandIndex]
            
            pointerBag.sync(jiggle: jiggle,
                            controller: controller,
                            command: command,
                            stateBag: stateBag)
            
            switch command.type {
            case .add:
                pointerBag.captureStart(jiggle: jiggle)
            case .remove:
                pointerBag.captureStart(jiggle: jiggle)
            case .move:
                pointerBag.captureTrack(jiggle: jiggle,
                                        jiggleDocument: jiggleDocument)
            }
        }
    }
    
}
