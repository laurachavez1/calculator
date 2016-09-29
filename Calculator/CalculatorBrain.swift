//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Laura Chavez on 9/21/16.
//  Copyright © 2016 Laura Chavez. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    private enum Op: CustomStringConvertible{
        
        case Operand(Double)
        case ConstantOperation(String, () -> Double)
        case UnaryOperation(String, (Double) -> Double)
        case BinaryOperation(String, (Double,Double) -> Double)
        case Variable(String)
        
        var description: String{
            get{
                switch self {
                case .ConstantOperation(let symbol, _):
                    return symbol
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .Variable(let symbol):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    // Initializing a dictionary, same thing as Dictionary<String, Op>
    private var knownOps = [String:Op]()
    
    var variableValues: Dictionary<String,Double>
    
    init(){
        func learnOp (op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷", { $1 / $0 }))
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−", { $1 - $0 }))
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.ConstantOperation("π", {M_PI}))
    }
    
    // Using a tuple to return the result and the stack with remaining operations/operands
    // When you pass a value that is not a class, it is copied(passed by value)
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        if !ops.isEmpty{
            var remainingOps = ops                  // Swift doesn't make copies until it is actually mutated
            let op = remainingOps.removeLast()
            
            switch op{
            case .Operand(let operand):
                return(operand, remainingOps)
            case .ConstantOperation(_, let operation):
                return (operation(), remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return(operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evalutation = evaluate(remainingOps)
                if let operand1 = op1Evalutation.result{
                    let op2Evaluation = evaluate(op1Evalutation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return(operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .Variable(let symbol):
                return(variableValues[symbol], remainingOps)
            }
        }
        return(nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result,_) = evaluate(opStack)
        return result
    }
    
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    // Pushing a variable onto the stack
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?{
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
    // Used for the history label
    func showStack() -> String? {
        return opStack.map{ "\($0)" }.joinWithSeparator(" ")
    }
}
