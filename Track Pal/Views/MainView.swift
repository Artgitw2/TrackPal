//
//  ContentView.swift
//  Track Pal
//
//  Created by Abdulla Rayes on 14/07/2023.
//

import SwiftUI

struct MainView: View {
    
    @State private var selectedItem = 1
    @State var sheetVisible = false
    
    let tasks: LocalizedStringKey = "Tasks"
    let boa: LocalizedStringKey = "BOA"
    let stats: LocalizedStringKey = "Stats"
    let settings: LocalizedStringKey = "Settings"



    
    var body: some View {
        
            
            TabView (selection: $selectedItem) {
                
                
                TasksView()
                    .tabItem {
                        Image("task")
                        Text(tasks)
                        
                    }
                    .tag(1)
                
                
                BoardOfAchievementsView()
                    .tabItem {
                        Image("boa")
                        Text(boa)
                        
                    }.tag(2)
                
                StatsView()
                
                    .tabItem {
                        Image("stats")
                        Text(stats)
                        
                        
                    }.tag(4)
                
                SettingsView()
                    .tabItem {
                        Image("settings")
                        Text(settings)
                        
                        
                    }.tag(5)
            }
            .tint(.green)
            
            
            .onAppear(perform: {
                // this is for iOS 16
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithDefaultBackground()
                
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                
            })
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
           
    }
}
