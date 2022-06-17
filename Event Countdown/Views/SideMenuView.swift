//
//  SideMenuView.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 09/06/2022.
//

import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var mainviewviewmodel: MainViewViewModel
    @EnvironmentObject var countdownviewmodel: CountdownViewModel
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0){
                List {
                    Group{
                        Button("Countdown"){
                            if(countdownviewmodel.receivedevent != nil){
                                countdownviewmodel.receivedevent = nil
                                Task{
                                    mainviewviewmodel.loading = true
                                    await countdownviewmodel.getlatestevent()
                                    countdownviewmodel.calculatetimediff()
                                    mainviewviewmodel.loading = false
                                }
                            }
                            mainviewviewmodel.chosenmenu = "countdown"
                            withAnimation(.easeIn(duration: 0.3)){
                                mainviewviewmodel.menuvisible.toggle()
                            }
                        }
                        Divider()
                            .frame(height:1)
                            .background(Color("Flipdarkmode"))
                        Button("Event List"){
                            mainviewviewmodel.chosenmenu = "eventlist"
                            withAnimation(.easeIn(duration: 0.3)){
                                mainviewviewmodel.menuvisible.toggle()
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading:10, bottom: 0, trailing: 12))
                    .listRowSeparator(.hidden)
                    .foregroundColor(Color("Flipdarkmode"))
                }
                .environment(\.defaultMinListRowHeight, 30)
                .padding(.top,40)
                .frame(width: min(geometry.size.width * 0.45, 300), height: nil)
                .listStyle(.plain)
                .background(Color(UIColor.secondarySystemBackground))
                .overlay(
                    Rectangle()
                        .frame(width: 2, height: UIScreen.main.bounds.size.height, alignment: .trailing)
                        .foregroundColor(Color("Flipdarkmode")), alignment: .trailing)
                Button(action: {
                    withAnimation(.easeIn(duration: 0.3)){
                        mainviewviewmodel.menuvisible.toggle()
                    }
                }, label: {
                    Text("").frame( maxWidth:.infinity,maxHeight:.infinity)
                })
            }
        }
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView()
            .previewDevice("iPhone 12")
        SideMenuView()
            .previewDevice("iPhone 12")
            .preferredColorScheme(.dark)
    }
}
