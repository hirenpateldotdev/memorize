//
//  ThemeManager.swift
//  Memorize
//
//  Created by Hiren Patel on 6/27/22.
//

import Foundation
import SwiftUI



struct ThemeManager {
    enum EmojiType: Int{
        case vehiclesEmojis  = 0
        case fruitEmojis = 1
        case animalEmojis = 2
        
        var index : Int {
            return rawValue
        }
        
        var value: String {
            return String(describing: self)
        }
    }
    private static var emojis = [
        ["🚑","🚒","🚓","🚕","🚗","✈️","🚁","🚀","🚂","🚃","🚢","🚣","🚤","🚅","🚈","🚌"],
        ["🍏","🍎","🍐","🍊","🍌","🍉","🍇","🍓","🫐","🍈","🍒","🍑","🥭","🍍","🥥","🍅"],
        ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐻‍❄️","🐨","🐯","🦁","🐮"]
    ]
    private static var gameEmojis : EmojiType = EmojiType.vehiclesEmojis
    // nil : the user hasn't specified how many cards they wants so the app can put any number of apps
    // INT (1...INF) : the number of pairs that that users wants to be on the screen
    private static var userWantedCardCount :  Int?
    // INT (1...(Emojis in the Theme))) : the number of cards to be shown on the screen
    private static var cardCount : Int {
        get {
            if let count = userWantedCardCount {
                return count
            } else {
                return emojis[gameEmojis.rawValue].count
            }
        }
        set {
            if (newValue > emojis[gameEmojis.rawValue].count){
                userWantedCardCount = emojis[gameEmojis.rawValue].count
            } else {
                userWantedCardCount = newValue
            }
        }
    }
}
