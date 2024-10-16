//
//  APIClientCore.swift
//  Aura
//
//  Created by Bruno Evrard on 27/09/2024.
//

import Foundation

final class APIClientCore {
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(action: Action, user: User  ) async -> Result<T, APIError> {
        
        let url = action.api
        var request : URLRequest?
        request = URLRequest(url: url)
        
        
        switch action {
        case .auth:
            let body = "username=\(user.username)&password=\(user.password)"
            request?.httpBody = body.data(using: .utf8)
        case .account:
            request?.addValue(user.token, forHTTPHeaderField: "token")
        case .transfer:
            request?.addValue(user.token, forHTTPHeaderField: "token")
            guard let transfer = action.toTransfer else {
                return .failure(.genericError())
            }
            let body = "recipient=\(transfer.recipient)&amount=\(transfer.amount)"
            request?.httpBody = body.data(using: .utf8)
        }
        
        request?.httpMethod = action.httpMethod.rawValue
        do {
            guard let request else {
                return .failure(.genericError())
            }
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.genericError())
            }
            
            switch httpResponse.statusCode {
            case 200:
                switch action {
                case .auth:
                    guard let token = try? JSONDecoder().decode([String: String].self, from: data) else {
                        throw APIError.invalidData()
                    }
                    var user = user
                    user.token = token["token"] ?? ""
                    guard let user = user as? T else {
                        throw APIError.genericError()
                    }
                    return .success(user)
                    
                    
                    
                case .account:
                    guard let account = try? JSONDecoder().decode(T.self, from: data) else {
                        throw APIError.invalidData()
                    }
                    return .success(account)
                    
                case .transfer:
                    let result = "OK"
                    guard let result = result as? T else {
                        throw APIError.genericError()
                    }
                    return .success(result)
                    
                }
            case 400:
                throw APIError.authenticationFailed()
            case 401:
                throw APIError.unauthorized()
            default:
                throw APIError.invalidResponse()
            }
            
        } catch let apiError as APIError {
            return .failure(apiError)
        } catch {
            return .failure(.genericError())
        }
    }
}


