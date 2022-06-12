//
//  ContentView.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 08/06/2022.
//

import SwiftUI

struct CountdownView: View {
    var body: some View {
        GeometryReader { geometry in
            List{
                HStack{
                    Spacer()
                    VStack(alignment: .leading,spacing: 10){
                        Text("Title")
                            .font(.system(size:30))
                            .fontWeight(.semibold)
                            .padding(.bottom)
                        Text("Date :")
                        Text("dd/mm/yyyy, 00:00 am")
                        Text("Time Left :")
                        Text("Years: 0, Months: 0, Days: 0, Hours: 0, Minutes: 0, Seconds: 0")
                    }
                    .padding(20)
                    .frame(maxWidth: 400)
                        .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    Spacer()
                }
                .frame(height: geometry.size.height - 60)
                .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .listRowSeparator(.hidden)
            }
            .padding(.top,60)
            .listStyle(.plain)
            .refreshable {
                print("countdown")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // iPhone Content View
        CountdownView()
            .previewDevice("iPhone 12")
        CountdownView()
            .previewDevice("iPhone 12")
            .preferredColorScheme(.dark)
        // iPad Content View
        CountdownView()
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad mini (6th generation)")
    }
}
