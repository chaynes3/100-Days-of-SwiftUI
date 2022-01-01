//
//  ContentView.swift
//  TempConvert
//
//  DAY 19 - CHALLENGE DAY (https://www.hackingwithswift.com/100/swiftui/19)
//  Created by Christopher Haynes on 12/28/21.
//

import SwiftUI

struct ContentView: View {
    // Variables for temp conversions
    let tempOptions = ["Fahrenheit", "Celsius", "Kelvin"]
    @State private var userInput = 0.0
    @State private var userTempFormat = "Fahrenheit"
    @State private var userDesiredFormat = "Celsius"
    @FocusState private var isFocused: Bool
    
    // Converts user input to F regardless of desired output ("common denominator")
    func toFahrenheit(from: String) -> Measurement<UnitTemperature> {
        if from == "Celsius" {
            let userMeasurement = Measurement(value: userInput, unit: UnitTemperature.celsius)
            return userMeasurement.converted(to: .fahrenheit)
        } else if from == "Kelvin" {
            let userMeasurement = Measurement(value: userInput, unit: UnitTemperature.kelvin)
            return userMeasurement.converted(to: .fahrenheit)
        } else {
            let userMeasurement = Measurement(value: userInput, unit: UnitTemperature.fahrenheit)
            return userMeasurement
        }
    }
    
    // Final conversion result
    var conversionResult: Measurement<UnitTemperature> {
        // Pull in user's value converted to F
        let temp = toFahrenheit(from: userTempFormat)
        
        // Convert to desired/selected output
        if userDesiredFormat == "Kelvin" { return temp.converted(to: .kelvin) }
        else if userDesiredFormat == "Celsius" { return temp.converted(to: .celsius) }
        else { return temp }
    }
    
    
    // MAIN VIEW -----------
    var body: some View {
        NavigationView {
            Form {
                // Section 1 -------- USER INPUT ---------
                Section {
                    TextField("Temperature", value: $userInput, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($isFocused)
                    Picker("Current Format: ", selection: $userTempFormat) {
                        ForEach(tempOptions, id: \.self) { Text($0) }
                    }
                } header: { Text("Starting Temperature") }
                
                // Section 2 --------- DESIRED OUTPUT FORMAT ---------
                Section {
                    Picker("Convert To: ", selection: $userDesiredFormat) {
                        ForEach(tempOptions, id: \.self) { Text($0) }
                    }.pickerStyle(.segmented)
                } header: { Text("Desired Conversion") }
                
                // Section 3 --------- RESULTS ---------
                Section {
                    Text(String(format: "%.2f", conversionResult.value) + "\(conversionResult.unit.symbol)")
                } header: { Text("Conversion Results") }
                
            }
            .navigationTitle("Temperature Converter")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isFocused.toggle()
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
