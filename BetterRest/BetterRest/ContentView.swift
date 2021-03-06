//
//  ContentView.swift
//  BetterRest
//
//  100 Days of SwiftUI -> Project 4, Day 26-28
//  URL: https://www.hackingwithswift.com/100/swiftui/27
//  Created by Christopher Haynes on 1/1/22.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    // Used to store user input via various Views (DatePicker & Steppers)
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    // Alert specific variables, used to show results (see calculateBedtime())
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    // Static so it can be used to set wakeUp var above. Creates more realistic default wake time for user
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
        
    var body: some View {
        NavigationView {
            ZStack {
                Color.mint.ignoresSafeArea()
                
                Form {
                    Section {
                        Text("When do you want to wake up?")
                            .font(.headline)
                        DatePicker("Please enter a date", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden() // Screen Readers!
                    }
                    Section {
                        Text("Desired amount of sleep?")
                            .font(.headline)
                        Stepper("\(sleepAmount.formatted())", value: $sleepAmount, in: 4...12, step: 0.25)
                    }
                    Section {
                        
                        // ---If we didn't want to use the picker, we could use the Text & Stepper below.
                        
                        // Text("Daily coffee intake?").font(.headline)
                        // Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                        
                        Picker("Daily coffee intake: ", selection: $coffeeAmount) {
                            ForEach(1..<11) { number in
                                Text(number == 1 ? "1 Cup":"\(number) Cups") // nil coalescing
                                    .font(.body)
                            }
                        }.font(.headline)
                    }
                    Section {
                        Text("Recommended Bedtime: ").font(.headline)
                        Text("\(calculatedBedtime())").font(.largeTitle)
                    }
                }
                .padding()
                .navigationTitle("Better Rest")
//                .toolbar {
//                    Button("Calculate", action: calculateBedtime)
//                        .buttonStyle(.bordered)
//                        .foregroundColor(.white)
//                }
//                .alert(alertTitle, isPresented: $showingAlert) {
//                    Button("OK") { }
//                } message: {
//                    Text(alertMessage)
//                }
            }
        }
    }
    
    
    /*
     All details are commented within the function, identified in logical steps taken to move from problem initialization to
        obtaining a result. The overall purpose of this function is to use the provided & trained ML Model (SleepCalculator)
        to identify when a user should go to bed, based on user-set parameters (desired sleep amount, coffee intake, etc.)
     */
    func calculateBedtime() {
        do {
            // 1. Basically we first instantiate the model
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)

            // 2. Then we get hour and minute from user wakeUp, then convert to seconds (as a Double)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            // 3. We get our prediction from the Model (the time they should go to sleep), which we subtract from desired wakeUp
            //  This is essentially getting the date/time that the user should go to sleep, based on the inputs and the Model's prediction
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            // 4. Lastly, we show the user an alert that has the results obtained above (when they should go to sleep)
            alertTitle = "Your ideal bedtime is???"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        // Show the user the alert, which has the messages set within the do-try-catch above
        showingAlert.toggle()
    }
    
    
    /*
     NOTE: This function was created to comply with the challenge presented for day 28.
            It is basically the same code for the alert, therefore I would remove the alert
            function (calculateBedtime()) as a means of reducing code reuse; however, I am
            keeping both here as a means of notes to review.
     */
    func calculatedBedtime() -> String {
        do {
            // 1. Basically we first instantiate the model
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)

            // 2. Then we get hour and minute from user wakeUp, then convert to seconds (as a Double)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            // 3. We get our prediction from the Model (the time they should go to sleep), which we subtract from desired wakeUp
            //  This is essentially getting the date/time that the user should go to sleep, based on the inputs and the Model's prediction
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            /*
             This is extremely unlikely to execute.  If this were a production app, we may need to provide a
             better message or an error alert of some kind.
             */
            return "error"
        }
    }
    
    
}




// ---------------------------------------------------
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
