//
//  MenuView.swift
//  FlaggIt!
//
//  Created by Marius on 06.07.26.
//

import SwiftUI

struct MenuView: View {
    @State private var showingRegion = false
    var body: some View {
        NavigationStack{
            ZStack{
                Color.appBackground
                    .ignoresSafeArea()
                VStack(spacing: 12){
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 200)
                    
                    Text("Flaggit!")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Color.appTextPrimary)
                    
                    Button{
                        showingRegion = true
                    }label:{
                        Text("Start Game")
                            .font(.system(.headline, design: .rounded).weight(.semibold))
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.appAccent)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .padding(.horizontal, 40)
                    }
                }
            }
            .fullScreenCover(isPresented: $showingRegion){
                RegionView()
            }
        }
    }
}

#Preview {
    MenuView()
}
