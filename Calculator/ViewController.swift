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
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMidddleOfTypingANumber = false
    var brain = CalculatorBrain()
    
    // Clear button will clear display screen and history
    @IBAction func clear() {
        brain = CalculatorBrain();
        display.text = "0";
        history.text = " ";
    }
    
    // Takes care of displaying digits and dot onto the screen when pressed
    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        if userIsInTheMidddleOfTypingANumber && (digit != "." || (digit == "." && display.text!.rangeOfString(".") == nil)){
            display.text = display.text! + digit
        }
        else{
            display.text = digit
            userIsInTheMidddleOfTypingANumber = true
            history.text = brain.showStack()
        }
    }
    
    // Implements all of the operators on the calculator
    @IBAction func operate(sender: UIButton) {
        //let operation = sender.currentTitle!
        if userIsInTheMidddleOfTypingANumber{
            enter()
        }
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation){
                displayValue = result
            }
            else{
                displayValue = 0;
            }
        }
    }
    
    // Adds whatever button was pressed onto the history
    func appendHistory(input: String){
        if history.text != nil{
            history.text = history.text! + input
        }
        else{
            history.text = input
        }
    }
    
    // Used to append values onto the stack
    @IBAction func enter() {
        userIsInTheMidddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue!){
            displayValue = result
        }
        else{
            displayValue = 0
        }
    }

    private var displayValue: Double? {
        get{
//            return NumberFormatter().number(from: display.text!)!.doubleValue
            
            // If there is text and text can be tranlated to double return the value
            // otherwise nil
            if let text = display.text, let value = Double(text){
                return value
            }
            else{
                return nil
            }
        }
        set{
            if let value = newValue{
                display.text = "\(value)"
                history.text = brain.showStack()
            }
            // if value is nil then clear the display
            else{
                display.text = "0"
                history.text = " ";
            }
            userIsInTheMidddleOfTypingANumber = false
            let stack = brain.showStack()
            if !stack!.isEmpty {
                history.text = stack! + " ="
            }
    
        }
    }
}

