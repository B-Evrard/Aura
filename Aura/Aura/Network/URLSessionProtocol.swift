//
//  ProtocolUrlSession.swift
//  Aura
//
//  Created by Bruno Evrard on 09/10/2024.
//

import Foundation


protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
