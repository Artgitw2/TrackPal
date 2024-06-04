//
//  PreferencesView.swift
//  Track Pal
//
//  Created by Abdulla Rayes on 17/07/2023.
//

import SwiftUI


struct CustomIcons: Hashable {
    let iconName: LocalizedStringKey
    var hashValue: Int = UUID().hashValue
    func hash(into hasher: inout Hasher) {
        hasher.combine(hashValue)
    }
}

struct SettingsElementsView: View {
    
    var selectedElement: LocalizedStringKey
    
    var dataService = DataService()
    
    @Environment (\.colorScheme) var colorScheme

    @AppStorage("active_icon") var activeIcon = "AppIcon"
    
    let customIcons =  [CustomIcons(iconName: LocalizedStringKey("light")), CustomIcons(iconName: LocalizedStringKey("dark"))]

    @AppStorage("A") var defaultLanguage = "en"
    
    var languages = ["en", "ar"]
    
    @State var languageChanged = false
    
    let languageChangeAlert: LocalizedStringKey = "languageChangeAlert"
    
    let ExitBtn: LocalizedStringKey = "ExitBtn"

    let cancel: LocalizedStringKey = "cancel"

    
    var body: some View {
        NavigationStack {
            ZStack {
                if colorScheme == .light {
                    lightAppBackground.ignoresSafeArea()
                } else {
                    darkAppBackground.ignoresSafeArea()
                }
                switch selectedElement {
               
//                case "icon":
//
//                    Picker(selection: $activeIcon) {
//
//                            ForEach(customIcons, id: \.self) { icon in
//                                Text(icon.iconName)
//                            }
//                            .onChange(of: activeIcon) { newValue in
//                                changeAppIcon(newValue)
//                                UIApplication.shared.setAlternateIconName(newValue)
//                            }
//
//                        } label: {
//
//                        }.pickerStyle(.inline)
                            
                        
                    
                    
                default:
                   
                    Picker("Select ", selection: $defaultLanguage) {
                        ForEach(languages, id:\.self) { language in
                            
                            Text(self.languageDisplayName(for: language))
                            
                        }
                    }.pickerStyle(.inline)
                        .onChange(of: defaultLanguage) { newValue in
                            languageChanged = true
                            setPreferredLanguage(newValue)
                        }
                        .alert(languageChangeAlert, isPresented: $languageChanged) {
                            Button(ExitBtn, role: .destructive) {
                                exit(0)
                            }
                            Button(cancel, role: .cancel) {
                               
                            }
                        }
                }
            }.navigationTitle(selectedElement)
        }
    }
    
    func changeAppIcon(_ iconName: String?) {
        guard let iconName = iconName else { return }

        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                print("Error changing app icon: \(error.localizedDescription)")
            } else {
                print("App icon changed successfully")
            }
        }
        UserDefaults.standard.synchronize()

    }
    
    func languageDisplayName(for language: String) -> String {
        switch language {
        case "en":
            return "English"
        case "ar":
            return "العربية"
        default:
            return "Unknown"
        }
    }
 
    func setPreferredLanguage(_ language: String) {
        UserDefaults.standard.set([language], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsElementsView(selectedElement: "Icon")
            
    }
}
