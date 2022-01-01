//
//  ContentView.swift
//  WeSplit
//
//  Created by Christopher Haynes on 12/27/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var checkAmount = 0.0
    // Index zero of Picker for-loop (AKA default 2 people)
    @State private var numPeople = 0
    @State private var tipPercentage = 20
    @State private var zeroTip = false
    @FocusState private var amountIsFocused: Bool
    let tipPercentages = [10,15,20,25,0]
    
    var overallTotal: Double {
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = tipValue + checkAmount

        return grandTotal
    }
    
    // Equal to total value + tip percentage / num people.
    var totalPerPerson: Double {
        let peopleCount = Double(numPeople + 2)
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = tipValue + checkAmount
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var body: some View {
        NavigationView {
            Form {
                // TOP SECTION ---------------------------
                Section {
                    // User can enter check amnt based on local currency (USD default)
                    // Show numerical keyboard (w/ decimal point) for user input
                    TextField("Amount", value: $checkAmount, format:
                                    .currency(code: Locale.current.currencyCode ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    
                    // User can select num people to split the check with
                    Picker("Number of People: ", selection: $numPeople) {
                        ForEach(2..<100) {
                            Text("\($0) People")
                        }
                    }
                } header: {
                    Text("Check Details")
                }
                
                // MIDDLE SECTION 1 (TIP PERCENTAGE) ----------------------------
                Section {
                    Picker("Tip Percentage: ", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Desired tip percentage:")
                }
                
                // MIDDLE SECTION 2 (CHECK TOTAL W/ TIP)
                Section {
                    Text(overallTotal, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                        .foregroundColor(tipPercentage == 0 ? .red : .primary)
                } header: {
                    Text("Grand total")
                }
                
                // BOTTOM SECTION ----------------------------
                Section {
                    // Display total amount of check (real-time updates as user inputs value)
                    Text(totalPerPerson, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                } header: {
                    Text("Total per person")
                }
                
            }
            .navigationTitle("WeSplit")
            .navigationBarTitleDisplayMode(.inline)
            // Adds a DONE button for user to hide keyboard when done with input
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
