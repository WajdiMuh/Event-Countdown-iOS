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
                        case "countdown":
                        CountdownView()
                            .allowsHitTesting(!mainviewviewmodel.menuvisible)
                        case "eventlist":
                        EventlistView()
                            .allowsHitTesting(!mainviewviewmodel.menuvisible)
                        default:
                        CountdownView()
                            .allowsHitTesting(!mainviewviewmodel.menuvisible)
                    }
                    if(mainviewviewmodel.loading){
                        LoadingView()
                    }
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
            if(mainviewviewmodel.menuvisible){
                SideMenuView().transition(.move(edge: .leading)).zIndex(1).environmentObject(countdownviewmodel)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewDevice("iPhone 12")
        MainView()
            .previewDevice("iPhone 12")
            .preferredColorScheme(.dark)
        MainView()
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad mini (6th generation)")
    }
}
