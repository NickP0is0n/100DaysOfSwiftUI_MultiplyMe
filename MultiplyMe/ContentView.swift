//
//  ContentView.swift
//  MultiplyMe
//
//  Created by Mykola Chaikovskyi on 09.09.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedMultiplicationTable = 2
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color(red: 255 / 255, green: 190 / 255, blue: 176 / 255), Color(red: 255 / 255, green: 110 / 255, blue: 106 / 255)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    Stepper("Which number do you want to practice?", value: $selectedMultiplicationTable, in: 2...12, step: 1)
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    HStack {
                        Text("You have selected:")
                            .font(.headline)
                        Text("\(selectedMultiplicationTable)")
                            .font(.headline.bold())
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
