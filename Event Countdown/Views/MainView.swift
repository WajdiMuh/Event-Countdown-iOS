//
//  MainView.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 08/06/2022.
//

import SwiftUI

struct MainView: View {
    @State var menuvisible:Bool = false
    @State var loading:Bool = true
    @State var chosenmenu:String = "countdown"
    var body: some View {
        ZStack{
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
                    .padding([.leading,.top])
                    Spacer()
                }
                ZStack{
                    switch(chosenmenu){
                        case "countdown":
                        CountdownView(loading: $loading)
                                .allowsHitTesting(!menuvisible)
                        case "eventlist":
                        EventlistView(loading: $loading)
                                .allowsHitTesting(!menuvisible)
                        default:
                        CountdownView(loading: $loading)
                                .allowsHitTesting(!menuvisible)
                    }
                    if(loading){
                        LoadingView()
                    }
                }
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
