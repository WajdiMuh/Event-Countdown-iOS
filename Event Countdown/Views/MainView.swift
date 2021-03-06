//
//  MainView.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 08/06/2022.
//

import SwiftUI
import AlertToast
import UserNotifications

struct MainView: View {
    @EnvironmentObject var mainviewviewmodel: MainViewViewModel
    @StateObject var countdownviewmodel:CountdownViewModel
    
    init(viewmodel: CountdownViewModel = CountdownViewModel()){
        _countdownviewmodel = StateObject(wrappedValue: viewmodel)
    }
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button(action:{
                        withAnimation(.easeOut(duration: 0.3)){
                            mainviewviewmodel.menuvisible.toggle()
                        }
                    })
                    {
                        Image(systemName: "text.justify")
                            .resizable(resizingMode: .stretch)
                            .foregroundColor(Color("Flipdarkmode"))
                    }
                    .frame(width: 30, height: 20)
                    .padding([.leading,.top])
                    Spacer()
                }
                ZStack{
                    switch(mainviewviewmodel.chosenmenu){
                        case "Countdown":
                        CountdownView()
                            .allowsHitTesting(!mainviewviewmodel.menuvisible)
                        case "Event List":
                        EventlistView()
                            .allowsHitTesting(!mainviewviewmodel.menuvisible)
                        default:
                        CountdownView()
                            .allowsHitTesting(!mainviewviewmodel.menuvisible)
                    }
                    LoadingView(Loading: $mainviewviewmodel.loading)
                }
                .environmentObject(countdownviewmodel)
            }
            .toast(isPresenting: $mainviewviewmodel.showtoast){
                AlertToast(displayMode: .banner(.pop), type: .error(.red), title: mainviewviewmodel.toastmessege)
            }
            .gesture(
                DragGesture(minimumDistance: 30, coordinateSpace: .local)
                    .onEnded({ drag in
                        if(drag.startLocation.x < 30 && drag.translation.width > 40){
                            withAnimation(.easeOut(duration: 0.3)){
                                mainviewviewmodel.menuvisible.toggle()
                            }
                        }
                    })
            )
            SideMenuView(items: ["Countdown","Event List"], menuvisible: $mainviewviewmodel.menuvisible)
                .onMenuItemSelected({ menuitem in
                    if(menuitem == "Countdown" && countdownviewmodel.receivedevent != nil){
                        countdownviewmodel.receivedevent = nil
                        Task{
                            mainviewviewmodel.loading = true
                            do{
                                try await countdownviewmodel.getlatestevent()
                            }catch LoadError.fetchFailed {
                                mainviewviewmodel.latesteventfetchfailed()
                            }catch{
                                
                            }
                            countdownviewmodel.calculatetimediff()
                            mainviewviewmodel.loading = false
                        }
                    }
                    mainviewviewmodel.chosenmenu = menuitem
                })
                .transition(.move(edge: .leading)).zIndex(1)
        }.task {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static let mainviewmodel = { () -> MainViewViewModel in
        let testviewmodel:MainViewViewModel = MainViewViewModel()
        testviewmodel.loading = false
        testviewmodel.showtoast = false
        return testviewmodel
    }()
    static let countdownviewmodel =  { () -> CountdownViewModel in
        let testviewmodel:CountdownViewModel = CountdownViewModel()
        testviewmodel.event = Event(id: 0, title: "Test", date: Date.now)
        testviewmodel.receivedevent = Event(id: 0, title: "Test", date: Date.now)
        return testviewmodel
    }()
    static let mainview = MainView(viewmodel: countdownviewmodel)
    static var previews: some View {
        Group{
            mainview
                .environmentObject(mainviewmodel)
                .previewDevice("iPhone 12")
            mainview
                .environmentObject(mainviewmodel)
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
            mainview
                .environmentObject(mainviewmodel)
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDevice("iPad mini (6th generation)")
        }
    }
}
