//
//  AuthenticationViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    
    let onLoginSucceed: (() -> ())
    
    private let apiService: APIService
    
    
    init(apiService: APIService, _ callback: @escaping () -> ()) {
        self.onLoginSucceed = callback
        self.apiService = apiService
        
    }
    
    func login() {
        print("login with \(username) and \(password)")
        onLoginSucceed()
    }
}
