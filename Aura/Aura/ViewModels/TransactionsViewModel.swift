//
//  TransactionsViewModel.swift
//  Aura
//
//  Created by Bruno Evrard on 04/10/2024.
//

import Foundation

class TransactionsViewModel: ObservableObject {
    
    @Published var transactions: [Transaction]
    
    init(transactions: [Transaction]) {
        self.transactions = transactions
    }
    
    
}
