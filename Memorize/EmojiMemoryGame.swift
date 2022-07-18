//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Hiren Patel on 6/15/22.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject{
    //new to Theme Manager
    enum EmojiType: Int{
        case vehiclesEmojis  = 0
        case fruitEmojis = 1
        case animalEmojis = 2
    }
    private static let emojis = [
        ["🚑","🚒","🚓","🚕","🚗","✈️","🚁","🚀","🚂","🚃","🚢","🚣","🚤","🚅","🚈","🚌"],
        ["🍏","🍎","🍐","🍊","🍌","🍉","🍇","🍓","🫐","🍈","🍒","🍑","🥭","🍍","🥥","🍅"],
        ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐻‍❄️","🐨","🐯","🦁","🐮"]
    ]
    private static var gameEmojis : EmojiType = EmojiType.vehiclesEmojis
    private static var userWantedCardCount :  Int?
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
    
    typealias Card = MemoryGame<String>.Card
    
    @Published private var model: MemoryGame<String> = createMemoryGame(with: gameEmojis)
    
    var cards: Array<Card> {
        return model.cards
    }
    private static func createMemoryGame(with emojiType : EmojiType ) -> MemoryGame<String> {
        MemoryGame<String>(numberOfCardPairs: cardCount) { pairIndex in
            emojis[emojiType.rawValue][pairIndex]
        }
    }
    func changeGame(with emojiType : EmojiType ){
        if (EmojiMemoryGame.gameEmojis != emojiType) {
            EmojiMemoryGame.gameEmojis = emojiType
            model = EmojiMemoryGame.createMemoryGame(with : emojiType)
            restart()
        }
    }
    func shuffle(){
        model.shuffle()
    }
    func choose(_ card : Card){
        model.choose(card)
    }
    func restart(){
        model = EmojiMemoryGame.createMemoryGame(with : EmojiMemoryGame.gameEmojis)
    }

}
