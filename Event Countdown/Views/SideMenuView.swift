//
//  SideMenuView.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 09/06/2022.
//

import SwiftUI

struct SideMenuView: View {
    var menuitemselected: (String) -> Void = {_ in }
    var items: [String] = []
    @Binding var menuvisible:Bool
    var body: some View {
        if(menuvisible){
            GeometryReader { geometry in
                HStack(spacing: 0){
                    List {
                        ForEach(Array(items.enumerated()), id: \.element){ index, element in
                            Group{
                                Button(element){
                                    menuitemselected(element)
                                    withAnimation(.easeIn(duration: 0.3)){
                                        menuvisible.toggle()
                                    }
                                }
                                if(index != (items.count - 1)){
                                    Divider()
                                        .frame(height:1)
                                        .background(Color("Flipdarkmode"))
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 0, leading:10, bottom: 0, trailing: 12))
                            .listRowSeparator(.hidden)
                            .foregroundColor(Color("Flipdarkmode"))
                        }
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
                            menuvisible.toggle()
                        }
                    }, label: {
                        Text("").frame( maxWidth:.infinity,maxHeight:.infinity)
                    })
                }
            }
        }
    }
    func onMenuItemSelected(_ callback: @escaping (String) -> Void) -> Self {
        var copy = self
        copy.menuitemselected = callback
        return copy
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(items: ["Test item one","Test item two","Test item three"], menuvisible: .constant(true))
            .previewDevice("iPhone 12")
        SideMenuView(items: ["Test item one","Test item two"], menuvisible: .constant(true))
            .previewDevice("iPhone 12")
            .preferredColorScheme(.dark)
    }
}
