//
//  AppViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation


class AppViewModel: ObservableObject {
    @Published var isLogged: Bool
    @Published var user: User?
    
    init() {
        isLogged = false
    }
    
    var authenticationViewModel: AuthenticationViewModel {
        return AuthenticationViewModel(apiService: APIClient()) { user in
            self.isLogged = true
            self.user = user
        }
    }
    
    var accountDetailViewModel: AccountDetailViewModel {
        return AccountDetailViewModel(apiService: APIClient(),user: self.user!)
    }
}
