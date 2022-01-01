//
//  ContentView.swift
//  rockPaperScissors
//
//  100 DAYS OF SWIFT - DAY 25 CHALLENGE
//  URL: https://www.hackingwithswift.com/guide/ios-swiftui/2/3/challenge
//
//  Created by Christopher Haynes on 12/31/21.
//

import SwiftUI


struct ContentView: View {
    
    // ------------------------------ PROGRAM VARIABLES & FUNCS ------------------------------
    @State private var choices = ["Rock", "Paper", "Scissors"].shuffled()
    @State private var currentChoice = Int.random(in: 0...2)
    @State private var playerShouldWin = Bool.random()
    @State private var winOrLoseMessage = ""
    @State private var gameOver = false
    
    @State private var playerScore = 0
    @State private var playerSelection = 0
    @State private var playerWon = false
    @State private var draw = false
    
    // array[0] means win, array[1] means loss
    let rock = ["Scissors","Paper"]
    let paper = ["Rock","Scissors"]
    let scissors = ["Paper","Rock"]
    
    //!!!TODO: Verify winLoseMsg() and winOrLoseMessage are actually being used
    func winLoseMsg() {
        if playerShouldWin == false {
            winOrLoseMessage = "Lose"
        }
        winOrLoseMessage = "Win"
    }
    
    // Shuffles the array of options and resets the computer's selection
    func reset() {
        winLoseMsg()
        choices = choices.shuffled()
        currentChoice = Int.random(in: 0...2)
        playerWon = false
        draw = false
        playerShouldWin = Bool.random()
    }
    
    func isDraw() -> Bool {
        if choices[playerSelection] == choices[currentChoice] {
            draw = true
            return true
        }
        return false
    }
    
    
    /*
     !!!TODO: Refactor selectionResultsWin() & selectionResultsLose()...
        Code reuse is obvious and they should be consolidated, followed by refactoring
        the method that calls them (buttonPressed())
    */
    func selectionResultWin() {
        if isDraw() { return }
        
        switch choices[playerSelection] {
        case "Rock":
            if choices[currentChoice] == rock[0] { playerWon = true }
            break
        case "Paper":
            if choices[currentChoice] == paper[0] { playerWon = true }
            break
        case "Scissors":
            if choices[currentChoice] == scissors[0] { playerWon = true }
            break
        default:
            return
        }
    }
    
    func selectionResultLose() {
        if isDraw() { return }
        
        switch choices[playerSelection] {
        case "Rock":
            if choices[currentChoice] == rock[1] { playerWon = true }
            break
        case "Paper":
            if choices[currentChoice] == paper[1] { playerWon = true }
            break
        case "Scissors":
            if choices[currentChoice] == scissors[1] { playerWon = true }
            break
        default:
            return
        }
    }
    
    // Function to check conditions based on which button the user clicked
    func buttonPressed(_ number: Int) {
        playerSelection = number
        
        if playerShouldWin {
            selectionResultWin()
            if playerWon { playerScore += 1 } // Increment score since player won
            else if isDraw() { reset() } // Draw, so reset
            else {  // Player lost, so reset the score & board
                playerScore = 0
                gameOver.toggle()
                reset()
                
            }
        }
        else {
            selectionResultLose()
            if playerWon { playerScore += 1 } // Increment score since player won
            else if isDraw() { reset() } // Draw, so reset
            else {  // Player lost, so reset the score & board
                playerScore = 0
                gameOver.toggle()
                reset()
            }
        }
        
        reset()
    }
    
    // ------------------------------ MAIN VIEW ------------------------------
    var body: some View {
        ZStack {
            LinearGradient(colors: [.mint, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            // TITLE VSTACK -------------------------
            VStack(spacing: 50) {
                Text("Rock-Paper-Scissors!")
                    .font(.largeTitle)
                    .padding()
                
                // COMPUTER SELECTION TITLE VSTACK -------------------------
                VStack {
                    Text("Computer selected: \(choices[currentChoice])").font(.title)
                    Text("Make a selection to: \(playerShouldWin ? "Win":"Lose")")
                }
                
                // USER PROMPTS AND BUTTONS HSTACK -------------------------
                HStack(spacing: 10) {
                    
                    ForEach(0..<3) { number in
                        Button {
                            buttonPressed(number)
                        } label: {
                            Text("\(choices[number])")
                        }
                        .buttonStyle(.borderedProminent)
                        .foregroundColor(.white)
                    }
                }
                .padding()
                
                HStack {
                    Text("Current Score: \(playerScore)")
                }
            }
            .background(.thinMaterial)
            .foregroundColor(.primary)
            
        }
        .alert("Game Over!", isPresented: $gameOver) {
            Button("Continue", action: reset)
            Button("Quit", action: reset)
        } message: {
            Text("Would you like to play again?")
        }
    }
}






// ------------------------------------------------------------
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
