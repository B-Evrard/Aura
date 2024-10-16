//
//  Action.swift
//  Aura
//
//  Created by Bruno Evrard on 03/10/2024.
//

import Foundation


enum Action  {
    case auth
    case account
    case transfer (transfer: Transfer)
    
    var httpMethod: HTTPMethod {
        switch self {
        case .auth: return .POST
        case .account: return .GET
        case .transfer: return .POST
        }
    }
    
    var toTransfer: Transfer? {
        if case .transfer(let transfer) = self { return transfer } else { return nil }
    }
    
    var api: URL {
        switch self {
        case .auth: return Environment.baseURL.appendingPathComponent("auth")
        case .account: return Environment.baseURL.appendingPathComponent("account")
        case .transfer: return Environment.baseURL.appendingPathComponent("account/transfer")
        }
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
}
