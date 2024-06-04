//
//  DataService.swift
//  Track Pal
//
//  Created by Abdulla Rayes on 16/07/2023.
//

import Foundation
import SwiftUI
import Firebase


struct DataService {
    
    let subscription: LocalizedStringKey = "subscription"
    let preferences: LocalizedStringKey = "preferences"
    let language: LocalizedStringKey = "language"
    let icon: LocalizedStringKey = "icon"
    let signOut: LocalizedStringKey = "SignOut"
    @AppStorage("completed") var completedTask = false
    @AppStorage("numOfDays") var daysPassed = 0
    var taskElements = TaskElements()



    func getSettingsData() -> [Settings] {
        return [Settings(label: preferences, navLink1: language, navLink2: icon, navLink3: signOut)]
    }
    
    
    
    func getAchievements() -> [Achievements] {
        return [Achievements(image: "1 week achievement", title: "1 week achievement"),
                Achievements(image: "2 weeks achievement", title: "2 weeks achievement"),
                Achievements(image: "1 month achievement", title: "1 month achievement"),
                Achievements(image: "3 months achievement", title: "3 months achievement"),
                Achievements(image: "6 months achievement", title: "6 months achievement"),
                Achievements(image: "year achievement", title: "year achievement")
        ]
    }
    
    
    
    func getCertificate() {
        
        
        if DateManager.shared.hasDayPassed() && taskElements.items.isEmpty {
            completedTask = true
        }


       if completedTask && DateManager.shared.hasDayPassed() {
           daysPassed += 1
           print(daysPassed)
           DateManager.shared.saveCurrentDate()
       } else if completedTask {
           print(daysPassed)
       } else {
           daysPassed = 0
           DateManager.shared.saveCurrentDate()
       }
        
   }
    
    
    func getTime(date: Date) -> String {
        let format = DateFormatter()
        format.timeStyle = .short
        
        return format.string(from: date)
    }
    
    
    func prioritize(for item: TaskElement) {
        if let indexSwapped = taskElements.items.firstIndex(of: item) {
            taskElements.items.remove(at: indexSwapped)
            taskElements.items.insert(item, at: 0)
        }

    }
}
