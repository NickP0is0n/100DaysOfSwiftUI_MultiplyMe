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
    @State private var possibleAnswers = [Int]()
    @State private var currentQuestion = 0
    
    @State private var isGameStarted = false
    
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
                        startGame()
                    }
                    .roundedRectangleStyle(color: .white)
                    
                    Spacer()
                    
                    if isGameStarted {
                        VStack {
                            Text(questions[currentQuestion])
                            HStack {
                                ForEach(0..<possibleAnswers.count, id: \.self) {
                                    Button("\(possibleAnswers[$0])") {
                                        
                                    }
                                    .font(.largeTitle)
                                    .foregroundStyle(.white)
                                    .roundedRectangleStyle(color: .blue)
                                }
                            }
                        }
                        .roundedRectangleStyle(color: .white)
                        Spacer()
                    }
                        
                }
                .padding()
            }
        }
    }
    
    func startGame() {
        questions.removeAll()
        generateQuestions()
        isGameStarted = true
        generateAnswers()
    }
    
    func generateQuestions() {
        for _ in 0..<(Int(selectedQuestionAmount) ?? 2) {
            let secondNumber = Int.random(in: 2..<10)
            questions.append("What is \(selectedMultiplicationTable) times \(secondNumber)?")
            rightAnswers.append(selectedMultiplicationTable * secondNumber)
        }
    }
    
    func generateAnswers() {
        possibleAnswers.removeAll(keepingCapacity: true)
        possibleAnswers.append(rightAnswers[currentQuestion])
        
        for _ in 0..<3 {
            possibleAnswers.append(Int.random(in: 1..<(rightAnswers[currentQuestion] + 10)))
        }
        possibleAnswers.shuffle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
