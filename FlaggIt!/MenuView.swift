//
//  MenuView.swift
//  FlaggIt!
//
//  Created by Marius on 06.07.26.
//

import SwiftUI

struct MenuView: View {
    @State private var showingGame = false
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(
                    colors: [
                        Color(red: 0.06, green: 0.11, blue: 0.32),
                        Color(red: 0.68, green: 0.13, blue: 0.24)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                VStack(spacing: 12){
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 200)
                    
                    Text("Flaggit!")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                    
                    Button{
                        showingGame = true
                    }label:{
                        Text("Start Game")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .clipShape(.rect(cornerRadius: 12))
                            .padding(.horizontal, 40)
                    }
                }
            }
            .fullScreenCover(isPresented: $showingGame){
                ContentView()
            }
        }
    }
}

#Preview {
    MenuView()
}
