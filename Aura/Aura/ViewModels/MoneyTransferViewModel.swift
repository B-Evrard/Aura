//
//  MoneyTransferViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class MoneyTransferViewModel: ObservableObject {
    
    @Published var recipient: String = ""
    @Published var amount: String = ""
    @Published var transferMessage: String = ""
    
    private let apiService: APIService
    
    var user: User?
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    @MainActor
    func sendMoney() async {
        
        do {
            try control()
        } catch {
            transferMessage = error.message
            return
        }
        
        do {
            guard let user else {
                transferMessage = "Utilisateur deconnecté"
                return
            }
            let transfer = Transfer(recipient: recipient, amount: amount)
            try await apiService.transfer(user: user, transfer: transfer)
        } catch let error {
            transferMessage = error.message
            return
        }
        transferMessage = "Successfully transferred \(amount) to \(recipient)"
        
    }
    
    private func control() throws (TransferError) {
        
        do {
            try validateEmail(recipient)
        } catch {
            do {
                try validateFrenchPhoneNumber(recipient)
            } catch {
                throw TransferError.invalidRecipient()
            }
        }
        
        if (amount.isEmpty) {
            throw TransferError.amountEmpty()
        }
        
        guard let _ = Double(amount) else {
            throw TransferError.invalidAmount()
        }
    }
    
    func raz() {
        recipient = ""
        amount = ""
        transferMessage = ""
    }
}
