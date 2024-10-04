//
//  APIClientCore.swift
//  Aura
//
//  Created by Bruno Evrard on 27/09/2024.
//

import Foundation

final class APIClientCore {
    
    
    static func fetchData<T: Decodable>(action: Action, user: User ) async -> Result<T, APIError> {
        
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
            guard let transfer = action.transfer else {
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
            let (data, response) = try await URLSession.shared.data(for: request)
            
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
                    return .success(user as! T)
                    
                case .account:
                    guard let account = try? JSONDecoder().decode(T.self, from: data) else {
                        throw APIError.invalidData()
                    }
                    return .success(account)
                    
                case .transfer:
                    return .success("OK" as! T)
                    
                }
            case 400:
                throw APIError.authenticationFailed()
            case 401:
                throw APIError.unauthorized()
            default:
                throw APIError.invalidResponse()
            }
            
            
        } catch {
            return .failure(.genericError())
        }
    }
}

//    /// Creating and executing the API call
//    /// - Parameters:
//    ///   - action: Action to perform
//    ///   - user: user logged in
//    ///   - type: type of object to return
//    /// - Returns: object to return
//    func fetchData<T>(action: Action, user: User, transfer: Transfer?, type: T.Type = T.self ) async throws-> T {
//    
//        var request : URLRequest?
//        switch action {
//        case .auth:
//            let url = Environment.baseURL.appendingPathComponent("auth")
//            let body = "username=\(user.username)&password=\(user.password)"
//           
//            request = URLRequest(url: url)
//            request?.httpBody = body.data(using: .utf8)
//            request?.httpMethod = "POST"
//            
//            guard let request else {
//                throw APIError.genericError()
//            }
//            let (data, response) = try await performRequest(request: request)
//           
//            let user = try await processResponse(action: action, data: data, response: response, user: user, type: User.self)
//            return user as! T
//            
//            
//        case .account:
//            let url = Environment.baseURL.appendingPathComponent("account")
//            request = URLRequest(url: url)
//            
//            guard var request else {
//                throw APIError.genericError()
//            }
//            request.addValue(user.token, forHTTPHeaderField: "token")
//            let (data, response) = try await performRequest(request: request)
//            let account = try await processResponse(action: action, data: data, response: response, user: user, type: Account.self  )
//            return account as! T
//            
//        case .transfer:
//            guard let transfer else {
//                throw APIError.genericError()
//            }
//            let url = Environment.baseURL.appendingPathComponent("transfer")
//            var queryItems = [URLQueryItem]()
//            queryItems.append(URLQueryItem(name: "recipient", value: transfer.recipient))
//            queryItems.append(URLQueryItem(name: "amount", value: transfer.amount))
//
//            var components = URLComponents()
//            components.queryItems = queryItems
//            let queryParameters = components.string
//            
//            
//           // let bodyTransfer = "recipient=\(transfer.recipient)&amount=\(transfer.amount)"
//            
//            request = URLRequest(url: url)
//            request?.httpBody = queryParameters?.data(using: .utf8)
//            request?.httpMethod = "POST"
//           
//            guard var request else {
//                throw APIError.genericError()
//            }
//            request.addValue(user.token, forHTTPHeaderField: "token")
//            
//            
//            
//            let (data, response) = try await performRequest(request: request)
//            let result = try await processResponse(action: action, data: data, response: response, user: user, type: Transfer.self  )
//            return result as! T
//           
//        }
//    }
//    
//    
//    /// Returns the result of the request execution
//    /// - Parameter request: URLRequest
//    /// - Returns: (Data, HTTPURLResponse)
//    func performRequest(request: URLRequest) async throws -> (Data, HTTPURLResponse) {
//        do {
//            let (data, response) = try await URLSession.shared.data(for: request)
//            
//            guard let httpResponse = response as? HTTPURLResponse else {
//                throw APIError.invalidResponse()
//            }
//            
//            return (data, httpResponse)
//        } catch {
//            throw APIError.invalidResponse()
//        }
//    }
//    
//    /// Response processing according to action
//    /// - Parameters:
//    ///   - action: Action to perform
//    ///   - data: data
//    ///   - response: response
//    ///   - user: user logged in
//    ///   - type: type of object to return
//    /// - Returns: object to return
//    func processResponse<T: Decodable>(action: Action,data: Data, response: HTTPURLResponse, user: User?, type: T.Type = T.self) async throws -> T {
//        switch response.statusCode {
//        case 200:
//            switch action {
//            case .auth:
//                guard let token = try? JSONDecoder().decode([String: String].self, from: data) else {
//                    throw APIError.invalidData()
//                }
//                var user = user
//                user?.token = token["token"] ?? ""
//                return user as! T
//                
//            case .account:
//                guard let account = try? JSONDecoder().decode(T.self, from: data) else {
//                    throw APIError.invalidData()
//                }
//                return account
//                
//            case .transfer:
//                return "Ok" as! T
//                
//            }
//        case 400:
//            throw APIError.authenticationFailed()
//        case 401:
//            throw APIError.unauthorized()
//        default:
//            throw APIError.invalidResponse()
//        }
//    }
