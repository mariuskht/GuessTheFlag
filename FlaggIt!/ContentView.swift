//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Marius on 28.06.26.
//

import AudioToolbox
import SwiftUI
internal import Combine

struct ContentView: View {
    @State private var correctAnswer = Int.random(in: 0...2)
    var selectedRegion: Region
    @State private var timeRemaining = 120
    @State private var showingResult = false
    @State private var resultTitle = "0"
    @State private var score = 0
    @State private var highscore = UserDefaults.standard.integer(forKey: "highscore")
    @State private var selectedAnswer: Int? = nil
    @State private var countries: [Country]
    
    @Environment(\.dismiss) private var dismiss

    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var timeString: String{
        String(format: "%d:%02d", timeRemaining / 60, timeRemaining % 60)
    }
    
    init(selectedRegion: Region) {
        self.selectedRegion = selectedRegion
        let pool = selectedRegion == .all ? Country.all : Country.all.filter { selectedRegion.rawValue == $0.region.rawValue }
        _countries = State(initialValue: Array(pool.shuffled().prefix(3)))
        _correctAnswer = State(initialValue: Int.random(in: 0...2))
    }
    
    var countriesPool : [Country] {
        if selectedRegion == .all {
            Country.all
        }else {
            Country.all.filter{selectedRegion.rawValue ==  $0.region.rawValue}
        }
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.appBackground
                    .ignoresSafeArea()
                
                VStack() {
                    Spacer()
                    VStack(spacing: 15) {
                        VStack {
                            Text("Tap the flag of")
                                .foregroundStyle(.secondary)
                                .font(.subheadline.weight(.heavy))
                            Text(countries[correctAnswer].localizedName)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .font(.largeTitle.weight(.semibold))
                                .lineLimit(nil)
                                .minimumScaleFactor(0.5)
                                .padding(.horizontal)
                        }
                        
                        ForEach(0..<3) { number in
                            Button{
                                flagTapped(number)
                            }label: {
                                Image(countries[number].assetName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 200)
                                    .background(Color.appCard)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay(RoundedRectangle(cornerRadius: 0)
                                        .strokeBorder(Color.black.opacity(0.05), lineWidth: 1))
                                    .overlay(RoundedRectangle(cornerRadius: 0)
                                        .strokeBorder(borderColor(for: number), lineWidth: 4))
                                    .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color.appCard)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.black.opacity(0.05), lineWidth: 1))
                    .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
                    Spacer()
                    Spacer()
                    Spacer()
                    HStack{
                        VStack(alignment: .leading, spacing: 2){
                            Text(String(localized: "Score"))
                                .foregroundStyle(Color.appTextPrimary)
                                .font(.subheadline)
                            Text(score.description)
                                .foregroundStyle(Color.appTextPrimary)
                                .font(.title.bold())
                        }
                        Spacer()
                        Rectangle()
                            .fill(.white.opacity(0.25))
                            .frame(width: 1, height: 28)
                        Spacer()
                        VStack(alignment: .leading, spacing: 2){
                            Text(String(localized: "Highscore"))
                                .foregroundStyle(Color.appTextPrimary)
                                .font(.subheadline)
                            Text(highscore.description)
                                .foregroundStyle(Color.appTextPrimary)
                                .font(.title.bold())
                        }
                    }
                    .padding(.horizontal, 70)
                }
                .padding()
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                    }
                .sharedBackgroundVisibility(.hidden)
                ToolbarItem{
                    Text(timeString)
                        .font(.largeTitle.monospacedDigit())
                        .foregroundStyle(Color.appTextPrimary)
                        .frame(minWidth: 100)
                }
                .sharedBackgroundVisibility(.hidden)
            }
            .alert(resultTitle, isPresented: $showingResult) {
                Button("Exit Game") {
                    dismiss()
                }
                Button("Restart", action: resetGame)
            } message: {
                Text("Your score is: \(score.description)")
            }
        }
        .onReceive(timer) {_ in
            guard timeRemaining > 0 else {return}
            timeRemaining -= 1
            if timeRemaining == 0 {
                resultTitle = String(localized: "Time Up!")
                if(score > UserDefaults.standard.integer(forKey: "highscore")){
                    UserDefaults.standard.set(score, forKey: "highscore")
                    highscore = score
                }
                showingResult = true
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        selectedAnswer = number
        
        if number == correctAnswer {
            AudioServicesPlaySystemSound(1054)
            score+=1
        } else {
            AudioServicesPlaySystemSound(1053)
            score -= 2
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            askQuestion()
        }
        
    }
    
    func askQuestion() {
        countries = Array(countriesPool.shuffled().prefix(3))
        correctAnswer = Int.random(in: 0...2)
        selectedAnswer = nil
    }
    
    func resetGame() {
        score = 0
        timeRemaining = 120
        askQuestion()
    }
    
    func borderColor(for number: Int) -> Color {
        guard selectedAnswer != nil else {
            return .clear
        }
        if number == correctAnswer {
            return .green
        }else{
            return .red
        }
    }
}
