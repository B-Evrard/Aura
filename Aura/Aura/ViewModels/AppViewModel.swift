//
//  AppViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation


class AppViewModel: ObservableObject {
    @Published var isLogged: Bool
    
    
    init() {
        isLogged = false
    }
    
    lazy var authenticationViewModel: AuthenticationViewModel = {
        return AuthenticationViewModel(apiService: APIClient()) { user in
            self.isLogged = true
            self.accountDetailViewModel.user = user
            self.moneyTransferViewModel.user = user
        }
    }()
    
    lazy var accountDetailViewModel: AccountDetailViewModel = {
        return AccountDetailViewModel(apiService: APIClient())
    }()
    
    lazy var moneyTransferViewModel: MoneyTransferViewModel = {
        return MoneyTransferViewModel(apiService: APIClient())
    }()
}
