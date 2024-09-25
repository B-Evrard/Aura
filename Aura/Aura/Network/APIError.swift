//
//  APIError.swift
//  Aura
//
//  Created by Bruno Evrard on 20/09/2024.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case invalidData
    case invalidURL
    case authenticationFailed
    case unauthorized
}
