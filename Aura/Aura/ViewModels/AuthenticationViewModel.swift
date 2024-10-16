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
    
    @Published var user: User?
    
    let onLoginSucceed: ((User) -> Void)
    
    private let apiService: APIService
    
    init(apiService: APIService, _ callback: @escaping (User) -> Void) {
        self.onLoginSucceed = callback
        self.apiService = apiService
    }
    
    @MainActor
    func login() async {
        self.messageAlert = ""
        
        do {
            try control()
        } catch {
            messageAlert = error.message
            return
        }
        self.user = User(username: username, password: password, token: "")
        do {
            guard let user else { return }
            let userConnected = try await apiService.authentication(user: user)
            onLoginSucceed(
                userConnected )
            
        } catch {
            messageAlert = error.message
            return
        }
        
    }
    
    
    private func control() throws(LoginError) {
        do {
            try validateEmail(username)
        }
        catch {
            switch error {
            case .mailEmpty:
                throw LoginError.mailEmpty()
            case .invalidFormatMail:
                throw LoginError.invalidFormatMail()
            default :
                throw LoginError.genericError()
            }
        }
        
        if password.isEmpty {
            throw LoginError.passwordEmpty()
        }
        
        
    }
    
}
