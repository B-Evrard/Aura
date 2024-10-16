//
//  MockApiClient.swift
//  Aura
//
//  Created by Bruno Evrard on 09/10/2024.
//

import Foundation

final class MockApiClient: APIService {
    
    var session: MockUrlSession
    var apiClientCore: APIClientCore {
        APIClientCore(session: session)
    }
    
    init(session: MockUrlSession) {
        self.session = session
    }
    
    func authentication(user: User) async throws (APIError) -> User {
        let user: User = try await apiClientCore.fetchData(action: Action.auth, user: user).get()
        return user
    }
    
    func getAccount(user: User) async throws (APIError) -> Account {
        let account: Account = try await apiClientCore.fetchData(action: Action.account, user: user).get()
        return account
    }
    
    func transfer(user: User, transfer: Transfer) async throws (APIError) {
        let _: String = try await apiClientCore.fetchData(action: Action.transfer(transfer: transfer), user: user).get()
    }
}
