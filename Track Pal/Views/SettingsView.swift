


import SwiftUI
import Firebase

struct SettingsView: View {
    @State var settingsElements: [Settings] = [Settings]()
    var dataService = DataService()
    
    @State private var showConfirmationDialog = false // New state variable
        
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("log_status") var logStatus = false
    
    let signOut: LocalizedStringKey = "signOut"

    let cancel: LocalizedStringKey = "cancel"
    
    let signOutPrompt: LocalizedStringKey = "signOutPrompt"

    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()

                ScrollView {
                    ForEach(settingsElements) { element in
                        Section {
                            VStack (spacing: 1) {
                                NavigationLink {
                                    SettingsElementsView(selectedElement: element.navLink1)
                                } label: {
                                    Text(element.navLink1)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(.thinMaterial)
                                }
//                                NavigationLink {
//                                    SettingsElementsView(selectedElement: element.navLink2)
//                                } label: {
//                                    Text(element.navLink2)
//                                        .padding()
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                        .background(.thinMaterial)
//                                }
                            }.cornerRadius(25)
                        } header: {
                            Text(element.label)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .tint(.secondary)
                .padding()
            }
            .navigationTitle("Settings")
            .toolbar {
                Button {
                    showConfirmationDialog = true // Show the confirmation dialog when the "Sign out" button is clicked
                } label: {
                    Text(signOut)
                        .foregroundColor(.white)
                }
            }
        }
        .toolbarColorScheme(.light, for: .automatic)
        .onAppear {
            settingsElements = dataService.getSettingsData()
        }
        .confirmationDialog(signOutPrompt, isPresented: $showConfirmationDialog) { // Use the new state variable
            Button(signOut, role: .destructive) {
                do {
                    try Auth.auth().signOut()
                    
                    logStatus = false
                    print("signed out successfully")
                    print(Auth.auth().currentUser?.uid ?? "")

                } catch {
                    print(error.localizedDescription)
                }
            }
            
            Button(cancel, role: .cancel) { }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
