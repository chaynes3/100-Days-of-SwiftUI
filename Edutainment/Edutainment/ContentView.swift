//
//  ContentView.swift
//  Edutainment
//
//  Created by Christopher Haynes on 1/9/22.
//

import SwiftUI


struct ContentView: View {
    @State private var score = 0
    
    @State private var desiredNumQuestions = 5
    let numQuestionsRange = 5...20
    
    @State private var tableValue = 1
    let tableRange = 1...10
    
    @State private var answer: Int?
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    // User picks primary value for multiplication table
                    Stepper("Desired Multiplication Table", value: $tableValue, in: tableRange)
                    Stepper("Number of Questions", value: $desiredNumQuestions, in: numQuestionsRange)
                }
                VStack {
                    Text("Multiplication Table")
                        .font(.title)
//                    ForEach(0..<desiredNumQuestions) { num in
//                        Text("\(num) x \(tableValue)")
//                    }
                }
                // User will input answer here
                VStack {
                    TextField("Answer: ", value: $answer, format: .number)
                    if isCorrect() {
                        Text("Correct!")
                    }
                    
                }
                .navigationTitle("Edutainment")
            }
            .padding()
        }
    }
    
    func isCorrect() -> Bool {
        score += 1
        return true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
