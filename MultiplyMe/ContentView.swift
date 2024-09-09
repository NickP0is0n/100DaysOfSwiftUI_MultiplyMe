//
//  ContentView.swift
//  MultiplyMe
//
//  Created by Mykola Chaikovskyi on 09.09.2024.
//

import SwiftUI

struct RoundedRectangleStyle: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
        .padding()
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

extension View {
    func roundedRectangleStyle(color: Color) -> some View {
        modifier(RoundedRectangleStyle(color: color))
    }
}

struct ContentView: View {
    let questionAmounts = ["5", "10", "20"]
    
    @State private var selectedMultiplicationTable = 2
    @State private var selectedQuestionAmount = "5"
    
    @State private var questions = [String]()
    @State private var rightAnswers = [Int]()
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color(red: 255 / 255, green: 190 / 255, blue: 176 / 255), Color(red: 255 / 255, green: 110 / 255, blue: 106 / 255)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    VStack(alignment: .leading) {
                        Stepper(value: $selectedMultiplicationTable, in: 2...12, step: 1) {
                            HStack {
                                Text("Which number?")
                                Spacer()
                                Text("\(selectedMultiplicationTable)")
                                    .fontWeight(.bold)
                            }
                        }
                        Text("How many questions?")
                            .padding(.top)
                        Picker("How many questions?", selection: $selectedQuestionAmount) {
                            ForEach(questionAmounts, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .roundedRectangleStyle(color: .white)
                    
                    Button("Start new game") {
                        
                    }
                    .roundedRectangleStyle(color: .white)
                    
                    Spacer()
                        
                }
                .padding()
            }
        }
    }
    
    func startGame() {
        
    }
    
    func generateQuestions() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
