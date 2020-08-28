//
//  ContentView.swift
//  MyCalculator
//
//  Created by Nikos Koutsolelos on 17/8/20.
//  Copyright © 2020 Nikos Koutsolelos. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        ZStack ( alignment: .bottom ){
            Color.black.edgesIgnoringSafeArea(.all)
            VStack (spacing: 12){
                Spacer()
                ResultView()
                Keypad()
                .padding(.bottom)
                .preferredColorScheme(.dark)
            }
        }.preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(GloableEnvirement())
    }
}
