//
//  TasksView.swift
//  Track Pal
//
//  Created by Abdulla Rayes on 14/07/2023.
//

import SwiftUI
import Firebase


struct TasksView: View {
    
    @StateObject var taskElements = TaskElements()
        
    @State var sheetVisible = false
    
    @AppStorage("editV") var editVisible = false
    
    @State var prioritizeVisible = false
    
    @State var prioritized = false
    
    @AppStorage("launched") var launched = false
    
    @State var editedTaskElement: TaskElement?

    @State var offsets = OffsetClass()
    
    @AppStorage("completed") var completedTask = false
    
    @AppStorage("numOfDays") var daysPassed = 0
    
    let todaysTasks: LocalizedStringKey = "TodaysTasks"
    
    @State private var taskIndexToEdit: Int? = 0
    
    @State private var prioritizingTaskIndex: Int?
    
    var dataService = DataService()
    
    @ObservedObject var databaseTasks = TaskFModel(id: UUID().uuidString)
    


    var body: some View {
        NavigationStack {
            ZStack {
               BackgroundView()
                ScrollView {
                    ForEach(Array(taskElements.items.enumerated()), id: \.1.id) { index, item in
                        
                        TaskRowView(item: item, index: index, offsets: offsets)

                            .onAppear {
                                print("\(item.taskText)")
                                editedTaskElement = taskElements.items[index]
                            }
                            
                            
                    }
    
                } 
                .toolbar  {
                    Button {
                        sheetVisible = true
                        prioritized = false
                    } label: {
                        
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                }
                
                .sheet(isPresented: $launched, onDismiss: {

                }, content: {
                    SignInView()
                })
                .sheet(isPresented: $sheetVisible) {
                    AddTaskView(taskElement: taskElements, offsets: $offsets.offsetItems)
                }
                .sheet(isPresented: $editVisible) {
                    EditTaskView(taskElements: taskElements ,taskElement: $editedTaskElement, offsets: $offsets.offsetItems, taskIndex: taskIndexToEdit ?? 0)
                }
                  
            }
            .navigationTitle(todaysTasks)
        }
        .onAppear {
                offsets = OffsetClass()
            }
    }
  
    func dateToDouble(_ date: Date) -> Double {
        return date.timeIntervalSinceNow
    }
  
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView(offsets: OffsetClass())
    }
}
