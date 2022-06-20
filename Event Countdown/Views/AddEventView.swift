//
//  AddEventView.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 13/06/2022.
//

import SwiftUI
import AlertToast

struct AddEventView: View {
    @Environment(\.dismiss) var dismiss
    @State var title:String = ""
    @State var date:Date = Date.now
    @ObservedObject var eventlistviewmodel:EventListViewModel
    @EnvironmentObject var mainviewviewmodel: MainViewViewModel
    var body: some View {
        VStack{
            HStack{
                Text("Add Event")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(.semibold)
                    .padding([.leading,.top])
                Spacer()
            }
            Spacer()
            TextField("Title",text: $title)
                .disableAutocorrection(true)
                .submitLabel(.done)
                .padding(.all,5.0)
                .border(.secondary)
                .padding(.horizontal, 20.0)
            DatePickerWithTextView(selectiondate: $date, startdate: Date.now)
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
                            await eventlistviewmodel.addevent(title: title, date: date)
                        }
                        mainviewviewmodel.loading = false
                    }, label: {
                        Text("Add")
                    })
                    .disabled(title.isEmpty)
                }
                .padding(.trailing,30.0)
                .padding(.bottom,40.0)
            }
        }
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView(eventlistviewmodel: EventListViewModel())
            .environmentObject(MainViewViewModel())
            .previewDevice("iPhone 12")
        AddEventView(eventlistviewmodel: EventListViewModel())
            .environmentObject(MainViewViewModel())
            .previewDevice("iPhone 12")
            .preferredColorScheme(.dark)
    }
}
