//
//  AnimationTouchStateCommand.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/8/24.
//

import Foundation

// [Animation Mode Verify] 12-18-2024
//
// This is fine. It really only has 2 things.
// 1.) A type (such as add, remove, move)
// 2.) A list of chunks (AnimationTouchStateCommandChunk)
// As a note, "containsTouch" can be removed, and then this line.
//
class AnimationTouchStateCommand {
    
    var type = AnimationTouchStateCommandType.move
    var chunks = [AnimationTouchStateCommandChunk]()
    var chunkCount = 0
    
    // [Animation Mode Verify] 12-18-2024
    // Looks good, no problem.
    func addChunk(chunk: AnimationTouchStateCommandChunk) {
        while chunks.count <= chunkCount {
            chunks.append(chunk)
        }
        chunks[chunkCount] = chunk
        chunkCount += 1
    }
    
}
