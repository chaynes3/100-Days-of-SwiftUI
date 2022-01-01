//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Christopher Haynes on 12/29/21.
//

import SwiftUI

// Custom ViewModifier for Text views (& extension below)
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundColor(.blue)
    }
}
extension View {
    func bigTitle() -> some View {
        modifier(Title())
    }
}


// Custome View for Images
struct FlagImage: View {
    var countries: [String]
    var number: Int
    
    var body: some View {
        Image(countries[number])
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}


struct ContentView: View {
    @State private var showingScore = false
    @State private var endOfGame = false
    @State private var scoreTitle = ""
    @State private var endMessage = ""
    @State private var guesses = 0
    
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess The Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack (spacing: 15) {
                    VStack {
                        
                        Text("Tap the flag of: ")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            // Flag was tapped
                            flagTapped(number)
                        } label: {
                            FlagImage(countries: countries, number: number)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is now \(score)")
        }
        
        // Player reached max num questions (8)
        .alert(endMessage, isPresented: $endOfGame) {
            Button("Continue Playing", action: resetGame)
        }
    }
    
    func flagTapped(_ number: Int) {
        guesses += 1
        
        if guesses > 7 {
            if number == correctAnswer {
                score += 1
                resetGame()
                endOfGame.toggle()
            } else {
                resetGame()
                endOfGame.toggle()
            }
            
        }
        else if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
            if score < 8 {
                showingScore.toggle()
            }
        } else {
            scoreTitle = "Sorry, that's the \(countries[number]) flag!"
            showingScore.toggle()
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetGame() {
        endMessage = "Final Score: \(score) out of \(guesses)!"
        score = 0
        guesses = 0
        askQuestion()
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
