//
//  AppBrain.swift
//  Track Pal
//
//  Created by Abdulla Rayes on 15/07/2023.
//

import Foundation
import UIKit
import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

let lightAppBackground = LinearGradient(colors: [Color.green, Color.blue], startPoint: .bottomLeading, endPoint: .topTrailing)

let darkAppBackground = LinearGradient(colors: [Color(red: 0, green: 0, blue: 0.60), Color(red: 0, green: 0.60, blue: 0)], startPoint: .bottomLeading, endPoint: .topTrailing)

let priorityBackground = Color(red: 0.5, green: 0, blue: 0)


let sun: LocalizedStringKey = "sun"
let mon: LocalizedStringKey = "mon"
let tue: LocalizedStringKey = "tue"
let wed: LocalizedStringKey = "wed"
let thu: LocalizedStringKey = "thu"
let fri: LocalizedStringKey = "fri"
let sat: LocalizedStringKey = "sat"


let icon: LocalizedStringKey = "icon"

let light: LocalizedStringKey = "light"

let dark: LocalizedStringKey = "dark"



struct Settings: Identifiable {
    let id: UUID = UUID()
    var label: LocalizedStringKey
    var navLink1: LocalizedStringKey
    var navLink2: LocalizedStringKey
    var navLink3: LocalizedStringKey
}

struct TaskElement: Identifiable, Codable, Equatable {
    var id: String
    var taskText: String
    var startedTimePicked: Date
    var finishedTimePicked: Date
    var isPrioritized: Bool = false
    
    static func == (lhs: TaskElement, rhs: TaskElement) -> Bool {
        return lhs.id == rhs.id && lhs.taskText == rhs.taskText && lhs.startedTimePicked == rhs.startedTimePicked && lhs.finishedTimePicked == rhs.finishedTimePicked
    }
        
}



class TaskFModel: ObservableObject   {
    
    var tasks = [TaskElement]()
    @AppStorage("numOfDays") var daysPassed = 0

    
    var currentUserID: String
    var taskID: String
    var streakID: String

       
    init(id: String = UUID().uuidString, currentUserID: String =  Auth.auth().currentUser?.uid ?? "", streakID: String = UUID().uuidString) {
           self.taskID = id
           self.currentUserID = currentUserID
           self.streakID = streakID
           getData() // Fetch initial data when initializing
       }
    
    // add data to firestore
    func addData(text: String, startTime: Date, finishTime: Date) {
        let db = Firestore.firestore()
        
        db.collection("Users").document(currentUserID).collection("Tasks").document(taskID).setData([
            "text": text,
            "startTime": startTime,
            "finishTime": finishTime
        ], merge: true) { error in
            if error == nil {
                print("Task added successfully")
                self.getData()
            }
        }
    }
    
    
    // update data on firestore
    func updateData(toUpdate: TaskElement) {
        let db = Firestore.firestore()
        
        db.collection("Users").document(currentUserID).collection("Tasks").document(toUpdate.id).updateData([
            "startTime": toUpdate.startedTimePicked,
            "finishTime": toUpdate.finishedTimePicked,
            "text": toUpdate.taskText

        ]) { error in
            if error == nil {
                print("success")
            } else {
                print(error?.localizedDescription ?? "" )
            }
        }
        
        print(currentUserID)
        print(taskID)
    }
    
    
    
    func addDayStreak(toIncrement: TaskElement) {
        let db = Firestore.firestore()
        
        db.collection("Users").document(currentUserID).collection("DayStreaks").document(toIncrement.id).setData([
            "numOfDayStreaks": daysPassed
        ]) { error in
            if error == nil {
                print("day streak incremented successfully")
            } else {
                print("ERROR: \(error?.localizedDescription ?? "")")
            }
        }
    }


    
    
    // delete data from firestore
    
    func deleteData(toDelete: TaskElement) {
            
            let db = Firestore.firestore()
           
            
            db.collection("Users").document(currentUserID).collection("Tasks").document(toDelete.id).delete { error in
                    
                    if error == nil {
                        print("task deleted successfully")
                        print(self.taskID)
                        DispatchQueue.main.async {
                            self.tasks.removeAll { t in
                                return t.id == toDelete.id
                            }
                        }
                        
                    } else {
                        print(error?.localizedDescription ?? "")
                    }
                }
        }
  
