//
//  AccountDetailView.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import SwiftUI

struct AccountDetailView: View {
    
    @ObservedObject var viewModel: AccountDetailViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Large Header displaying total amount
            VStack(spacing: 10) {
                Text("Your Balance")
                    .font(.headline)
                Text(viewModel.totalAmount)
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(Color(hex: "#94A684")) // Using the green color you provided
                Image(systemName: "eurosign.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .foregroundColor(Color(hex: "#94A684"))
            }
            .padding(.top)
            
            // Display recent transactions
            VStack(alignment: .leading, spacing: 10) {
                Text("Recent Transactions")
                    .font(.headline)
                    .padding([.horizontal])
                ForEach(viewModel.recentTransactions, id: \.description) { transaction in
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
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding([.horizontal])
                }
            }
            
            // Button to see details of transactions
            Button(action: {
                viewModel.setViewTransaction(true as Bool)
            }) {
                HStack {
                    Image(systemName: "list.bullet")
                    Text("See Transaction Details")
                }
                .padding()
                .background(Color(hex: "#94A684"))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            .sheet(isPresented: $viewModel.viewTransaction) {
                viewModel.initTransaction
            }
            .padding([.horizontal, .bottom])
            
            
            Spacer()
        }
        .onTapGesture {
                    self.endEditing(true)  // This will dismiss the keyboard when tapping outside
                }
        .onAppear() {
            Task {
                await viewModel.getAccount()
            }
            
        }
       
    }
    
        
}

#Preview {
    AccountDetailView(viewModel: AccountDetailViewModel(apiService: APIClient()))
}
