//
//  Key.swift
//  MyCalculator
//
//  Created by Nikos Koutsolelos on 23/8/20.
//  Copyright © 2020 Nikos Koutsolelos. All rights reserved.
//

import SwiftUI

enum KeyType{
    case Number
    case Operator
    case Modifier
 }

struct Key: Identifiable, Hashable {

     var id: UUID = UUID()
     var pressed: Bool = false
     var label: String
     var labelColor: Color = .white
     var operatorSymbols: String = ""
     var color: Color = Color(.darkGray)
     var type: KeyType = KeyType.Number
     var width: CGFloat = (UIScreen.main.bounds.width - 5 * 12) / 4
    
     mutating func buttonPressed() {
        self.pressed.toggle()
    }
 }