    // fetch data from firestore
    
    func getData() {
        let db = Firestore.firestore()
        
        db.collection("Users").document(currentUserID).collection("Tasks").getDocuments { snapshot, error in
            
            if error == nil {
                if let snapshot = snapshot {
                    // get all documents
                    
                    DispatchQueue.main.async {
                        self.tasks = snapshot.documents.map { doc in
                            
                            
                            
                            return TaskElement(id: doc.documentID, taskText: doc["text"] as? String ?? "" , startedTimePicked: doc["startTime"] as? Date ?? Date(), finishedTimePicked: doc["finishTime"] as? Date ?? Date())
                        }
                    }
                }
            } else {
                
            }
        }
    }
}

// achievements certificates
struct Achievements: Identifiable {
        let id = UUID()
        let image: String
        let title: String
        var isUnlocked = false
}


// for the array of task elements
class TaskElements: ObservableObject {
    @Published var items = [TaskElement]()
    
    var currentUserID: String

    
    
    init(currentUserID: String =  Auth.auth().currentUser?.uid ?? "") {
        self.currentUserID = currentUserID
        if currentUserID != "" {
            addSnapshotListener(forUserID: currentUserID)
        }
    }
    

    
    
    func addSnapshotListener(forUserID userID: String) {
        print(userID)
        let db = Firestore.firestore()
        db.collection("Users").document(userID).collection("Tasks").addSnapshotListener { snap, err in
            if let err = err {
                print("Error! \(err.localizedDescription)")
                return
            }
            
//            DispatchQueue.main.async {
            
                // Clear the existing items array before updating

                self.items.removeAll()
                
                let documents = snap?.documents ?? []
                
                // Loop through the snapshot documents and extract data
                for document in documents {
                    let id = document.documentID
                    let taskText = document["text"] as? String ?? ""
                    let startedTimePicked = document["startTime"] as? Date ?? Date()
                    let finishedTimePicked = document["finishTime"] as? Date ?? Date()
                    
                    // Create a TaskElement instance and add it to the items array
                    let taskElement = TaskElement(id: id, taskText: taskText, startedTimePicked: startedTimePicked, finishedTimePicked: finishedTimePicked)
                    self.items.append(taskElement)
                }
            }
            
//        }
    }


}



// for offsets
class OffsetClass: ObservableObject {
    @Published var offsetItems = [CGSize]()
    
    init(numberOfItems: Int = TaskElements().items.count) {
        offsetItems = Array(repeating: .zero, count: numberOfItems)
    }
    
    func storeOffsetItems(numberOfItems: Int) {
        let encoder = JSONEncoder()
        do {
          let encoded =  try encoder.encode(offsetItems)
            UserDefaults.standard.set(encoded, forKey: "offset")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func loadOffsetItems(numberOfItems: Int) {
        if let decoded = UserDefaults.standard.data(forKey: "offset") {
            if let decodedItems = try? JSONDecoder().decode([CGSize].self, from: decoded) {
                if decodedItems.count == numberOfItems {
                    offsetItems = decodedItems
                } else {
                    // Reset offsets if the count doesn't match
                    resetOffsetItems(numberOfItems: numberOfItems)
                }
                return
            }
        }
        
        resetOffsetItems(numberOfItems: numberOfItems)
    }
    
    private func resetOffsetItems(numberOfItems: Int) {
        offsetItems = Array(repeating: .zero, count: numberOfItems)
    }
}


class DateManager {
    static let shared = DateManager()
    
    private let lastDateKey = "lastDate"
    
    private init() { }
    
    // this is a function to save the current date in UserDefaults
    func saveCurrentDate() {
        UserDefaults.standard.set(Date(), forKey: lastDateKey)
    }
    
    // this is a function to retrieve the last saved date from UserDefaults
    func getLastDate() -> Date? {
        return UserDefaults.standard.object(forKey: lastDateKey) as? Date
    }
    
    // a function to check if a day has passed since the last saved date
    func hasDayPassed() -> Bool {
        if let lastDate = getLastDate() {
            return Calendar.current.isDateInToday(lastDate) == false
        }
        return true
    }
}

struct User: Codable {
    var name: String = ""
    var email: String = ""
    var password: String = ""

}
