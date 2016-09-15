//
//  ViewController.swift
//  Calculator
//
//  Created by Laura Chavez on 9/2/16.
//  Copyright © 2016 Laura Chavez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMidddleOfTypingANumber = false
    
    @IBOutlet weak var history: UILabel!
    
    // Clear button will clear display screen and history
    @IBAction func clear() {
        display.text = "0";
        history.text = "";
        operandStack.removeAll()
        userIsInTheMidddleOfTypingANumber = false
    }
    
    
    // Takes care of displaying digits and dot onto the screen when pressed
    @IBAction func appendDigit(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        if userIsInTheMidddleOfTypingANumber && (digit != "." || (digit == "." && display.text!.range(of: ".") == nil)){
            display.text = display.text! + digit
        }
        else{
            display.text = digit
            userIsInTheMidddleOfTypingANumber = true
        }
        appendHistory(digit);
    }
    
    // Implements all of the operators on the calculator
    @IBAction func operate(_ sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMidddleOfTypingANumber{
            enter()
        }
        switch operation {
        case "×": performOperation { $0 * $1 } // $0 ~ First off stack $1 ~ Second off stack
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        case "π":
            displayValue = M_PI
            enter()
        default:
            break;
        }
        appendHistory(operation);
    }
    
    // Adds whatever button was pressed onto the history
    func appendHistory(_ input: String){
        if history.text != nil{
            history.text = history.text! + input
        }
        else{
            history.text = input
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double){
        if operandStack.count >= 2{
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: (Double) -> Double){
        if operandStack.count >= 1{
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    // Keeps track of values entered
    var operandStack = Array<Double>();
    
    // Used to append values onto the stack
    @IBAction func enter() {
        userIsInTheMidddleOfTypingANumber = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)\n")
    }

    var displayValue: Double {
        get{
            return NumberFormatter().number(from: display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMidddleOfTypingANumber = false
        }
    }
}

