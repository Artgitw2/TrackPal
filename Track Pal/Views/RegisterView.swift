//
//  RegisterView.swift
//  Track Pal
//
//  Created by Abdulla Rayes on 06/08/2023.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    @Environment (\.colorScheme) var colorScheme
    
    @State var name: String = ""
    
    @State var email: String = ""
    
    @State var password: String = ""
    
    @State var sthEmpty = false
    
    @Environment (\.dismiss) var dismiss
    
    @State var showErr = false
    
    @State var errName = ""
    
    @AppStorage("log_status") var logStatus = false
    @AppStorage("user_name") var userNameStored = ""
    
    @StateObject var taskElements = TaskElements()
    
    @StateObject var databaseTasks = TaskFModel(id: UUID().uuidString, currentUserID: UUID().uuidString)
    
    let emailPrompt: LocalizedStringKey = "emailPrompt"

    let passwordPrompt: LocalizedStringKey = "passwordPrompt"
    
    let registerNow: LocalizedStringKey = "registerNow"
    
    let accountExistsPrompt: LocalizedStringKey = "accountExistsPrompt"

    let signIn: LocalizedStringKey = "signIn"

    
    var body: some View {
        
        if !logStatus {
            NavigationStack {
                ZStack {
                    if colorScheme == .light {
                        lightAppBackground.ignoresSafeArea()
                    } else {
                        darkAppBackground.ignoresSafeArea()
                    }
                    VStack (spacing: 20) {
                        Spacer()
                        TextField("Enter your name", text: $name)
                            .inputStyle()
                        
                        TextField(emailPrompt, text: $email)
                            .inputStyle()
                        SecureField(passwordPrompt, text: $password)
                            .inputStyle()
                        
                        
                        Button {
                            registerUser()
                            
                        } label: {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.white)
                                    .frame(height: 70)
                                Text(registerNow)
                                    .foregroundColor(.blue)
                                    .font(.headline)
                            }.cornerRadius(20)
                        }.disableWithOpacity(name == "" || email == "" || password == "" )
                        
                        
                        Spacer()
                        
                        HStack {
                            
                            Text(accountExistsPrompt)
                            
                            
                            Button(signIn) {
                                
                                dismiss()
                                
                            }.font(.callout)
                                .tint(.white)
                            
                        }
                        
                    }.padding()
                    
                }.navigationTitle(registerNow)
                
            }.alert(errName, isPresented: $showErr) {}
        } else {
            MainView()
        }
    }
    
    func registerUser() {
        Task {
            do {
             
                // Create a new Firebase account
                try await Auth.auth().createUser(withEmail: email, password: password)
                
                // Get the currentUserID from the registered user
                guard let userID = Auth.auth().currentUser?.uid else {
                    print("Failed to retrieve currentUserID")
                    
                    return
                }
                                
                // Save the user data to Firestore
                let user = User(name: name, email: email, password: password)
                try Firestore.firestore().collection("Users").document(userID).setData(from: user) { error in
                    if let error = error {
                        print("Error saving user data: \(error.localizedDescription)")
                    } else {
                        print("User data saved successfully")
                        userNameStored = name
                        logStatus = true
                    }
                }
            } catch {
                try await Auth.auth().currentUser?.delete()
                print("ERROR:\(error.localizedDescription)")
            }
        }
    }

}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

extension View {
    func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1.0)
        
    }
}
