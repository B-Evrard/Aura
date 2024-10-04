//
//  APIError.swift
//  Aura
//
//  Created by Bruno Evrard on 20/09/2024.
//

import Foundation

enum APIError: Error {
    case invalidResponse(message: String = "Une erreur est survenue.")
    case invalidData(message: String = "Une erreur est survenue.")
    case invalidURL(message: String = "Une erreur est survenue.")
    case authenticationFailed(message: String = "Authentification invalide.")
    case unauthorized(message: String = "Une erreur est survenue.")
    case genericError(message: String = "Une erreur est survenue.")
    
    var message: String {
        switch self {
        case .invalidResponse(let message),
                .invalidData(let message),
                .invalidURL(let message),
                .authenticationFailed(let message),
                .unauthorized(let message),
                .genericError(let message):
            return message
        }
    }
}

enum ControlError: Error {
    case mailEmpty
    case invalidFormatMail
    case invalidFormatPhoneNumber
}

enum LoginError: Error {
    case mailEmpty(message: String = "Veuillez saisir une adresse mail.")
    case invalidFormatMail(
        message: String = "Veuillez saisir une adresse mail valide.")
    case passwordEmpty(message: String = "Veuillez saisir votre mot de passe.")
    case genericError(message: String = "Une erreur est survenue.")
    
    var message: String {
        switch self {
        case .mailEmpty(let message),
                .invalidFormatMail(let message),
                .passwordEmpty(let message),
                .genericError(let message):
            return message
        }
    }
}

enum TransferError: Error {
    case invalidRecipient(
        message: String =
        "Veuillez saisir une adresse email valide ou un numéro de téléphone valide en France.")
    case amountEmpty(message: String = "Veuillez saisir un montant.")
    case invalidAmount(message: String = "Veuillez saisir un montant valide.")
    case genericError(message: String = "Une erreur est survenue.")
    
    var message: String {
        switch self {
        case    .invalidRecipient(let message),
                .amountEmpty(let message),
                .invalidAmount(let message),
                .genericError(let message):
            return message
        }
    }
}
