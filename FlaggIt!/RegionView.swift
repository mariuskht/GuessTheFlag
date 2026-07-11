//
//  RegionView.swift
//  FlaggIt!
//
//  Created by Marius on 07.07.26.
//

import SwiftUI

struct RegionView: View {
    @State private var presentedRegion: Region?
    private let selectableRegions: [(region: Region, image: String, title: String)] = [
        (.europe, "america", "Europe"),
        (.americas, "america", "America"),
        (.asia, "america", "Asia"),
        (.africa, "america", "Africa"),
        (.oceania, "america", "Oceania")
    ]
    
    private let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.appBackground
                    .ignoresSafeArea()
                VStack(spacing: 15) {
                    HStack{
                        VStack(spacing: 15){
                            LazyVGrid(columns: columns, spacing: 15){
                                ForEach(selectableRegions, id: \.region){ entry in
                                    regionButton(entry)
                                }
                            }
                            
                            Button {
                                presentedRegion = Region.all
                            } label: {
                                Text("All")
                                    .font(.system(.headline, design: .rounded).weight(.semibold))
                                    .foregroundStyle(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.appAccent)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                        }
                    }
                    
                }
                .padding()
            }
            .fullScreenCover(item: $presentedRegion){ region in
                ContentView(selectedRegion: region)
            }
        }
    }
    
    private func regionButton(_ entry: (region: Region, image: String, title: String)) -> some View {
            VStack(spacing: 10) {
                Button {
                    presentedRegion = entry.region
                } label: {
                    Image(entry.image)
                        .resizable()
                        .scaledToFit()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(Color.appCard)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color.black.opacity(0.05), lineWidth: 1))
                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)

                Text(entry.title)
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(Color.appTextPrimary)
            }
        }
}

#Preview {
    RegionView()
}
