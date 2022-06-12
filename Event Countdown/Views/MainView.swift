//
//  MainView.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 08/06/2022.
//

import SwiftUI

struct MainView: View {
    @State var menuvisible:Bool = false
    @State var chosenmenu:String = "countdown"
    var body: some View {
        ZStack{
            switch(chosenmenu){
                case "countdown":
                    CountdownView()
                        .allowsHitTesting(!menuvisible)
                case "eventlist":
                    EventlistView()
                        .allowsHitTesting(!menuvisible)
                default:
                    CountdownView()
                        .allowsHitTesting(!menuvisible)

            }
            VStack{
                HStack{
                    Button(action:{
                        withAnimation {
                            menuvisible.toggle()
                        }
                    })
                    {
                        Image(systemName: "text.justify")
                            .resizable(resizingMode: .stretch)
                            .foregroundColor(Color("Flipdarkmode"))
                    }
                    .frame(width: 30, height: 20)
                        .offset(x: 20,y: 40)
                    Spacer()
                }
                Spacer()
            }
            if(menuvisible){
                SideMenuView(menuvisible: $menuvisible, chosenmenu: $chosenmenu).transition(.move(edge: .leading)).zIndex(1)
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
