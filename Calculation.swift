//
//  Calculation.swift
//  MyCalculator
//
//  Created by Nikos Koutsolelos on 22/8/20.
//  Copyright © 2020 Nikos Koutsolelos. All rights reserved.
//

import SwiftUI

class GloableEnvirement: ObservableObject{
    
    @Published var result = "0"
    @Published var fontSize = 90
    
    var numberForamter: NumberFormatter = NumberFormatter()
    var unformattedNumber: String = "0"
    
    var activeOperation: String = ""
    var previousValue: Double = 0
    
    init() {
        self.numberForamter.usesGroupingSeparator = true
        self.numberForamter.numberStyle = .decimal
        self.numberForamter.locale = Locale.current
    }
    
    func buttonPressed( _ button: String){
        for (i,_) in Buttons.enumerated()  {
            for (j,_) in Buttons[i].enumerated() {
                if Buttons[i][j].label == button {
                    Buttons[i][j].buttonPressed()
                }
            }
        }
    }
    
    func toggleAllButtonsOff () {
        for (i,_) in Buttons.enumerated()  {
            for (j,_) in Buttons[i].enumerated() {
                Buttons[i][j].pressed = false
            }
        }
    }
    
    func FontSize(number: String) {
        switch number.count {
        case 7:
            self.fontSize = 70
        case 8:
            self.fontSize = 60
        case 9:
            self.fontSize = 50
        default:
            self.fontSize = 90
        }
    }
    
    func numberStringToDouble(number: String) -> Double {
        let numberFormatter = NumberFormatter()
            numberFormatter.number(from: number)
        
        return numberFormatter.number(from: number)?.doubleValue ?? 0
    }

    func receiveInput(Key: Key) {
        if Key.type == KeyType.Operator {
            if (Key.label != "=" && Key.label != "%" ) {
                buttonPressed(Key.label)
            }
            self.handleOperationSelection(label: Key.label)
        }else{
            switch Key.label {
                case "+/-":
                    if self.result != "0"{
                        self.unformattedNumber = self.result.contains("-") ? String((self.result).dropFirst()) : "-" + self.result
                    }
                    previousValue = numberStringToDouble(number: self.unformattedNumber)
                    self.result = formatNumber(value: self.unformattedNumber)
                case "C":
                    toggleAllButtonsOff ()
                    self.unformattedNumber = "0"
                    self.result = "0"
                    self.activeOperation = ""
                    self.previousValue = 0
                default:
                    toggleAllButtonsOff()
                    self.handleResultView(number: Key.label)
            }
        }
    }
    
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
   
//MARK: Operation Calculation
    func handleOperationSelection(label: String) {
        var calculatedValue: Double = 0
        //let currentNumber: Double = Double(unformattedNumber) ?? 0
        /*
        let numberFormatter = NumberFormatter()
            numberFormatter.number(from: unformattedNumber)
        
        let currentNumber = numberFormatter.number(from: unformattedNumber)?.doubleValue ?? 0
        */
        let currentNumber = numberStringToDouble(number: self.unformattedNumber)
        
        if ( label == "%" ){
            
            result = formatNumber(value: String((currentNumber * 0.01) * previousValue))
            
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
            
            //result = formatNumber(value: String(calculatedValue))
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
            self.FontSize(number: result)
            result = formatNumber(value: String(calculatedValue))
        }
        else
        {
            //activeOperation = label != "=" ? label : ""
            previousValue = previousValue > 0 ? previousValue : currentNumber
        }
        activeOperation = label
        unformattedNumber = "0"
    }
    
//MARK: Format Number -> String
    func formatNumber(value: String) -> String {
        var formattedValue = value
        
        if let doubleValue = Double(formattedValue){
            formattedValue = self.numberForamter.string(from: NSNumber(value: doubleValue)) ?? value
        }
        return formattedValue
    }

//MARK: BUTTONS
    @Published var Buttons: [[Key]] = [
        [ Key(label:"C", labelColor: .black, color: Color(.lightGray) ),
          Key(label:"+/-", labelColor: .black, operatorSymbols: "plus.slash.minus", color: Color(.lightGray)),
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
          Key(label: Locale.current.decimalSeparator ?? "E" ),
          Key(label:"=", operatorSymbols: "equal", color: Color.orange, type: KeyType.Operator)
        ],
    ]
}
