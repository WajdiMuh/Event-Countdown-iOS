//
//  EventListView.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 08/06/2022.
//

import SwiftUI

struct EventlistView: View {
    @State private var showaddevent = false
    @State var editedevent:Event?
    @Binding var loading:Bool
    @Binding var chosenmenu:String
    @StateObject var eventlistviewmodel:EventListViewModel = EventListViewModel()
    @EnvironmentObject var countdownviewmodel: CountdownViewModel
    static let dateformat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/MM/yyyy, h:mm a"
        return formatter
    }()
    var body: some View {
        List{
            Section(header:
                        Text("Events")
                .font(.system(size: 20))
                .fontWeight(.heavy)
                .foregroundColor(Color("Flipdarkmode"))
            ) {
                ForEach(eventlistviewmodel.events){ event in
                    HStack{
                        VStack(alignment: .leading, spacing: 1){
                            Text(event.title)
                            Text("\(event.date, formatter: Self.dateformat)")
                        }
                        .contentShape(Rectangle())
                        Spacer()
                    }
                    .swipeActions(edge: .trailing,allowsFullSwipe: false) {
                        Button {
                            eventlistviewmodel.deleteevent(deletedevent: event)
                        } label: {
                            Label("Delete", systemImage: "minus.circle")
                        }
                        .tint(Color.red)
                        Button {
                            editedevent = event
                        } label: {
                            Label("Edit", systemImage: "slider.horizontal.3")
                        }
                        .tint(Color(red: 0.96, green: 0.75, blue: 0.0))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        countdownviewmodel.receivedevent = event
                        countdownviewmodel.event = event
                        chosenmenu = "countdown"
                    }
                }
                
                HStack{
                    Spacer()
                    Button(action: {
                        showaddevent.toggle()
                    }) {
                        Image(systemName: "plus.circle")
                            .resizable(resizingMode: .stretch)
                            .foregroundColor(Color.green)
                    }
                    .sheet(isPresented: $showaddevent) {
                        AddEventView(eventlistviewmodel: eventlistviewmodel)
                            }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: 20, height: 20)
                    Spacer()
                }
            }
        }
        .sheet(item: $editedevent, content: { event in
            EditEventView( eventlistviewmodel: eventlistviewmodel, editedevent: event)
        })
        .environment(\.editMode, .constant(.inactive))
        .listStyle(.plain)
        .refreshable {
            await eventlistviewmodel.getallevents()
        }
        .task {
            loading = true
            countdownviewmodel.receivedevent = nil
            await eventlistviewmodel.getallevents()
            loading = false
        }
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventlistView(loading: .constant(false), chosenmenu: .constant("eventlist"))
            .previewDevice("iPhone 12")
        EventlistView(loading: .constant(false), chosenmenu: .constant("eventlist"))
            .previewDevice("iPhone 12")
            .preferredColorScheme(.dark)
        EventlistView(loading: .constant(false), chosenmenu: .constant("eventlist"))
            .previewDevice("iPad mini (6th generation)")
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
