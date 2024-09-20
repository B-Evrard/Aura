//
//  APIError.swift
//  Aura
//
//  Created by Bruno Evrard on 20/09/2024.
//

import Foundation

enum APIError: Error {
    case invalidResponse(response: HTTPURLResponse, data: Data)
    case invalidData(data: Data)
    case invalidURL(url: URL)
}
