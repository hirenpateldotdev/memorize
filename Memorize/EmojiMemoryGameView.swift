//
//  ContentView.swift
//  Memorize
//
//  Created by Hiren Patel on 6/14/22.
//

import SwiftUI

struct CardView: View {
    @State private var animatedBonusRemaining: Double = 0
    
    let card : MemoryGame<String>.Card
    var body: some View{
        GeometryReader(content: { geometry in
            ZStack{
                Group
                {
                    if card.isConsumingBonusTime {
                        Pie(
                            startAngle: Angle(degrees: 0-90),
                            endAngle: Angle(degrees: ((1-animatedBonusRemaining)*360-90)),
                            clockwise: true)
                        .onAppear {
                            animatedBonusRemaining =  card.bonusRemaining
                            withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                animatedBonusRemaining = 0
                            }
                        }
                    } else {
                        Pie(
                            startAngle: Angle(degrees: 0-90),
                            endAngle: Angle(degrees: ((1-card.bonusRemaining)*360-90)),
                            clockwise: true)
                    }
                }
                .padding(DrawingConstants.circlePadding)
                .opacity(DrawingConstants.circleOpacity)
                Text(card.content)
                    .rotationEffect(Angle(degrees: card.isMatched ? 360 : 0))
                    .animation(
                        Animation.linear(duration: 1)
                        .repeatForever(autoreverses: false)
                    )
                    .font(Font.system(size: 32))
                    .scaleEffect(scale(thatFits: geometry.size))
            }.cardify(isFaceUp: card.isFaceUp)
        })
    }
    private func scale(thatFits size : CGSize) -> CGFloat {
        min(size.width,size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    private func font(in size: CGSize) ->Font {
        Font.system(size: min(size.width,size.height) * DrawingConstants.fontScale)
    }
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.6
        static let fontSize: CGFloat = 32
        static let circleOpacity: CGFloat = 0.5
        static let circlePadding: CGFloat = 6
    }
}

struct EmojiMemoryGameView: View { // func program
    @ObservedObject var game: EmojiMemoryGame
    @State private var dealt = Set<Int>()
    @Namespace private var dealingNamespace
    
    var body: some View {
        VStack{
            title
            ZStack{
                gameBody
                deckBody
            }
            HStack{
                restart
                Spacer()
                vehicleGame
                fruitGame
                animalGame
                Spacer()
                shuffle
            }
        }
        .padding(.horizontal)
    }
    
    var vehicleGame: some View {
        Button {
            game.changeGame(with: EmojiMemoryGame.EmojiType.vehiclesEmojis)
            withAnimation(.spring()){
                makeDeck()
            }
        } label: {
            Image(systemName: "car")
        }
    }
    var fruitGame: some View {
        Button {
            game.changeGame(with: EmojiMemoryGame.EmojiType.fruitEmojis)
            withAnimation(.spring()){
                makeDeck()
            }
        } label: {
            Image(systemName: "birthday.cake")
        }
    }
    var animalGame: some View {
        Button {
            game.changeGame(with: EmojiMemoryGame.EmojiType.animalEmojis)
            withAnimation(.spring()){
                makeDeck()
            }
        } label: {
            Image(systemName: "car")
        }
    }
    var title: some View {
        Label("Memorize!", systemImage: "brain.head.profile")
            .font(.largeTitle)
            .foregroundColor(.green)
    }
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            cardView(for: card)
        }
        .onAppear() {
            withAnimation(.easeInOut(duration: 5)) {
                
            }
        }
        .foregroundColor(DrawingConstants.color)
    }
    var shuffle: some View {
        
        Button("Shuffle") {
            withAnimation(.spring()){
                game.shuffle()
            }
        }
    }
    var restart: some View {
        Button("Restart") {
            withAnimation(.spring()){
                makeDeck()
            }
        }
    }
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .zIndex(zIndex(for: card))
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(
                        AnyTransition.asymmetric(
                            insertion: .opacity,
                            removal: .scale))
            }
        }
        .frame(width : DrawingConstants.undealthWidth, height: DrawingConstants.undealthHeight)
        .foregroundColor(DrawingConstants.color)
        .onTapGesture {
            for card in game.cards {
                withAnimation(dealAnimation(for: card)){
                    deal(card)
                }
            }
        }
    }
    
    @ViewBuilder
    private func cardView(for card: EmojiMemoryGame.Card) -> some View {
        if isUndealt(card) || card.isMatched && !card.isFaceUp {
            Color.clear
        } else {
            CardView(card: card)
                .zIndex(zIndex(for: card))
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .padding(4)
                .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity).animation(.spring()))
                .onTapGesture {
                    withAnimation(.spring()){
                        game.choose(card)
                    }
                }
        }
    }
    private func deal(_ card : EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    private func makeDeck(){
        dealt = []
        game.restart()
        game.shuffle()
    }
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var dealy = 0.0
        if let index = game.cards.firstIndex(where: {$0.id == card.id}) {
            dealy =  Double(index) * ( DrawingConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: DrawingConstants.dealDuration).delay(dealy)
    }
    private func zIndex(for card : EmojiMemoryGame.Card) -> Double{
        -Double( game.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
    }
    
    private struct DrawingConstants {
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 1
        static let undealthWidth: CGFloat = undealthHeight * aspectRatio
        static let undealthHeight: CGFloat = 200
        static let color: Color = .red
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.portrait)
        //        EmojiMemoryGameView(game: game)
        //            .preferredColorScheme(.light)
    }
}
