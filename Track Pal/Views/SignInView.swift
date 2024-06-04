//
//  SignUpView.swift
//  Track Pal
//
//  Created by Abdulla Rayes on 04/08/2023.
//

import SwiftUI
import Firebase

struct SignInView: View {
    
    @Environment (\.colorScheme) var colorScheme
    
    @State var email: String = ""
    
    @State var password: String = ""
    
    @State var sthEmpty = false
    
    @State var createAcc = false
    
    @State var showErr = false
    
    @State var errName = ""
    
    @AppStorage("log_status") var logStatus = false
    
    @ObservedObject var taskElements = TaskElements()
    
    let emailPrompt: LocalizedStringKey = "emailPrompt"
    
    let passwordPrompt: LocalizedStringKey = "passwordPrompt"
    
    let resetPasswordPrompt: LocalizedStringKey = "resetPasswordPrompt"
    
    let signIn: LocalizedStringKey = "signIn"
    
    let accountMissingPrompt: LocalizedStringKey = "accountMissingPrompt"
    
    let registerNow: LocalizedStringKey = "registerNow"
    
    @AppStorage("numOfDays") var daysPassed = 0
    
    
    var body: some View {
        if !logStatus {
            NavigationStack {
                ZStack {
                    BackgroundView()
                    
                    
                    VStack (spacing: 20) {
                        Spacer()
                        TextField(emailPrompt, text: $email)
                            .inputStyle()
                        SecureField(passwordPrompt, text: $password)
                            .inputStyle()
                        
                        
                        Button(resetPasswordPrompt) {
                            resetUser()
                        }.font(.callout)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .tint(.white)
                        
                        Button {
                            loginUser()
                            
                        } label: {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.white)
                                    .frame(height: 70)
                                Text(signIn)
                                    .foregroundColor(.blue)
                                    .font(.headline)
                            }.cornerRadius(20)
                            
                        }
                        
                        Spacer()
                        
                        HStack {
                            
                            Text(accountMissingPrompt)
                            
                            
                            Button(registerNow) {
                                createAcc.toggle()
                            }.font(.callout)
                                .tint(.white)
                            
                        }
                        
                    }.padding()
                    
                    
                }.navigationTitle(signIn)
            }.alert("Please fill in your name or password or both", isPresented: $sthEmpty) {
                Button("OK") {
                    
                }
            }
            .fullScreenCover(isPresented: $createAcc, content: {
                RegisterView()
            })
            .alert(errName, isPresented: $showErr) {
                
            }
        } else {
            MainView()
        }
    }
    
    func loginUser() {
        Task {
            try await Auth.auth().signIn(withEmail: email, password: password)
            
            do {
            
                if let userID = Auth.auth().currentUser?.uid {
                    try await Firestore.firestore().collection("Users").document(userID).collection("Tasks").getDocuments(source: .server)
                    logStatus = true
                    
                    fetchUser()
                    
                    print("user found")
                } else {
                    print("User ID is nil")
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func resetUser() {
        Task {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: email)
                print("link sent")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func setErr(_ error: Error) async {
        await MainActor.run(body: {
            errName = error.localizedDescription
            showErr.toggle()
        })
    }
    
    func fetchUser() {
        Task {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            print(userID)
            
            do {
                let fetchedTasks = try await Firestore.firestore().collection("Users").document(userID).collection("Tasks").getDocuments(source: .server)
                
                // fetched user tasks
                let userTasks = fetchedTasks.documents.compactMap { document in
                    // Extract data from the document and create a TaskElement instance
                    let id = document.documentID
                    let taskText = document["text"] as? String ?? ""
                    let startedTimePicked = document["startTime"] as? Date ?? Date()
                    let finishedTimePicked = document["finishTime"] as? Date ?? Date()
                    
                    return TaskElement(id: id, taskText: taskText, startedTimePicked: startedTimePicked, finishedTimePicked: finishedTimePicked)
                }
                
                DispatchQueue.main.async {
                    taskElements.items = userTasks
                }
                
                
                let fetchedDayStreak = try await Firestore.firestore().collection("Users").document(userID).collection("DayStreaks").getDocuments(source: .server)
                
                // fetched day streaks
                if let document = fetchedDayStreak.documents.first {
                    let dayStreak = document["numOfDayStreaks"] as? Int ?? 0
                    daysPassed = dayStreak
                }
                
                
                
                print(taskElements.items)
                print(daysPassed)
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

extension View {
    func inputStyle() -> some View {
        self
            .padding()
            .background(.thinMaterial)
            .cornerRadius(10)
    }
}
