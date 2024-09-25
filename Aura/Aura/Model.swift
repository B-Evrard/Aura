//
//  Model.swift
//  Aura
//
//  Created by Bruno Evrard on 20/09/2024.
//

import Foundation

struct User {
    var username: String
    var password: String
    var token: String
}

struct Account: Codable {
    
    var totalAmount: Double
    var transactions: [Transaction]
    
    var totalAmountFormatted: String {
        totalAmount.formattedTotalAmountFrench()
        
    }
    
    enum CodingKeys : String, CodingKey {
          case totalAmount = "currentBalance"
          case transactions
    }
    
}

struct Transaction: Codable {
    var description: String
    var amount: Double
    
    var amountFormatted: String {
        amount.formattedAmountFrench()
        
    }
    
    enum CodingKeys : String, CodingKey {
          case description = "label"
          case amount = "value"
    }
}
