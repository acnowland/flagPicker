//
//  ContentView.swift
//  flagPicker
//
//  Created by Adam Nowland on 2/13/23.
//

import SwiftUI

struct FlagImage: View {
    
    var number: Int
    @Binding var countries: Array<String>
    
    var body: some View {
        Image(countries[number])
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 10)
    }
}

struct largeTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.largeTitle)
            .font(.subheadline.weight(.heavy))
    }
}

extension View {
    func largeTitleStyle () -> some View {
        modifier(largeTitle())
    }
}


struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var currentScore = 0
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    func flagTapped (_ number: Int) {
        if(number == correctAnswer){
            scoreTitle = "Correct"
            currentScore += 1
        } else {
            scoreTitle = "Wrong"
        }
        showingScore = true
    }
    
    func resetGame () {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack (spacing: 30) {
                VStack {
                    Text("Tap the flag of: ")
                        .foregroundColor(.white)
                        .font(.subheadline.weight(.heavy))
                    Text(countries[correctAnswer])
                        .largeTitleStyle()
                }
                
                ForEach(0..<3) { number in
                    Button {
                        flagTapped(number)
                    } label: {
                        FlagImage(number: number, countries: $countries)
                    }
                }
                VStack {
                    Text("Score: \(currentScore)")
                }
            }
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button ("Continue", action: resetGame)
        } message: {
            Text("Your score is \(currentScore)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
