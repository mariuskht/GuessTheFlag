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
    
    @State private var countries = ["Afghanistan", "AlandIslands", "Albania", "Algeria", "Andorra", "Angola", "Anguilla", "Antarctica", "AntiguaandBarbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "BoliviaPlurinationalStateof", "BonaireSintEustatiusandSaba", "BosniaandHerzegovina", "Botswana", "BouvetIsland", "Brazil", "BritishIndianOceanTerritory", "BruneiDarussalam", "Bulgaria", "BurkinaFaso", "Burundi", "CaboVerde", "Cambodia", "Cameroon", "Canada", "CaymanIslands", "CentralAfricanRepublic", "Chad", "Chile", "China", "ChristmasIsland", "CocosKeelingIslands", "Colombia", "Comoros", "Congo", "CongoTheDemocraticRepublicofthe", "CookIslands", "CostaRica", "CotedIvoire", "Croatia", "Cuba", "Curacao", "Cyprus", "Czechia", "Denmark", "Djibouti", "Dominica", "DominicanRepublic", "Ecuador", "Egypt", "ElSalvador", "EquatorialGuinea", "Eritrea", "Estonia", "Eswatini", "Ethiopia", "FalklandIslandsMalvinas", "FaroeIslands", "Fiji", "Finland", "France", "FrenchGuiana", "FrenchPolynesia", "FrenchSouthernTerritories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guatemala", "Guernsey", "Guinea", "GuineaBissau", "Guyana", "Haiti", "HeardIslandandMcDonaldIslands", "HolySeeVaticanCityState", "Honduras", "Hungary", "Iceland", "India", "Indonesia", "IranIslamicRepublicof", "Iraq", "Ireland", "IsleofMan", "Israel", "Italy", "Jamaica", "Japan", "Jersey", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "KoreaDemocraticPeoplesRepublicof", "KoreaRepublicof", "Kosovo", "Kuwait", "Kyrgyzstan", "LaoPeoplesDemocraticRepublic", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "MarshallIslands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "Mexico", "MicronesiaFederatedStatesof", "MoldovaRepublicof", "Monaco", "Mongolia", "Montenegro", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "NewCaledonia", "NewZealand", "Nicaragua", "Niger", "Nigeria", "Niue", "NorfolkIsland", "NorthMacedonia", "NorthernMarianaIslands", "Norway", "Oman", "Pakistan", "Palau", "PalestineStateof", "Panama", "PapuaNewGuinea", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Qatar", "Reunion", "Romania", "RussianFederation", "Rwanda", "SaintBarthelemy", "SaintHelenaAscensionandTristandaCunha", "SaintKittsandNevis", "SaintLucia", "SaintMartinFrenchpart", "SaintPierreandMiquelon", "SaintVincentandtheGrenadines", "Samoa", "SanMarino", "SaoTomeandPrincipe", "SaudiArabia", "Senegal", "Serbia", "Seychelles", "SierraLeone", "Singapore", "SintMaartenDutchpart", "Slovakia", "Slovenia", "SolomonIslands", "Somalia", "SouthAfrica", "SouthGeorgiaandtheSouthSandwichIslands", "SouthSudan", "Spain", "SriLanka", "Sudan", "Suriname", "SvalbardandJanMayen", "Sweden", "Switzerland", "SyrianArabRepublic", "TaiwanProvinceofChina", "Tajikistan", "TanzaniaUnitedRepublicof", "Thailand", "TimorLeste", "Togo", "Tokelau", "Tonga", "TrinidadandTobago", "Tunisia", "Turkiye", "Turkmenistan", "TurksandCaicosIslands", "Tuvalu", "UK", "US", "Uganda", "Ukraine", "UnitedArabEmirates", "UnitedStatesMinorOutlyingIslands", "Uruguay", "Uzbekistan", "Vanuatu", "VenezuelaBolivarianRepublicof", "VietNam", "VirginIslandsBritish", "VirginIslandsUS", "WallisandFutuna", "WesternSahara", "Yemen", "Zambia", "Zimbabwe"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var timeRemaining = 120
    @State private var showingResult = false
    @State private var resultTitle = "0"
    @State private var score = 0
    @State private var highscore = UserDefaults.standard.integer(forKey: "highscore")
    @State private var selectedAnswer: Int? = nil
    
    @Environment(\.dismiss) private var dismiss

    
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var timeString: String{
        String(format: "%d:%02d", timeRemaining / 60, timeRemaining % 60)
    }
    
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
                VStack() {
                    Spacer()
                    VStack(spacing: 15) {
                        VStack {
                            Text("Tap the flag of")
                                .foregroundStyle(.secondary)
                                .font(.subheadline.weight(.heavy))
                            Text(localizedCountryName(for: countries[correctAnswer]))
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
                                Image(countries[number])
                                    .resizable()
                                    .scaledToFit()
                                    .shadow(radius: 5)
                                    .frame(maxWidth: 200)
                                    .overlay(RoundedRectangle(cornerRadius: 0)
                                        .stroke(borderColor(for: number), lineWidth: 4))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(.rect(cornerRadius: 20))
                    Spacer()
                    Spacer()
                    Spacer()
                    HStack{
                        VStack(alignment: .leading, spacing: 2){
                            Text(String(localized: "Score"))
                                .foregroundStyle(.white)
                                .font(.subheadline)
                            Text(score.description)
                                .foregroundStyle(.white)
                                .font(.title.bold())
                        }
                        Spacer()
                        Rectangle()
                            .fill(.white.opacity(0.25))
                            .frame(width: 1, height: 28)
                        Spacer()
                        VStack(alignment: .leading, spacing: 2){
                            Text(String(localized: "Highscore"))
                                .foregroundStyle(.white)
                                .font(.subheadline)
                            Text(highscore.description)
                                .foregroundStyle(.white)
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
                        .foregroundStyle(.white)
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
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedAnswer = nil
    }
    
    func resetGame() {
        score = 0
        timeRemaining = 120
        askQuestion()
    }
    
    func localizedCountryName(for assetName: String) -> String {
        guard let isoCode = countryISOCodes[assetName] else { return assetName }
        return Locale.current.localizedString(forRegionCode: isoCode) ?? assetName
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

#Preview {
    ContentView()
}
