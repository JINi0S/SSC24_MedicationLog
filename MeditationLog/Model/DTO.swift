//
//  File.swift
//  
//
//  Created by Lee Jinhee on 2/28/24.
//

import Foundation

struct SideEffectDTO {
    let date: Date
    let sideEffects: [[SideEffect]]
    
    init(date: Date, sideEffects: [[SideEffect]]) {
        self.date = date
        self.sideEffects = sideEffects
    }
}

struct VideoUrlDTO {
    let date: Date
    let urls: [URL]
    
    init(date: Date, urls: [URL]) {
        self.date = date
        self.urls = urls
    }
}

struct MemoDTO {
    let date: Date
    let memo: String
    
    init(date: Date, memo: String) {
        self.date = date
        self.memo = memo
    }
}
