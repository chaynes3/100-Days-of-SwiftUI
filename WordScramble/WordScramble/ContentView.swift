//
//  ContentView.swift
//  WordScramble
//
//  100 Days of SwiftUI --> Day 29-31 (Project 5)
//
//  Created by Christopher Haynes on 1/4/22.
//

import SwiftUI

struct ContentView: View {
    
    // Variables needed for game
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var wordLetterLimit = 3
    @State private var userScore = 0
    
    // Variables to make showing errors easier
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            List {
                Section("User Input/Controls") {
                    TextField("Enter a word: ", text: $newWord)
                        .autocapitalization(.none)
                }
                Section("User Score") {
                    Text("\(userScore)")
                }
                Section("Clear List Below") {
                    // Basically starts a new game but doesn't change the root word
                    Button("Clear Used Words") {
                        userScore = 0
                        usedWords.removeAll()
                    }
                }
                Section("Used Words") {
                    // No duplicates, so (id: \.self) is used here for now [will learn better way soon]
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle("\(rootWord)") // Uses root word as nav title
            .onSubmit(addNewWord)   // When user enters a word and hits return, addNewWord() called
            .onAppear(perform: startGame)   // startGame() called when View appears (is reloaded)
            
            // Alert shown if any error occurs
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                Button("New Game") {
                    usedWords.removeAll()
                    startGame()
                }
            }
        }
    }
    
    
    func addNewWord() {
        // 1. Lowercase newWord and remove any whitespace
        // 2. Check if atleast 1 char, else exit
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard newWord.count > 0 else { return }
        
        // 3. Call methods to check inputs
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard isCorrectLength(word: answer) else {
            wordError(title: "Not Enough Letters", message: "Your word must be equal to or greater than 3 letters!")
            return
        }
        
        guard isNotPrimary(word: answer) else {
            wordError(title: "Primary Word Used", message: "You can't use the primary word in its entirety as an input.")
            return
        }
        
        // 4. Update user score now that input has passed checks
        calculateScore()
        
        // 5. Insert answer at position 0 in usedWords arrray, then reset newWord back to empty string
        withAnimation { usedWords.insert(answer, at: 0) }
        newWord = ""
    }
    
    
    // Loads a word from start.txt in app bundle. See individual comments below for further details.
    func startGame() {
        // Reset User Score for each word basically
        userScore = 0
        
        // 1. Find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")

                // 4. Pick one random word, or use "silkworm" as a sensible default
                rootWord = allWords.randomElement() ?? "silkworm"

                // If we are here everything has worked, so we can exit
                return
            }
        }

        // If were are *here* then there was a problem – trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
    
    
    // Has user's current input already been submitted?
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    
    // Is it the root word?
    func isNotPrimary(word: String) -> Bool {
        !(word == rootWord)
    }
    
    
    // Check if each letter of input also exists in root word
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        for letter in word {
            // If it exists, remove the letter (so it can't be used again)
            if let pos = tempWord.firstIndex(of: letter) { tempWord.remove(at: pos) }
            else { return false }
        }
        return true
    }
    
    
    // Check if the user input is actually a real word
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    
    
    // Greater than specified number of characters?
    func isCorrectLength(word: String) -> Bool {
        word.count >= wordLetterLimit
    }
    
    
    // Changes the error messages to display appropriate details
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    
    // Calculates user score (num created words * num letters used)
    func calculateScore() {
        if userScore == 0 { userScore += newWord.count }
        else { userScore += usedWords.count * newWord.count }
    }

}


/*
    NOTES:
    1. Look up the keyword 'guard' as a refresher -> I don't understand how it is being used inside addNewWord()
    2. Also review 'if let' use and why it is needed.
*/






// --------------------------------------------------------
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
