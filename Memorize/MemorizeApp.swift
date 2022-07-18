//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Hiren Patel on 6/14/22.
//

import SwiftUI

@main
//main program
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            //Body
            EmojiMemoryGameView(game: game)
        }
    }
}
