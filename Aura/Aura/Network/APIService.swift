//
//  AuraService.swift
//  Aura
//
//  Created by Bruno Evrard on 20/09/2024.
//

import Foundation

protocol APIService {
    
    func authentication(user: User) async throws -> User
    
    func getAccount(user: User) async throws -> Account
    
}
