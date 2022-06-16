//
//  ContentView.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 08/06/2022.
//

import SwiftUI

struct CountdownView: View {
    @Binding var loading:Bool
    static let dateformat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy, h:mm a"
        return formatter
    }()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @EnvironmentObject var countdownviewmodel: CountdownViewModel
    var body: some View {
        GeometryReader { geometry in
            List{
                HStack{
                    Spacer()
                    HStack{
                        VStack(alignment: .leading,spacing: 10){
                            Text(countdownviewmodel.event?.title ?? "Title")
                                .font(.system(size:30))
                                .fontWeight(.semibold)
                                .padding(.bottom)
                            Text("Date :")
                            Text("\(countdownviewmodel.event?.date ?? Date.now, formatter: Self.dateformat)")
                            Text("Time Left :")
                            Text("Years: \(countdownviewmodel.difference.year ?? 0), Months: \(countdownviewmodel.difference.month ?? 0), Days: \(countdownviewmodel.difference.day ?? 0), Hours: \(countdownviewmodel.difference.hour ?? 0), Minutes: \(countdownviewmodel.difference.minute ?? 0), Seconds: \(countdownviewmodel.difference.second ?? 0)")
                                .onReceive(timer) { time in
                                    if(!loading){
                                        countdownviewmodel.calculatetimediff()
                                        if(countdownviewmodel.difference.second! <= 0){
                                            loading = true
                                            Task{
                                                await countdownviewmodel.getlatestevent()
                                            }
                                            countdownviewmodel.calculatetimediff()
                                            loading = false
                                        }
                                    }
                                }
                        }
                        Spacer()
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
                if(countdownviewmodel.receivedevent == nil){
                    await countdownviewmodel.getlatestevent()
                    countdownviewmodel.calculatetimediff()
                }else{
                    countdownviewmodel.event = countdownviewmodel.receivedevent
                    countdownviewmodel.calculatetimediff()
                }
            }
            .task {
                if(countdownviewmodel.receivedevent == nil){
                    loading = true
                    await countdownviewmodel.getlatestevent()
                    countdownviewmodel.calculatetimediff()
                    loading = false
                }else{
                    countdownviewmodel.calculatetimediff()
                }
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
