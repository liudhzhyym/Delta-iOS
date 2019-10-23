//
//  Power.swift
//  Delta
//
//  Created by Nathan FALLET on 13/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct Power: Token {
    
    var token: Token
    var power: Token
    
    func toString() -> String {
        return "\(token.needBrackets(for: .power) ? "(\(token.toString()))" : token.toString()) ^ \(power.needBrackets(for: .power) ? "(\(power.toString()))" : power.toString())"
    }
    
    func compute(with inputs: [String : Token], format: Bool) -> Token {
        let token = self.token.compute(with: inputs, format: format)
        let power = self.power.compute(with: inputs, format: format)
        
        // Check power
        if let number = power as? Number {
            // x^1 is x
            if number.value == 1 {
                return token
            }
        }
        if let fraction = power as? Fraction {
            // x^1/y is ^y√(x)
            if let number = fraction.inverse().compute(with: inputs, format: format) as? Number {
                return Root(token: token, power: number).compute(with: inputs, format: format)
            }
        }
        
        return token.apply(operation: .power, right: power, with: inputs, format: format)
    }
    
    func apply(operation: Operation, right: Token, with inputs: [String : Token], format: Bool) -> Token {
        // Compute right
        let right = right.compute(with: inputs, format: format)
        
        // Sum
        if operation == .addition {
            return Sum(values: [self, right])
        }
        
        // Difference
        if operation == .subtraction {
            return Sum(values: [self, right.opposite()]).compute(with: inputs, format: format)
        }
        
        // Product
        if operation == .multiplication {
            return Product(values: [self, right])
        }
        
        // Fraction
        if operation == .division {
            return Fraction(numerator: self, denominator: right)
        }
        
        // Modulo
        if operation == .modulo {
            // Return the modulo
            return Modulo(dividend: self, divisor: right)
        }
        
        // Power
        if operation == .power {
            return Power(token: token, power: Product(values: [power, right]))
        }
        
        // Root
        if operation == .root {
            return Root(token: self, power: right)
        }
        
        // Unknown, return a calcul error
        return CalculError()
    }
    
    func needBrackets(for operation: Operation) -> Bool {
        return operation.getPrecedence() >= Operation.power.getPrecedence()
    }
    
    func getMultiplicationPriority() -> Int {
        1
    }
    
    func opposite() -> Token {
        return Product(values: [self, Number(value: -1)])
    }
    
    func inverse() -> Token {
        return Fraction(numerator: Number(value: 1), denominator: self)
    }
    
    func asDouble() -> Double? {
        if let token = token.asDouble(), let power = power.asDouble() {
            return pow(token, power)
        }
        
        return nil
    }
    
    func getSign() -> FloatingPointSign {
        return .plus
    }
    
}
