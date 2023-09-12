//
//  ContentView.swift
//  FirstProgrammingAssignment
//
//  Created by Nilesh Manivannan on 9/9/23.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State var email = ""
    @State var pass = ""
    @State var loggedIn = false
    @State var error = ""
    
    var body: some View {
        if loggedIn {
            DashboardView(loggedIn: $loggedIn)
        } else {
            logInPage
        }
    }
    
    var logInPage: some View {
        NavigationView {
            VStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200)
                VStack {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    SecureField("Password", text: $pass)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    
                    Button(action: {
                        signin()
                    }, label: {
                        Text("Sign In")
                            .frame(width: 200, height:50)
                            .foregroundColor(Color.white)
                            .background(Color.black)
                    })
                    .padding()
                    
                    Button(action: {
                        register()
                    }, label: {
                        Text("Create an account")
                            .frame(width: 200, height:50)
                            .foregroundColor(Color.white)
                            .background(Color.black)
                    })
                }
                .padding()
                if error != "" {
                    VStack {
                        Divider()
                        Text(error)
                            .foregroundStyle(.red)
                            .frame(width: 300)
                        Divider()
                    }
                }
                Spacer()
            }
            .onAppear{
                Auth.auth().addStateDidChangeListener {auth, user in
                    if user != nil {
                        loggedIn = true
                    }
                }
            }
        }
    }
    
    func signin() {
        Auth.auth().signIn(withEmail: email, password: pass) {result, error in
            if error != nil {
                self.error = error!.localizedDescription
                print(error!.localizedDescription)
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: pass) { result, error in
            if error != nil {
                self.error = error!.localizedDescription
                print(error!.localizedDescription)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
