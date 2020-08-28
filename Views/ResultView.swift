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
       // VStack {
            HStack {
                Spacer()
                Text(env.result)
                    .font(.system(size: CGFloat(env.fontSize)))
                    .fontWeight(.light)
                    .lineLimit(1)
                    .font(.system(size: 70))
            }.padding()
       // }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
            .environmentObject(GloableEnvirement())
    }
 }
