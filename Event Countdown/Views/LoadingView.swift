//
//  LoadingView.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 15/06/2022.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                ProgressView()
                    .scaleEffect(x: 2, y: 2, anchor: .center)
                Spacer()
            }
            Spacer()
        }
        .background()
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
