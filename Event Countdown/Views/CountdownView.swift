//
//  ContentView.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 08/06/2022.
//

import SwiftUI
import UserNotifications

struct CountdownView: View {
    @EnvironmentObject var mainviewviewmodel: MainViewViewModel
    static let dateformat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy, h:mm a"
        return formatter
    }()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @EnvironmentObject var countdownviewmodel: CountdownViewModel
    
    func makelocalnotification(event: Event?){
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        if let event = event {
            let content = UNMutableNotificationContent()
            content.title = "Upcoming Event"
            content.subtitle = event.title
            content.sound = UNNotificationSound.default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: event.date.timeIntervalSinceNow, repeats: false)

            let request = UNNotificationRequest(identifier: String(event.id), content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request)
        }
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            List{
                HStack{
                    Spacer()
                    if(countdownviewmodel.event != nil){
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
                                        if(!mainviewviewmodel.loading){
                                            countdownviewmodel.calculatetimediff()
                                            if(countdownviewmodel.difference.second! < 0){
                                                mainviewviewmodel.loading = true
                                                Task{
                                                    do{
                                                        try await countdownviewmodel.getlatestevent()
                                                        makelocalnotification(event: countdownviewmodel.event)
                                                    }catch LoadError.fetchFailed {
                                                        mainviewviewmodel.latesteventfetchfailed()
                                                        makelocalnotification(event: nil)
                                                    }catch{
                                                        
                                                    }
                                                }
                                                countdownviewmodel.calculatetimediff()
                                                mainviewviewmodel.loading = false
                                            }
                                        }
                                    }
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: 400)
                            .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    }
                    Spacer()
                }
                .frame(height: geometry.size.height - 20)
                .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .refreshable {
                if(countdownviewmodel.receivedevent == nil){
                    do{
                        try await countdownviewmodel.getlatestevent()
                        makelocalnotification(event: countdownviewmodel.event)
                    }catch LoadError.fetchFailed {
                        mainviewviewmodel.latesteventfetchfailed()
                        makelocalnotification(event: nil)
                    }catch{
                        
                    }
                    countdownviewmodel.calculatetimediff()
                }else{
                    countdownviewmodel.event = countdownviewmodel.receivedevent
                    countdownviewmodel.calculatetimediff()
                }
            }
            .task {
                if(countdownviewmodel.receivedevent == nil){
                    mainviewviewmodel.loading = true
                    do{
                        try await countdownviewmodel.getlatestevent()
                        makelocalnotification(event: countdownviewmodel.event)
                        mainviewviewmodel.loading = false
                    }catch LoadError.fetchFailed {
                        mainviewviewmodel.latesteventfetchfailed()
                        makelocalnotification(event: nil)
                        mainviewviewmodel.loading = false
                    }catch{
                        
                    }
                    countdownviewmodel.calculatetimediff()
                }else{
                    countdownviewmodel.calculatetimediff()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let countdownview = CountdownView()
    static let mainviewmodel = MainViewViewModel()
    static let countdownviewmodel = { () -> CountdownViewModel in
        let testviewmodel:CountdownViewModel = CountdownViewModel()
        testviewmodel.event = Event(id: 0, title: "Test", date: Date.now)
        return testviewmodel
    }()

    static var previews: some View {
        Group{
            // iPhone Content View
            countdownview
                .environmentObject(mainviewmodel)
                .environmentObject(countdownviewmodel)
                .previewDevice("iPhone 12")
            countdownview
                .environmentObject(mainviewmodel)
                .environmentObject(countdownviewmodel)
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)

            // iPad Content View
            countdownview
                .environmentObject(mainviewmodel)
                .environmentObject(countdownviewmodel)
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDevice("iPad mini (6th generation)")
        }
    }
}
