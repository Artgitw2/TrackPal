//
//  EditTaskView.swift
//  Track Pal
//
//  Created by Abdulla Rayes on 29/07/2023.
//

import SwiftUI
import Firebase

struct EditTaskView: View {
    
    @StateObject var taskElements: TaskElements = TaskElements()

    @Binding var taskElement: TaskElement?

    @Environment(\.dismiss) var dismiss
    
    @State var text = ""
    
    @State var startDate: Date = Date.now
    
    @State var finishDate: Date = Date().addingTimeInterval(7200)
    
    @State var showingAlert = false
    
    let taskEntry: LocalizedStringKey = "TaskEntry"
    
    let startTimeText: LocalizedStringKey = "StartTimeText"
    
    let finishTimeText: LocalizedStringKey = "FinishTimeText"
    
    let editTitle: LocalizedStringKey = "EditTitle"
    
    let changeButton: LocalizedStringKey = "ChangeButton"
    
    let validTaskWarning: LocalizedStringKey = "ValidTaskWarning"
    
    let okButton: LocalizedStringKey = "OkButton"
    
    let tasksCollection = Firestore.firestore().collection("Tasks")
    
    @StateObject var databaseTasks = TaskFModel(id: UUID().uuidString)
    
    var currentUserUID = Auth.auth().currentUser?.uid ?? ""
    
    @Binding var offsets: [CGSize]
    
    @Environment (\.colorScheme) var colorScheme
    
    var taskIndex: Int
    
    @AppStorage("changed") var changed = false
    
    
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
                
            }
            .padding()
            .background(colorScheme == .light ? lightAppBackground : darkAppBackground)
            .onAppear {
                if let task = taskElement {
                    text = task.taskText
                    startDate = task.startedTimePicked
                    finishDate = task.finishedTimePicked
                }
            }
            .sheet(isPresented: $changed, onDismiss: {
                

            }, content: {
                TasksView()
            })
            .toolbar {
                ToolbarItem (placement: .bottomBar) {
                    
                    Button {
                        
                        if (startDate < finishDate) && text != "" {

                            let changedItem = TaskElement(id: taskElement?.id ?? "" , taskText: text, startedTimePicked: startDate, finishedTimePicked: finishDate)
                            
                            taskElement = changedItem
                            
                            taskElements.items[taskIndex] = changedItem
                            
                            databaseTasks.updateData(toUpdate: changedItem)
                            
                            offsets.append(CGSize.zero)

                            dismiss()
                            
                        } else {
                            showingAlert = true
                        }
           
                    } label: {
                        Text(changeButton)
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
            .navigationTitle(editTitle)
        }
        
    }
 
}

//struct EditTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditTaskView(taskElement: .constant(TaskElements()), offsets: .constant([CGSize.zero]), taskIndex: 0)
//    }
//}
