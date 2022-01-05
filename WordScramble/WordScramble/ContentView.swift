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
    
    var body: some View {
        NavigationView {
            List {
                Section("User Input/Controls") {
                    TextField("Enter a word: ", text: $newWord)
                        .autocapitalization(.none)
                    Button("Clear Used Words") {
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
            .navigationTitle("\(rootWord)")
            .onSubmit(addNewWord)
        }
    }
    
    func addNewWord() {
        // 1. Lowercase newWord and remove any whitespace
        // 2. Check if atleast 1 char, else exit
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard newWord.count > 0 else { return }
        
        // Extra validation here (to be added later)
        
        
        // 3. Insert answer at position 0 in usedWords arrray, then reset newWord back to empty string
        withAnimation { usedWords.insert(answer, at: 0) }
        newWord = ""
    }

}


/*
    NOTES:
    1. Look up the keyword 'guard' as a refresher -> I don't understand how it is being used inside addNewWord()
    2.
*/






// --------------------------------------------------------
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
