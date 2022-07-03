//
//  EventListView.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 08/06/2022.
//

import SwiftUI

struct EventlistView: View {
    @State private var showaddevent = false
    @EnvironmentObject var mainviewviewmodel: MainViewViewModel
    @State var editedevent:Event?
    @StateObject var eventlistviewmodel:EventListViewModel
    @EnvironmentObject var countdownviewmodel: CountdownViewModel
    static let dateformat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy, h:mm a"
        return formatter
    }()
    
    init(viewmodel: EventListViewModel = EventListViewModel()){
        _eventlistviewmodel = StateObject(wrappedValue: viewmodel)
    }
    
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
                            mainviewviewmodel.loading = true
                            Task{
                                do{
                                    try await eventlistviewmodel.deleteevent(deletedevent: event)
                                }catch LoadError.fetchFailed {
                                    mainviewviewmodel.eventdeletefailed()
                                }catch {
                                    
                                }
                            }
                            mainviewviewmodel.loading  = false
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
                        mainviewviewmodel.chosenmenu = "countdown"
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
            do{
                try await eventlistviewmodel.getallevents()
            }catch LoadError.fetchFailed {
                mainviewviewmodel.eventsfetchfailed()
            }catch {
                
            }
        }
        .task {
            mainviewviewmodel.loading = true
            countdownviewmodel.receivedevent = nil
            do{
                try await eventlistviewmodel.getallevents()
                mainviewviewmodel.loading = false
            }catch LoadError.fetchFailed {
                mainviewviewmodel.eventsfetchfailed()
                mainviewviewmodel.loading = false
            }catch {
                
            }
        }
    }
}

struct EventListView_Previews: PreviewProvider {
    static let mainviewmodel = MainViewViewModel()
    static let countdownviewmodel = CountdownViewModel()
    static let eventlistviewmodel = { () -> EventListViewModel in
        let testviewmodel:EventListViewModel = EventListViewModel()
        testviewmodel.events = [Event(id: 0, title: "Test", date: Date.now),Event(id: 1, title: "Test 1", date: Date.now.addingTimeInterval(86400))]
        return testviewmodel
    }()
    static let eventlistview = EventlistView(viewmodel: eventlistviewmodel)

    static var previews: some View {
        return Group{
            eventlistview
                .previewDevice("iPhone 12")
                .environmentObject(mainviewmodel)
                .environmentObject(countdownviewmodel)
            
            eventlistview
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
                .environmentObject(mainviewmodel)
                .environmentObject(countdownviewmodel)

            eventlistview
                .previewDevice("iPad mini (6th generation)")
                .preferredColorScheme(.dark)
                .previewInterfaceOrientation(.landscapeLeft)
                .environmentObject(mainviewmodel)
                .environmentObject(countdownviewmodel)
        }
    }
}
