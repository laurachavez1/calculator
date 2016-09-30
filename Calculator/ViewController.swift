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
    
    // Takes care of displaying digits and dot onto the screen when pressed
    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        if userIsInTheMidddleOfTypingANumber && (digit != "." || (digit == "." && display.text!.rangeOfString(".") == nil)){
            display.text = display.text! + digit
        }
        else{
            display.text = digit
            userIsInTheMidddleOfTypingANumber = true
            history.text = brain.description != "?" ? brain.description : ""
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
                displayValue = nil
            }
        }
    }
    
    // Clear button will clear display screen and history
    @IBAction func clear() {
        brain = CalculatorBrain();
        display.text = "0";
        history.text = " ";
    }
    
    // Used to append values onto the stack
    @IBAction func enter() {
        userIsInTheMidddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue!){
            displayValue = result
        }
        else{
            displayValue = nil
        }
    }
    
    // Used to set variable M (-->M)
    @IBAction func setVariable(sender: UIButton) {
        // Gets last character of string, just want 'M'
        if let variableM = sender.currentTitle!.characters.last {
            // If there is something is in the display then set the value
            if displayValue != nil {
                brain.variableValues["\(variableM)"] = displayValue
                if let result = brain.evaluate() {
                    displayValue = result
                } else {
                    displayValue = nil
                }
            }
        }
    }
    
    // Used to get the value of 'M'
    @IBAction func getVariable(sender: UIButton) {
        // Make sure enter is pressed
        if userIsInTheMidddleOfTypingANumber {
            enter()
        }
        // Get the 'M' value and evaluate it
        if let result = brain.pushOperand(sender.currentTitle!) {
            displayValue = result
        } else {
            displayValue = nil
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
            }
            // if value is nil then clear the display
            else{
                display.text = "0"
                history.text = " ";
            }
            userIsInTheMidddleOfTypingANumber = false
            history.text = brain.description + " ="
        }
    }
}

