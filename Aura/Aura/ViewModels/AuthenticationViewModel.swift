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
    
    @Published var isAlert = false
    @Published var messageAlert: String = ""
    
    @Published var user = User(username: "",password: "",token: "")
    
    let onLoginSucceed: ((User) -> Void)
    
    private let apiService: APIService
    
    
    init(apiService: APIService, _ callback: @escaping (User) -> Void) {
        self.onLoginSucceed = callback
        self.apiService = apiService
    }
    
    @MainActor
    func login() async {
        
        self.isAlert = false
        self.user.username = username
        self.user.password = password
        do {
            self.user = try await apiService.authentication(user: user)
        } catch let error as APIError {
            isAlert = true
            switch error {
            case .authenticationFailed :
                messageAlert = "Authentification invalide"
                
            default : messageAlert = "Une erreur est survenue"
            }
            return
        } catch {
            isAlert = true
            messageAlert = "Une erreur est survenue"
        }
        onLoginSucceed(user)
        
        
        
       
        
    }
}
