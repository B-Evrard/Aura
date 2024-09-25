//
//  AccountDetailViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class AccountDetailViewModel: ObservableObject {
    @Published var totalAmount: String = ""
    @Published var recentTransactions: [Transaction]
    
    
    @Published var isAlert = false
    @Published var messageAlert: String = ""
    
    private let apiService: APIService
    
    var user: User
    var account: Account?
    
    init(apiService: APIService, user: User) {
        self.user = user
        self.apiService = apiService
        self.account = nil
        self.recentTransactions = []
    }
    
    @MainActor
    func getAccount() async {
        do {
            self.account = try await apiService.getAccount(user: user)
            self.totalAmount = account!.totalAmountFormatted
            self.recentTransactions = Array(account!.transactions.prefix(3))
            
        } catch let error as APIError {
            self.isAlert = true
            switch error {
            case .unauthorized :
                messageAlert = "Opération non autorisée"
                
            default : messageAlert = "Une erreur est survenue"
            }
            return
        } catch {
            self.isAlert = true
            messageAlert = "Une erreur est survenue"
        }
    }
    
}
