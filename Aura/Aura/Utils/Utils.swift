//
//  Utils.swift
//  Aura
//
//  Created by Bruno Evrard on 25/09/2024.
//

import Foundation


func validateEmail(_ email: String) throws (ControlError) {
    if email.isEmpty {
        throw ControlError.mailEmpty
    }
    
    let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
    let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
    
    if !emailPredicate.evaluate(with: email) {
        throw ControlError.invalidFormatMail
    }
}


func validateFrenchPhoneNumber(_ phoneNumber: String) throws (ControlError) {
    let phoneRegex = #"^(0|\+33)[1-9]([.\-\s]?\d{2}){4}$"#
    
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
    if (!phoneTest.evaluate(with: phoneNumber)) {
        throw ControlError.invalidFormatPhoneNumber
    }
}
