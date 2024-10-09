//
//  Transactions.swift
//  Aura
//
//  Created by Bruno Evrard on 04/10/2024.
//

import SwiftUI

struct TransactionsView: View {
    
    @ObservedObject var viewModel: TransactionsViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Large Header displaying total amount
            VStack(spacing: 10) {
                Text("Your Transactions")
                    .font(.headline)
                
                Image(systemName: "eurosign.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .foregroundColor(Color(hex: "#94A684"))
            }
            .padding(.top)
           
            List {
                ForEach(viewModel.transactions, id: \.description) { transaction in
                    ZStack {
                        Color.gray.opacity(0.1)
                        HStack {
                            
                            Image(systemName: transaction.amountFormatted.contains("+") ? "arrow.up.right.circle.fill" : "arrow.down.left.circle.fill")
                                .foregroundColor(transaction.amountFormatted.contains("+") ? .green : .red)
                            Text(transaction.description)
                            Spacer()
                            Text(transaction.amountFormatted)
                                .fontWeight(.bold)
                                .foregroundColor(transaction.amountFormatted.contains("+") ? .green : .red)
                        }
                        .padding()
                    }
                    .cornerRadius(8)
                    .listRowSeparator(.hidden)
                }
            }
           
            .listStyle(PlainListStyle()) // Si tu veux un style de liste sans bordures
          
        }
            
        }
        
}

#Preview {
    TransactionsView(viewModel: TransactionsViewModel(transactions: []))
}
