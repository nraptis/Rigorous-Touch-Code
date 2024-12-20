//
//  AnimationTouchStateCommandChunk.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 12/8/24.
//

// [Animation Mode Verify] 12-18-2024
//
// This captures all the necessary info;
// this is a stripped down version of the
// same previous enum, this is verified.
//
enum AnimationTouchStateCommandChunk {
    case add(ObjectIdentifier, Float, Float)
    case remove(ObjectIdentifier)
    case move(ObjectIdentifier, Float, Float)
}
