//
//  AuraService.swift
//  Aura
//
//  Created by Bruno Evrard on 20/09/2024.
//

import Foundation

protocol APIService {
    
    
    func authentication(user: User) async throws (APIError) -> User
    
    func getAccount(user: User) async throws (APIError) -> Account
    
    func transfer(user: User, transfer: Transfer) async throws (APIError)
    
}
