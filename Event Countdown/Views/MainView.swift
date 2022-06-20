//
//  MainView.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 08/06/2022.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var mainviewviewmodel: MainViewViewModel
    @StateObject var countdownviewmodel:CountdownViewModel = CountdownViewModel()
    //TODO: Add local notifications
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
                            await countdownviewmodel.getlatestevent()
                            countdownviewmodel.calculatetimediff()
                            mainviewviewmodel.loading = false
                        }
                    }
                    mainviewviewmodel.chosenmenu = menuitem
                })
                .transition(.move(edge: .leading)).zIndex(1)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(MainViewViewModel())
            .previewDevice("iPhone 12")
        MainView()
            .environmentObject(MainViewViewModel())
            .previewDevice("iPhone 12")
            .preferredColorScheme(.dark)
        MainView()
            .environmentObject(MainViewViewModel())
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad mini (6th generation)")
    }
}
