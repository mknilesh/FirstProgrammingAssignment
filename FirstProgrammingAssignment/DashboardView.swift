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
    @State var stockText: String = ""
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
                HStack(alignment: .center) {
                    Text("Stock Symbol:")
                        .font(.callout)
                    TextField("Enter a stock symbol...", text: $stockText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }.padding()

                    if let stockQuote = stockData {
                        if stockQuote.timestamp > 0 {
                            VStack {
                                Divider()
                                HStack(spacing: 10) {
                                    Text("Timestamp : ")
                                        .frame(width: 100, alignment: .leading)
                                    Spacer()
                                        .frame(width: 25.0)
                                    Text(timestamp)
                                        .multilineTextAlignment(.trailing)
                                        .frame(width: 175, alignment: .trailing)
                                }
                                Divider()
                                HStack(spacing: 10) {
                                    Text("Current Price : ")
                                        .frame(width: 100, alignment: .leading)
                                    Spacer()
                                        .frame(width: 25.0)
                                    Text(stockQuote.current.description)
                                        .frame(width: 175, alignment: .trailing)
                                }
                                Divider()
                                HStack(spacing: 10) {
                                    Text("Open Price of the Day : ")
                                        .frame(width: 100, alignment: .leading)
                                    Spacer()
                                        .frame(width: 25.0)
                                    Text(stockQuote.open.description)
                                        .frame(width: 175, alignment: .trailing)
                                }
                            }
                            VStack {
                                Divider()
                                HStack(spacing: 10) {
                                    Text("High Price of the Day : ")
                                        .frame(width: 100, alignment: .leading)
                                    Spacer()
                                        .frame(width: 25.0)
                                    Text(stockQuote.high.description)
                                        .frame(width: 175, alignment: .trailing)
                                }
                                Divider()
                                HStack(spacing: 10) {
                                    Text("Low Price of the Day : ")
                                        .frame(width: 100, alignment: .leading)
                                    Spacer()
                                        .frame(width: 25.0)
                                    Text(stockQuote.low.description)
                                        .frame(width: 175, alignment: .trailing)
                                }
                                Divider()
                                HStack(spacing: 10) {
                                    Text("Previous Close Price : ")
                                        .frame(width: 100, alignment: .leading)
                                    Spacer()
                                        .frame(width: 25.0)
                                    Text(stockQuote.previousClose.description)
                                        .frame(width: 175, alignment: .trailing)
                                }
                                Divider()
                            }
                        } else {
                            Divider()
                            Text("No stock quote for " + selectedStock)
                            Divider()
                        }
                    }
                }
                
                Button(action: {
                    getStockData()
                }, label: {
                    Text("Get Quote")
                        .frame(width: 200, height:50)
                        .foregroundColor(Color.white)
                        .background(Color.black)
                })
                .padding()
            
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Log Out") {
                            do {
                                try Auth.auth().signOut()
                                self.loggedIn.toggle()
                            } catch let signOutError as NSError {
                                print("Error signing out: %@", signOutError)
                            }
                        }
                    }
                }
            }
        }
    private func getStockData() {
        self.selectedStock = stockText
        FinnhubClient.quote(symbol: stockText) { result in
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
