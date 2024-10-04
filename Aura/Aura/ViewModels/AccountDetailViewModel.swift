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
    
    @Published var messageAlert: String = ""
    
    private let apiService: APIService
    
    var user: User?
    var account: Account?
    
    init(apiService: APIService) {
        self.apiService = apiService
        self.account = nil
        self.recentTransactions = []
    }
    
    @MainActor
    func getAccount() async {
        self.messageAlert = ""
        guard let user else { return }
        do {
            self.account = try await apiService.getAccount(user: user)
            self.totalAmount = account?.totalAmountFormatted ?? ""
            self.recentTransactions = Array(account?.transactions.prefix(3) ?? [])
            
        } catch {
            messageAlert = error.message
            return
        }
    }
    
    var isAlert: Bool {
        get {return !messageAlert.isEmpty}
        set {}
    }
    
    
}
