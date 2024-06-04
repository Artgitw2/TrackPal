//
//  BoardOfAchievementsView.swift
//  Track Pal
//
//  Created by Abdulla Rayes on 14/07/2023.
//

import SwiftUI
import Firebase



struct AchievementImage: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scaledToFit()
            .frame(width: 300)
    }
}


struct BoardOfAchievementsView: View {
    
    @State var achievements = [Achievements]()
    
    var dataService = DataService()
    
    @State var unlocked = false
    @State var canShowSheet = false
    
    
    @AppStorage("completed") var completedTask = false
    @AppStorage("numOfDays") var daysPassed = 0

    let boa: LocalizedStringKey = "BOA"

    let unlockedLabel:LocalizedStringKey = "unlocked"
    let lockedLabel:LocalizedStringKey = "locked"
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem()]) {
                        ForEach (achievements) { achievement in
                            VStack {
                                
                                Button {
                                    
                                   
                                } label: {
                                    Image(achievement.image)
                                        .resizable()
                                        .background(achievement.isUnlocked ? .clear : .black)
                                        .opacity(achievement.isUnlocked ? 1.0 : 0.2)
                                        .modifier(AchievementImage())
                                }
                                HStack {
                                    Text(achievement.title)
                                        .font(.headline)
                                    Text(achievement.isUnlocked ? unlockedLabel: lockedLabel)
                                
                                }
                            }.padding()
                        }
                    }
                }.navigationTitle(boa)
            }
        }.onAppear {
            achievements = dataService.getAchievements()
            getCertificate()
        }
        .sheet(isPresented: $canShowSheet) {
            
        }
    }
    
    
    func getCertificate() {
        if completedTask && DateManager.shared.hasDayPassed() {
        
        } else {
            
            
            print(completedTask)
        }
        
        if daysPassed >= 360 {
            achievements[0].isUnlocked = true
            
            achievements[1].isUnlocked = true
            
            achievements[2].isUnlocked = true

            achievements[3].isUnlocked = true

            achievements[4].isUnlocked = true

            achievements[5].isUnlocked = true

        } else if daysPassed >= 180 {
            achievements[0].isUnlocked = true
            
            achievements[1].isUnlocked = true
            
            achievements[2].isUnlocked = true

            achievements[3].isUnlocked = true

            achievements[4].isUnlocked = true
            
        } else if daysPassed >= 90 {
            achievements[0].isUnlocked = true
            
            achievements[1].isUnlocked = true
            
            achievements[2].isUnlocked = true

            achievements[3].isUnlocked = true
        } else if daysPassed >= 30 {
            achievements[0].isUnlocked = true
            
            achievements[1].isUnlocked = true
            
            achievements[2].isUnlocked = true
        } else if daysPassed >= 14 {
            achievements[0].isUnlocked = true
            
            achievements[1].isUnlocked = true
        } else if daysPassed >= 7 { // change this line of code
            achievements[0].isUnlocked = true
            print(daysPassed)
        } else {
            print(daysPassed)
        }
   }
    
    
}

struct BoardOfAchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        BoardOfAchievementsView()
    }
}
