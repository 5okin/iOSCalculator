//
//  Calculation.swift
//  MyCalculator
//
//  Created by Nikos Koutsolelos on 22/8/20.
//  Copyright © 2020 Nikos Koutsolelos. All rights reserved.
//

import SwiftUI

class GloableEnvirement: ObservableObject{
    
//MARK: Gloable Variables
    @Published var result = "0"
    
    var numberForamter: NumberFormatter = NumberFormatter()
    var unformattedNumber: String = "0"
    
    var activeOperation: String = ""
    var previousValue: Double = 0
    
    
    init(){
        self.numberForamter.usesGroupingSeparator = true
        self.numberForamter.numberStyle = .decimal
        self.numberForamter.locale = Locale.current
    }
    
    
    
//MARK: Receive Button From KeyPad
    func receiveInput(Key: Key) {
        if Key.type == KeyType.Operator {
            if (Key.label != "=" && Key.label != "%"){
                operatorToggle("")
                operatorToggle(Key.label)
            }
            handleOperationSelections(label: Key.label)
        }
        else if Key.type == KeyType.Modifier{
            handleModifierOperations(label: Key.label)
        }
        else {
            switch Key.label {
            case "C":
                operatorToggle("")
                self.result = "0"
                self.activeOperation = ""
                self.previousValue = 0
                self.unformattedNumber = "0"
            default:
                operatorToggle("")
                self.handleResultView(number: Key.label)
            }
        }
    }
    
    func handleModifierOperations(label: String){
        switch label {
        case "+/-":
            if self.result != "0"{
                self.unformattedNumber = self.result.contains("-") ? String((self.result).dropFirst()) : "-" + self.result
            }
        default:
            break
        }
        self.result = formatNumber(value: self.unformattedNumber)
    }
    
    
//MARK: Operations
    func handleOperationSelections(label: String){
        var calculatedValue: Double = 0
        let currentNumber: Double = Double(unformattedNumber) ?? 0
        
        if ( label == "%" ){
            result = formatNumber(value: String((currentNumber * 0.01) * (previousValue == 0 ? 1 : previousValue)  ))
            calculatedValue = Double(result)!
            
            switch activeOperation {
            case "-":
                calculatedValue = previousValue > 0 ? previousValue - ( (currentNumber * 0.01) * previousValue ) : currentNumber * 0.01
            case "+":
                calculatedValue = previousValue > 0 ? previousValue + ( (currentNumber * 0.01) * previousValue ) : currentNumber * 0.01
            case "*":
                calculatedValue = previousValue > 0 ? previousValue * ( currentNumber * 0.01 ) : currentNumber * 0.01
            case "/":
                calculatedValue = previousValue > 0 ? previousValue / ( currentNumber * 0.01)  : currentNumber * 0.01
            default:
                break
            }
            activeOperation = ""
            previousValue = calculatedValue
        }
        
        if (activeOperation != "") {
            switch activeOperation {
                case "+":
                    calculatedValue = previousValue + currentNumber
                case "-":
                    calculatedValue = previousValue - currentNumber
                case "*":
                    calculatedValue = previousValue * currentNumber
                case "/":
                    calculatedValue = previousValue > 0 ? previousValue / currentNumber : 0
                default:
                    calculatedValue = previousValue
            }
            previousValue = calculatedValue
            result = formatNumber(value: String(calculatedValue))
        }
        else
        {
            previousValue = previousValue > 0 ? previousValue : currentNumber
        }
        activeOperation = label != "%" ? label : ""
        unformattedNumber = "0"
    }
    
    
//MARK: ResultView Handler
    func handleResultView(number: String) {
        if (self.unformattedNumber.count == 0 || self.unformattedNumber.count < 9){
            if number != Locale.current.decimalSeparator {
                self.unformattedNumber = self.unformattedNumber == "0" ? number: self.unformattedNumber + number
                self.result = formatNumber(value: self.unformattedNumber)
            }else{
                self.unformattedNumber = self.result.contains(String(Locale.current.decimalSeparator!)) ? self.result : self.result + number
                self.result = self.unformattedNumber
            }
        }
    }
    
    
//MARK: Add Locale Separator to result view number
    func formatNumber(value: String) -> String {
        if let doubleValue = Double(value){
            return self.numberForamter.string(from: NSNumber(value: doubleValue)) ?? value
        }
        return value
    }
    
        
//MARK: Operator Button Toggle
    func operatorToggle( _ button: String ){
        for (i,_) in Buttons.enumerated()  {
            for (j,_) in Buttons[i].enumerated() {
                if button.isEmpty {
                    Buttons[i][j].pressed = false
                } else {
                     if Buttons[i][j].label == button {
                         Buttons[i][j].buttonPressed()
                     }
                }
            }
        }
    }

    
//MARK: BUTTONS
    @Published var Buttons: [[Key]] = [
        [ Key(label:"C", labelColor: .black, color: Color(.lightGray) ),
          Key(label:"+/-", labelColor: .black, operatorSymbols: "plus.slash.minus", color: Color(.lightGray), type: KeyType.Modifier),
          Key(label:"%", labelColor: .black, operatorSymbols: "percent", color: Color(.lightGray), type: KeyType.Operator),
          Key(label:"/", operatorSymbols: "divide", color: Color.orange , type: KeyType.Operator)
        ],
        [ Key(label:"7"),
          Key(label:"8"),
          Key(label:"9"),
          Key(label:"*", operatorSymbols: "multiply", color: Color.orange, type: KeyType.Operator)
        ],
        [ Key(label:"4"),
          Key(label:"5"),
          Key(label:"6"),
          Key(label:"-", operatorSymbols: "minus", color: Color.orange, type: KeyType.Operator)
        ],
        [ Key(label:"1"),
          Key(label:"2"),
          Key(label:"3"),
          Key(label:"+", operatorSymbols: "plus", color: Color.orange, type: KeyType.Operator)
        ],
        [ Key(label:"0", width: (UIScreen.main.bounds.width - 4 * 12) / 4 * 2),
          Key(label: Locale.current.decimalSeparator ?? "L"),
          Key(label:"=", operatorSymbols: "equal", color: Color.orange, type: KeyType.Operator)
        ],
    ]
}
