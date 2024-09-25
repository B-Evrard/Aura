//
//  APIClient.swift
//  Aura
//
//  Created by Bruno Evrard on 20/09/2024.
//

import Foundation

final class APIClient: APIService {
    
    func authentication(user: User) async throws -> User {
        
        let url = Environment.baseURL.appendingPathComponent("auth")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body="username=\(user.username)&password=\(user.password)"
        request.httpBody = body.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 400:
            throw APIError.authenticationFailed
            
        case 200:
            guard let responseJSON = try? JSONDecoder().decode([String: String].self, from: data),  let token = responseJSON["token"] else {
                throw APIError.invalidData
            }
            var user = user
            user.token = token
            return user
            
        default:
            throw APIError.invalidResponse
        }
    }
    
    func getAccount(user: User) async throws -> Account {
        
        let url = Environment.baseURL.appendingPathComponent("account")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(user.token, forHTTPHeaderField: "token")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 401:
            throw APIError.unauthorized
            
        case 200:
            guard let account = try? JSONDecoder().decode(Account.self, from: data) else {
                throw APIError.invalidData
            }
            print (account.totalAmount)
            return account
        default:
            throw APIError.invalidResponse
        }
        
    }
    
    
}



//let jsonData = String(data).data(using: .utf8)! //not good :) just for example !
//
//private func parse(jsonData: Data) {
//        do {
//            let decodedData = try JSONDecoder().decode(Quizz.self, from: jsonData)
//            print(decodedData.questions[0].answers[0]) // Blanc
//            print(decodedData.questions[0].question) // Quel est la couleur du cheval blanc d'henri IV?
//        } catch {
//            print("decode error")
//        }
//    }
