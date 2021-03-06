//
//  Root.swift
//  Delta
//
//  Created by Nathan FALLET on 13/10/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct Root: Token {
    
    var token: Token
    var power: Token
    
    func toString() -> String {
        return "√(\(token.toString()))"
    }
    
    func compute(with inputs: [String : Token], format: Bool) -> Token {
        let token = self.token.compute(with: inputs, format: format)
        let power = self.power.compute(with: inputs, format: format)
        
        return token.apply(operation: .root, right: power, with: inputs, format: format)
    }
    
    func apply(operation: Operation, right: Token, with inputs: [String : Token], format: Bool) -> Token {
        // Compute right
        let right = right.compute(with: inputs, format: format)
        
        // Power
        if operation == .power {
            // Check if power is the same
            if let right = right as? Number, let power = power as? Number, right.value == power.value {
                // Undo the root
                return token
            }
            
            return Power(token: self, power: right)
        }
        
        // Root
        if operation == .root {
            return Root(token: token, power: Product(values: [power, right]).compute(with: inputs, format: format))
        }
        
        // Delegate to default
        return defaultApply(operation: operation, right: right, with: inputs, format: format)
    }
    
    func needBrackets(for operation: Operation) -> Bool {
        return false
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
            return pow(token, 1/power)
        }
        
        return nil
    }
    
    func getSign() -> FloatingPointSign {
        return .plus
    }
    
}
