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

struct RoundedRectangleMaterialStyle: ViewModifier {
    var material: Material
    
    func body(content: Content) -> some View {
        content
        .padding()
        .background(material)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct Question {
    let question: String
    let answer: Int
}

struct QuestionView: View {
    var question: Question
    var possibleAnswers: [Int]
    var onAnswer: (Int) -> Void
    
    var body: some View {
        VStack {
            Text(question.question)
            HStack {
                ForEach(0..<possibleAnswers.count, id: \.self) { selected in
                    Button("\(possibleAnswers[selected])") {
                        onAnswer(selected)
                    }
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .roundedRectangleStyle(color: Color(red: 105 / 255, green: 0 / 255, blue: 168 / 255))
                }
            }
        }
        .padding()
        .roundedRectangleStyle(material: .thick)
    }
}

extension View {
    func roundedRectangleStyle(color: Color) -> some View {
        modifier(RoundedRectangleStyle(color: color))
    }
    
    func roundedRectangleStyle(material: Material) -> some View {
        modifier(RoundedRectangleMaterialStyle(material: material))
    }
}

struct ContentView: View {
    let questionAmounts = ["5", "10", "20"]
    
    @State private var selectedMultiplicationTable = 2
    @State private var selectedQuestionAmount = "5"
    
    @State private var questions = [Question]()
    @State private var possibleAnswers = [Int]()
    @State private var currentQuestion = 0
    @State private var selectedAnswer = -1
    
    @State private var score = 0
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    @State private var endGameAlert = false
    
    @State private var isGameStarted = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [
                    Color(red: 0.7, green: 0.9, blue: 0.9), // Soft pastel cyan
                    Color(red: 0.6, green: 0.8, blue: 1.0), // Soft pastel blue
                    Color(red: 1.0, green: 0.8, blue: 0.9)  // Soft pastel pink
                ], startPoint: .top, endPoint: .bottom)
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
                    .roundedRectangleStyle(material: .thick)
                    
                    Button("Start new game") {
                        startGame()
                    }
                    .roundedRectangleStyle(material: .thick)
                    
                    Spacer()
                    
                    if isGameStarted {
                        QuestionView(question: questions[currentQuestion], possibleAnswers: possibleAnswers) { answer in
                            selectedAnswer = answer
                            checkAnswer()
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                        
                        Spacer()
                    }
                        
                }
                .padding()
                .alert(alertTitle, isPresented: $showingAlert) {
                    Button("Next", action: nextQuestion)
                } message: {
                    Text(alertMessage)
                }
                .alert(alertTitle, isPresented: $endGameAlert) {
                    Button("OK", action: resetGame)
                } message: {
                    Text(alertMessage)
                }
            }
        }
    }
    
    func startGame() {
        withAnimation(.easeInOut(duration: 1.5)) {
            questions.removeAll()
            generateQuestions()
            isGameStarted = true
            generateAnswers()
        }
    }
    
    func generateQuestions() {
        for _ in 0..<((Int(selectedQuestionAmount) ?? 4 + 1) ) {
            let secondNumber = Int.random(in: 2..<10)
            questions.append(Question(question: "What is \(selectedMultiplicationTable) times \(secondNumber)?", answer: selectedMultiplicationTable * secondNumber))
        }
    }
    
    func generateAnswers() {
        possibleAnswers.removeAll(keepingCapacity: true)
        possibleAnswers.append(questions[currentQuestion].answer)
        
        for _ in 0..<3 {
            possibleAnswers.append(Int.random(in: 1..<(questions[currentQuestion].answer + 10)))
        }
        possibleAnswers.shuffle()
    }
    
    func nextQuestion() {
        withAnimation {
            if currentQuestion == questions.count - 1 {
                alertTitle = "Game over"
                alertMessage = "You finished your path, congratulations!\nYour final score: \(score).\nThank you for playing."
                endGameAlert = true
            }
            else {
                currentQuestion += 1
                generateAnswers()
            }
        }
    }
    
    func checkAnswer() {
        if possibleAnswers[selectedAnswer] == questions[currentQuestion].answer {
            score += 100
            alertTitle = "You are correct!"
            alertMessage = "The answer is indeed \(questions[currentQuestion].answer).\nGood job! Your score: \(score)."
        } else {
            alertTitle = "Oops..."
            alertMessage = "This is not right :( Right answer was \(questions[currentQuestion].answer).\nYour score: \(score)."
        }
        showingAlert = true
    }
    
    func resetGame() {
        withAnimation(.easeInOut(duration: 1.5)) {
            currentQuestion = 0
            selectedAnswer = -1
            score = 0
            isGameStarted = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
