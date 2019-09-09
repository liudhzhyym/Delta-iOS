//
//  SyntaxError.swift
//  Delta
//
//  Created by Nathan FALLET on 07/09/2019.
//  Copyright © 2019 Nathan FALLET. All rights reserved.
//

import Foundation

struct SyntaxError: Token, Error {
    
    func toString() -> String {
        return "error_syntax".localized()
    }
    
    func compute(with inputs: [Input]) -> Token {
        return self
    }
    
    func apply(operation: Operation, right: Token, with inputs: [Input]) -> Token {
        return self
    }
    
    func getSign() -> FloatingPointSign {
        return .plus
    }
    
    func changedSign() -> Bool {
        return false
    }
    
}
