//
//  APIClient.swift
//  Aura
//
//  Created by Bruno Evrard on 20/09/2024.
//

import Foundation

final class APIClient: APIService {
    
   static let shared = APIClient()
    
    func authentication(user: User) async throws (APIError) -> User {
        let user: User = try await APIClientCore.fetchData(action: Action.auth, user: user).get()
        return user
    }
    
    func getAccount(user: User) async throws (APIError) -> Account {
        let account: Account = try await APIClientCore.fetchData(action: Action.account, user: user).get()
        return account
    }
    
    func transfer(user: User, transfer: Transfer) async throws (APIError) {
        let _: String = try await APIClientCore.fetchData(action: Action.transfer(transfer: transfer), user: user).get()
    }
    
}
    
    
    



