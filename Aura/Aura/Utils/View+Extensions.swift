//
//  View+Extensions.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import SwiftUI

extension View {
    func endEditing(_ force: Bool) {
        //UIApplication.shared.windows.forEach { $0.endEditing(force)}
      
        let windowScenes = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
        windowScenes.forEach { windowScene in
            windowScene.windows.forEach { window in
                window.endEditing(force)
            }
        }
        
        
    }
}
