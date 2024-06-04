//
//  StatsView.swift
//  Track Pal
//
//  Created by Abdulla Rayes on 14/07/2023.
//

import SwiftUI


struct ProgressBar: View {
    var progressVal: Float
    var gradientColors: [Color]
    var size: CGFloat = 50.0
    
    
    var body: some View {
        ZStack {
            Circle()
                .stroke (lineWidth: 12.0)
                .foregroundColor(.secondary)
                .frame(width: size, height: size)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(progressVal))
                .stroke(
                    AngularGradient(gradient: Gradient(colors: gradientColors),
                                    center: .center,
                                    startAngle: .degrees(0),
                                    endAngle: .degrees(360)),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(Angle(degrees: 270))
                .frame(width: size, height: size)
            
            
            
            
        }
    }
    
}

struct StatsView: View {
    
    var taskElements = TaskElements()
    
    @State var progressVal: Float = 0.0
    
    @Environment (\.colorScheme) var colorScheme
    
    @AppStorage("numOfDays") var daysPassed = 0
    
    @AppStorage("completed") var completedTask = false
        
    let days: LocalizedStringKey = "days"
    let streak: LocalizedStringKey = "streak"
    
    var dataService = DataService()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if colorScheme == .light {
                    lightAppBackground.ignoresSafeArea()
                } else {
                    darkAppBackground.ignoresSafeArea()
                }
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            Text(streak)
                            Text("\(daysPassed)")
                            Text(days)
                        }.font(.largeTitle)
                            .padding(.bottom, 30)
                        
                        LazyVStack(spacing: 30) {
                            
                            HStack(alignment: .center) {
                                
                                Text(getCurrentDay())
                                    .font(.title2)
                                
                                Spacer()
                                ProgressBar(progressVal: progressVal, gradientColors: [Color.blue, Color.green, Color.blue], size: 70)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(25)
                    
                }.padding()
                
            }.navigationTitle("Stats")
        }.onAppear {
            getProgressValue()
            
        }
        
    }
    
    func getCurrentDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let currentDay = formatter.string(from: Date())
        return currentDay
    }
    
    func getProgressValue() {
        if completedTask {
            progressVal = 1.0
        } else if taskElements.items.count > 0 {
            progressVal = 1.0 / (Float(taskElements.items.count) + 1)
            print(progressVal)
        } else {
            progressVal = 0.0
        }
    }
    
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
