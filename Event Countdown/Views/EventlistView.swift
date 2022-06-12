//
//  EventListView.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 08/06/2022.
//

import SwiftUI

struct EventlistView: View {
    var body: some View {
        List{
            Section(header:
                        Text("Events")
                .font(.system(size: 20))
                .fontWeight(.heavy)
                .foregroundColor(Color("Flipdarkmode"))
            ) {
                ForEach((1...3),id: \.self){ event in
                    HStack{
                        VStack(alignment: .leading, spacing: 1){
                            Text("Title")
                            Text("dd/mm/yyyy, 00:00 am")
                        }
                        .contentShape(Rectangle())
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        print("event clicked")
                    }
                }
                .swipeActions(edge: .trailing,allowsFullSwipe: false) {
                    Button {
                        print("delete event")
                    } label: {
                        Label("Delete", systemImage: "minus.circle")
                    }
                    .tint(Color.red)
                    Button {
                        print("edit event")
                    } label: {
                        Label("Edit", systemImage: "slider.horizontal.3")
                    }
                    .tint(Color(red: 0.96, green: 0.75, blue: 0.0))
                }
                
                HStack{
                    Spacer()
                    Button(action: {
                        print("add event")
                    }) {
                        Image(systemName: "plus.circle")
                            .resizable(resizingMode: .stretch)
                            .foregroundColor(Color.green)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: 20, height: 20)
                    Spacer()
                }
            }
        }
        .environment(\.editMode, .constant(.inactive))
        .listStyle(.plain)
        .refreshable {
            print("event list")
        }
        .padding(.top,60)
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventlistView()
            .previewDevice("iPhone 12")
        EventlistView()
            .previewDevice("iPhone 12")
            .preferredColorScheme(.dark)
        EventlistView()
            .previewDevice("iPad mini (6th generation)")
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
