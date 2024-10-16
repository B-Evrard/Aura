//
//  AccountDetailViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation
import SwiftUICore

class AccountDetailViewModel: ObservableObject {
    @Published var totalAmount: String = ""
    @Published var recentTransactions: [Transaction]
    
    @Published var messageAlert: String = "" {
        didSet {
            if messageAlert.isEmpty {
                showAlert = false
            }
            else {
                showAlert = true
            }
        }
    }
    @Published var showAlert: Bool = false
    @Published var viewTransaction: Bool = false
    
    private let apiService: APIService
    
    var user: User?
    var account: Account?
    var allTransactions: [Transaction]?
    
    init(apiService: APIService) {
        self.apiService = apiService
        self.account = nil
        self.recentTransactions = []
    }
    
    @MainActor
    func getAccount() async {
        self.messageAlert = ""
        guard let user else {
            messageAlert = APIError.genericError().message
            return }
        self.viewTransaction = false
        do {
            self.account = try await apiService.getAccount(user: user)
            self.totalAmount = account?.totalAmountFormatted ?? ""
            self.recentTransactions = Array(
                account?.transactions?.prefix(3) ?? [])
            self.allTransactions = account?.transactions
        } catch {
            messageAlert = error.message
            return
        }
    }
}
