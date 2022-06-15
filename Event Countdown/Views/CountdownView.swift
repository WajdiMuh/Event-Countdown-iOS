//
//  ContentView.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 08/06/2022.
//

import SwiftUI

struct CountdownView: View {
    @Binding var loading:Bool
    @StateObject var countdownviewmodel:CountdownViewModel = CountdownViewModel()
    static let dateformat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/MM/yyyy, h:mm a"
        return formatter
    }()
    var body: some View {
        GeometryReader { geometry in
            List{
                HStack{
                    Spacer()
                    VStack(alignment: .leading,spacing: 10){
                        if(countdownviewmodel.event != nil){
                            Text(countdownviewmodel.event!.title)
                                .font(.system(size:30))
                                .fontWeight(.semibold)
                                .padding(.bottom)
                            Text("Date :")
                            Text("\(countdownviewmodel.event!.date, formatter: Self.dateformat)")
                            Text("Time Left :")
                            Text("Years: 0, Months: 0, Days: 0, Hours: 0, Minutes: 0, Seconds: 0")
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: 400)
                        .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    Spacer()
                }
                .frame(height: geometry.size.height - 20)
                .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .refreshable {
                await countdownviewmodel.getlatestevent()
            }
            .task {
                loading = true
                await countdownviewmodel.getlatestevent()
                loading = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // iPhone Content View
        CountdownView(loading: .constant(false))
            .previewDevice("iPhone 12")
        CountdownView(loading: .constant(false))
            .previewDevice("iPhone 12")
            .preferredColorScheme(.dark)
        // iPad Content View
        CountdownView(loading: .constant(false))
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad mini (6th generation)")
    }
}
