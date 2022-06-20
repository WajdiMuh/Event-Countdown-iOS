//
//  AddEventView.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 13/06/2022.
//

import SwiftUI

struct EditEventView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var eventlistviewmodel:EventListViewModel
    @EnvironmentObject var mainviewviewmodel: MainViewViewModel
    @State var editedevent:Event
    var body: some View {
        VStack{
            HStack{
                Text("Edit Event")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(.semibold)
                    .padding([.leading,.top])
                Spacer()
            }
            Spacer()
            TextField("Title",text: $editedevent.title)
                .disableAutocorrection(true)
                .submitLabel(.done)
                .padding(.all,5.0)
                .border(.secondary)
                .padding(.horizontal, 20.0)
            DatePickerWithTextView(selectiondate: $editedevent.date, startdate: Date.now)
            Spacer()
            HStack{
                Spacer()
                Group{
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Cancel")
                            .foregroundColor(Color.red)
                    })
                    Button(action: {
                        dismiss()
                        mainviewviewmodel.loading = true
                        Task{
                            await eventlistviewmodel.editevent(neweditedevent:editedevent)
                        }
                        mainviewviewmodel.loading = false
                    }, label: {
                        Text("Edit")
                    })
                    .disabled(editedevent.title.isEmpty)
                }
                .padding(.trailing,30.0)
                .padding(.bottom,40.0)
            }
        }
    }
}

struct EditEventView_Previews: PreviewProvider {
    static var previews: some View {
        EditEventView(eventlistviewmodel: EventListViewModel(), editedevent: Event(id:0,title:"tayy",date: Date.now))
            .previewDevice("iPhone 12")
        EditEventView(eventlistviewmodel: EventListViewModel(),editedevent: Event(id:0,title:"tayy",date: Date.now))
            .previewDevice("iPhone 12")
            .preferredColorScheme(.dark)
    }
}
