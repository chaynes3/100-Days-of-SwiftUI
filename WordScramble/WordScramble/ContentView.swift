//
//  ContentView.swift
//  WordScramble
//
//  100 Days of SwiftUI --> Day 29 (Project 5, Part 1)
//
//  Created by Christopher Haynes on 1/4/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
    
    
    // Really just a placeholder function to load in a file from our App bundle
    // URL: https://www.hackingwithswift.com/books/ios-swiftui/loading-resources-from-your-app-bundle
    func loadFile() {
        // Try and pull the file URL from our app bundle on the user's device
        if let fileURL = Bundle.main.url(forResource: "sime-file", withExtension: "txt") {
            
            // If here, the file was found on the user device's app bundle
            if let fileContents = try? String(contentsOf: fileURL) {
                
                // If here, we loaded the file into the string (fileContents is now a string loaded from the file)
            }
        }
    }
    
    
    // Working with strings!
    // URL: https://www.hackingwithswift.com/books/ios-swiftui/working-with-strings
    func test() {
        let input = """
                    a
                    b
                    c
                    """
        let letters = input.components(separatedBy: "\n")
        let letter = letters.randomElement()
        let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    // ...still working with strings :)
    // URL: https://www.hackingwithswift.com/books/ios-swiftui/working-with-strings
    func checkSpelling() {
        
        let word = "swift"
        let checker = UITextChecker() // Comes from UIKit (& therefore Obj-C)
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        let allGood = misspelledRange.location == NSNotFound // (Obj-C quirk; returns bool based on NSNotFound)
    }
}






// --------------------------------------------------------
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
