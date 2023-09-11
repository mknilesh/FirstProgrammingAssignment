//
//  DashboardView.swift
//  FirstProgrammingAssignment
//
//  Created by Nilesh Manivannan on 9/10/23.
//

import SwiftUI
import Firebase
import FinnhubSwift

struct DashboardView: View {
    @Binding var loggedIn: Bool
    @State var stockData: Quote?
    @State var selectedStock: String = ""
    @State var timestamp: String = ""
    
    var body: some View {
        if loggedIn {
            dashboard
        } else {
            ContentView()
        }
    }
    
    var dashboard : some View {
        NavigationStack {
            VStack {
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
                
                TextField("Enter a Stock Symbol", text: $selectedStock)
                Button(action: {
                    getStockData()
                }, label: {
                    Text("Get Quote for Stock")
                        .frame(width: 200, height:50)
                        .foregroundColor(Color.white)
                        .background(Color.black)
                })
                .padding()
                
                if let stockQuote = stockData {
                    Text("Timestamp : " + timestamp)
                    Text("Current Price : " + stockQuote.current.description);
                    Text("Open Price of the Day : " + stockQuote.open.description);
                    Text("High Price of the Day : " + stockQuote.high.description);
                    Text("Low Price of the Day : " + stockQuote.low.description);
                    Text("Previous Close Price : " + stockQuote.previousClose.description);
                }
            }
        }
    }
    
    private func getStockData() {
        FinnhubClient.quote(symbol: selectedStock) { result in
            switch result {
            case let .success(data):
                self.stockData = data
                let date = Date(timeIntervalSince1970: Double(data.timestamp))
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "EST")
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "h:mm a 'on' MMMM dd, yyyy"
                dateFormatter.amSymbol = "AM"
                dateFormatter.pmSymbol = "PM"
                self.timestamp = dateFormatter.string(from: date)
            case .failure(.invalidData):
                print("Invalid data")
            case let .failure(.networkFailure(error)):
                print(error)
            }
        }
    }
}

//struct DashboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardView()
//    }
//}
