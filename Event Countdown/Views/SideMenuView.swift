//
//  SideMenuView.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 09/06/2022.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var menuvisible:Bool
    @Binding var chosenmenu:String
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0){
                List {
                    Group{
                        Button("Countdown"){
                            chosenmenu = "countdown"
                            withAnimation{
                                menuvisible.toggle()
                            }
                        }
                        Divider()
                            .frame(height:1)
                            .background(Color("Flipdarkmode"))
                        Button("Event List"){
                            chosenmenu = "eventlist"
                            withAnimation{
                                menuvisible.toggle()
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
                    withAnimation{
                        menuvisible.toggle()
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
        SideMenuView(menuvisible: .constant(false), chosenmenu: .constant("countdown"))
            .previewDevice("iPhone 12")
        SideMenuView(menuvisible: .constant(false), chosenmenu: .constant("countdown"))
            .previewDevice("iPhone 12")
            .preferredColorScheme(.dark)
    }
}
