//
//  ResultView.swift
//  MyCalculator
//
//  Created by Nikos Koutsolelos on 17/8/20.
//  Copyright © 2020 Nikos Koutsolelos. All rights reserved.
//

import SwiftUI


struct ResultView: View{
    
    @EnvironmentObject var env: GloableEnvirement
    
    var body: some View{
        HStack {
            Text(env.result)
                .font(.system(size: 90))
                .fontWeight(.light)
                .lineLimit(1)
                .frame(width: CGFloat (UIScreen.main.bounds.width - 50 ), alignment: .trailing)
                .minimumScaleFactor(0.01)
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
            .environmentObject(GloableEnvirement())
    }
 }
