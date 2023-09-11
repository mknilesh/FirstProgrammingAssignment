//
//  DashboardView.swift
//  FirstProgrammingAssignment
//
//  Created by Nilesh Manivannan on 9/10/23.
//

import SwiftUI
import Firebase

struct DashboardView: View {
    @Binding var loggedIn : Bool
    
    var body: some View {
        if loggedIn {
            dashboard
        } else {
            ContentView()
        }
    }
    
    var dashboard : some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button(action: {
                do {
                    try Auth.auth().signOut()
                    self.loggedIn.toggle()
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
            }, label: {
                Text("Log Out")
                    .frame(width: 200, height:50)
                    .foregroundColor(Color.white)
                    .background(Color.black)
            })
            .padding()
        }
    }
}

//
//struct DashboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardView()
//    }
//}
