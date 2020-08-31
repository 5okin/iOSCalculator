//
//  Keypad.swift
//  MyCalculator
//
//  Created by Nikos Koutsolelos on 17/8/20.
//  Copyright © 2020 Nikos Koutsolelos. All rights reserved.
//

import SwiftUI

struct Keypad: View{
    
    @EnvironmentObject var env: GloableEnvirement
    //@State private var operatorButtonTapped: Bool = false
    
    var body: some View{
        VStack ( spacing: 12 ) {
            ForEach (env.Buttons, id: \.self) { row in
                HStack () {
                    ForEach ( row, id: \.self) { button in
                        Button(action: {
                            self.env.receiveInput(Key: button)
                            //self.env.operatorPressed = button.label
                            /*if button.type == KeyType.Operator {
                                self.env.buttonPressed(button.label)
                            }*/
                        }) {
                            Group{
                                if !button.operatorSymbols .isEmpty {
                                    Image(systemName: button.operatorSymbols )
                                        .font(.system(size: 30))
                                }else{
                                    Text("\(button.label)")
                                    .font(.system(size: 37))
                                    .padding(.trailing, button.label == "0" ? 100  : 0)
                                }
                            }
                            .frame(
                                width: button.width,
                                height: (UIScreen.main.bounds.width - 5 * 12) / 4
                            )
                            //.background(button.color)
                            //.foregroundColor(button.labelColor)
                            .foregroundColor(button.pressed ? button.color : button.labelColor)
                            .background (button.pressed ? button.labelColor : button.color)
                            .cornerRadius(button.width)
                        }
                    }
                }
            }
        }
    }
}

struct Keypad_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Keypad()
                .environmentObject(GloableEnvirement())
        }
    }
}

