//
//  TaskRowView.swift
//  Track Pal
//
//  Created by Abdulla Rayes on 12/08/2023.
//

import SwiftUI
import Firebase

struct TaskRowView: View {
    
    @State var item: TaskElement
    
    @State var index: Int
    
    @StateObject var taskElements = TaskElements()
    
    var dataService = DataService()
    
    var offsets: OffsetClass = OffsetClass()

    @State private var prioritizingTaskIndex: Int?

    @State var prioritizeVisible = false

    @AppStorage("editV") var editVisible = false

    @State private var taskIndexToEdit: Int? = 0

    @State var prioritized = false

    @StateObject var databaseTasks = TaskFModel(id: UUID().uuidString)
    
    

    var body: some View {
        HStack {
                    Spacer()
                    if prioritized {
                        Image(systemName: "exclamationmark.circle.fill")

                    }
                    Text(item.taskText)
                    Spacer()
                    
                    Text(dataService.getTime(date: item.startedTimePicked))
                    Spacer()
                    
                    Text(dataService.getTime(date: item.finishedTimePicked))
                    Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .offset(x: index < offsets.offsetItems.count ? offsets.offsetItems[index].width : 0, y: 0)
        .background(.thinMaterial)
        .foregroundColor(.secondary)
        .onTapGesture(perform: {
                editVisible = true
                taskIndexToEdit = index
        })
        .onLongPressGesture(perform: {
            prioritizeVisible = true
            prioritizingTaskIndex = index
            taskElements.items[index].isPrioritized = true

        })
        .alert("Do you want to prioritize the task \"\(item.taskText)\"?", isPresented: Binding(
            get: { prioritizeVisible && prioritizingTaskIndex == index },
            set: { newValue in
                prioritizeVisible = newValue
            }
        )) {
            Button("No", role: .cancel) {
                prioritized = false
                taskElements.items[index].isPrioritized = false
            }
            Button("Yes") {
                taskElements.items[index].isPrioritized = true
                prioritized = true
                dataService.prioritize(for: item)

            }
        }
        

        .gesture(
            DragGesture()
                .onChanged({ gesture in
                    
                    let translationWidth = gesture.translation.width

                    if index < offsets.offsetItems.count {
                        offsets.offsetItems[index].width = translationWidth
                    }
                })
                .onEnded({ gesture in
                    
                    withAnimation {
                        
                        if index < offsets.offsetItems.count {
                            var offsetWidth = offsets.offsetItems[index].width
                            
                            if offsetWidth < -100 {
                                
                                offsetWidth = -1000
                                
                                
                                taskElements.items.remove(at: index)
                                
                                
                                // offsets.offsetItems.removeLast()
                                databaseTasks.deleteData(toDelete: item)
                                
                            } else if offsetWidth > 100 {
                                
                                // completedTask = true
                                taskElements.items.remove(at: index)
                                
                                
                                databaseTasks.addDayStreak(toIncrement: item)
                                dataService.getCertificate()
                                
                            } else {
                                offsets.offsetItems[index] = .zero
                            }
                        }
                    }
                })
        )
        
    }
}

//struct TaskRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskRowView()
//    }
//}
