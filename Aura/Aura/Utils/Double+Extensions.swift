//
//  Double+Extensions.swift
//  Aura
//
//  Created by Bruno Evrard on 25/09/2024.
//

import Foundation

extension Double {
    
    func formattedAmountFrench() -> String {
        
        let formatter = NumberFormatter().formatterFR
        
        return (self > 0 ? "+" : "") + formatter.string(from: NSNumber(value:self))! + " €"
    }
    
    func formattedTotalAmountFrench() -> String {
        let formatter = NumberFormatter().formatterFR
        
        return formatter.string(from: NSNumber(value:self))! + " €"
    }
}

extension NumberFormatter {
    var formatterFR: NumberFormatter {
        self.usesGroupingSeparator = true
        self.groupingSeparator = " "
        self.numberStyle = .decimal
        self.locale = Locale(identifier: "fr_FR")
        
        return self
    }
}
