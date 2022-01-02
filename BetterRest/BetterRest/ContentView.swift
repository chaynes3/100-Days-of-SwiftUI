//
//  ContentView.swift
//  BetterRest
//
//  Created by Christopher Haynes on 1/1/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    
//    func trivialExample() {
//        let components = Calendar.current.dateComponents([.hour, .minute], from: Date.now)
//        let hour = components.hour ?? 0
//        let minutes = components.minute ?? 0
//        print(components)
//    }
    
    var body: some View {
        VStack(spacing: 50) {
            
            Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
            
            DatePicker("Please enter a date", selection: $wakeUp, in: Date.now...)
                .labelsHidden() // Screen Readers!
            
            // Different ways to format a Date object
            Text(Date.now, format: .dateTime.hour().minute())
            Text(Date.now.formatted(date: .long, time: .shortened))
        }
        .padding()
    }
}




// ---------------------------------------------------
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
