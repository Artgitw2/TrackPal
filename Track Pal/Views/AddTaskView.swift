//
//  AddTaskView.swift
//  Track Pal
//
//  Created by Abdulla Rayes on 15/07/2023.
//

import SwiftUI
import Firebase

struct AddTaskView: View {
    
    
    @StateObject var taskElement: TaskElements = TaskElements()
        
    @Environment(\.dismiss) var dismiss
    
    @State var text: String = ""
    
    @State var startDate: Date = Date.now
    
    @State var finishDate: Date = Date().addingTimeInterval(7200)
    
    @State var showingAlert = false
    
    let taskEntry: LocalizedStringKey = "TaskEntry"
    
    let startTimeText: LocalizedStringKey = "StartTimeText"
    
    let finishTimeText: LocalizedStringKey = "FinishTimeText"
    
    let addTask: LocalizedStringKey = "AddTask"
    
    let validTaskWarning: LocalizedStringKey = "ValidTaskWarning"
    
    let okButton: LocalizedStringKey = "OkButton"
    
    let tasksCollection = Firestore.firestore().collection("Tasks")
    
    @StateObject var databaseTasks = TaskFModel(id: UUID().uuidString)
    
    var currentUserUID = Auth.auth().currentUser?.uid ?? ""
    
    @Binding var offsets: [CGSize]
    
    @Environment (\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                TextField(taskEntry, text: $text)
                    .padding()
                    .background(.thinMaterial)
                    .foregroundColor(.secondary)
                    .cornerRadius(25)
                
                
                DatePicker(startTimeText, selection: $startDate, displayedComponents: [.hourAndMinute])
                    .padding()
                
                DatePicker(finishTimeText, selection: $finishDate, displayedComponents: [.hourAndMinute])
                    .padding()
                
                Spacer()
                
            }.padding()
                .background(colorScheme == .light ? lightAppBackground : darkAppBackground)
                .toolbar {
                    ToolbarItem (placement: .bottomBar) {
                        Button {
                            
                            if (startDate < finishDate) && text != "" {
                                
                                let addedItem = TaskElement(id: databaseTasks.taskID,taskText: text, startedTimePicked: startDate, finishedTimePicked: finishDate)
                                
                                taskElement.items.append(addedItem)
                                
                                offsets.append(CGSize.zero)
                                
                                
                                databaseTasks.addData(text: text, startTime: startDate, finishTime: finishDate)
                                
                                dismiss()
                                
                            } else {
                                showingAlert = true
                            }
                            
                        } label: {
                            Text(addTask)
                                .padding()
                                .frame(width: 100)
                                .background(.thinMaterial)
                                .foregroundColor(.secondary)
                                .cornerRadius(15)
                            
                        }
                        
                    }
                }
                .alert(validTaskWarning, isPresented: $showingAlert) {
                    Button(okButton) {}
                }
            
        }
    }
    
    
}


struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView(taskElement: TaskElements(), offsets: .constant([CGSize.zero]))
    }
}
