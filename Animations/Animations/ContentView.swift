//
//  ContentView.swift
//  Animations
//
//  Created by Christopher Haynes on 1/6/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var animationAmount = 1.0
    
    var body: some View {
        NavigationView {
        
            Button("Tap Me") {
                // Increase size of button via scale effect and animationAmount var
                // animationAmount += 1
            }
            .padding(50)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(.red)
                    .scaleEffect(animationAmount)
                    .opacity(2 - animationAmount)
                    .animation(
                        .easeInOut(duration: 1)
                            .repeatForever(autoreverses: false),
                        value: animationAmount
                    )
                    .onAppear {
                        animationAmount = 2
                    }
            )
            
            
            // .animation(.easeOut, value: animationAmount)
            // .animation(.easeInOut(duration: 2), value: animationAmount)
//            .animation(
//                .easeInOut(duration: 1)
//                // AUTOREVERSES: creates 1sec animation to bounce up and down before reaching final size
//                    .repeatCount(3, autoreverses: true),
//                value: animationAmount
//            )
            
            
            // SPRING = Initial velocity on start; DAMPING = length of bounce time
            // .animation(.interpolatingSpring(stiffness: 50, damping: 1), value: animationAmount)
            
            // Not part of instructions - Added to reset button size without rebuilding project
//            .toolbar {
//                Button("Reset Button Size") {
//                    animationAmount = 1.0
//                }
//            }
        }
    }
}


/*
 NOTES:
 
 1. IMPLICIT ANIMATIONS:
    a) always need to watch a particular value otherwise animations would be triggered for every small change – even rotating the device from portrait to landscape would trigger the animation.
    b) We don't identify start/finish or each frame - It's simply a function of our state.
 
*/


// --------------------------------------------------------
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
