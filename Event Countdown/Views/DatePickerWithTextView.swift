//
//  DatePickerWithTextView.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 19/06/2022.
//

import SwiftUI

struct DatePickerWithTextView: View {
    @Binding var selectiondate:Date
    var startdate:Date
    static let dateformat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy, h:mm a"
        return formatter
    }()
    var body: some View {
        VStack{
            DatePicker("Date", selection: $selectiondate, in: startdate...)
                .datePickerStyle(.graphical)
                .labelsHidden()
                .padding(.horizontal, 20.0)
            Text("Selected Date: \(selectiondate, formatter: Self.dateformat)")
        }
    }
}

struct DatePickerWithTextView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerWithTextView(selectiondate: .constant(Date.now.addingTimeInterval(86400)), startdate: Date.now)
    }
}
