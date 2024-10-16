//
//  TransactionsViewModelTest.swift
//  AuraUITests
//
//  Created by Bruno Evrard on 16/10/2024.
//

import XCTest

final class TransactionsViewModelTest: XCTestCase {
    
    func testAllTransactions() async {
        let session = MockUrlSession()
        session.data = sampleJSON.data(using: .utf8)
        session.urlResponse = HTTPURLResponse(url: Action.account.api, statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockApiClient = MockApiClient(session: session)
        
        
        let viewModel = AccountDetailViewModel(apiService: mockApiClient)
        
        // Success
        let user = User(username: "test@aura.app", password: "bruno", token: "bruno")
        viewModel.user = user
        await viewModel.getAccount()
        
        if let transactions = viewModel.allTransactions {
            let transactionsViewModel =  TransactionsViewModel(transactions: transactions)
            
            XCTAssertEqual(transactionsViewModel.transactions.count,6)
            
            XCTAssertEqual(transactionsViewModel.transactions[0].amount,-15)
            XCTAssertEqual(transactionsViewModel.transactions[0].description,"Amazon")
            
            XCTAssertEqual(transactionsViewModel.transactions[1].amount,-20)
            XCTAssertEqual(transactionsViewModel.transactions[1].description,"Ikea")
            
            XCTAssertEqual(transactionsViewModel.transactions[2].amount,2000)
            XCTAssertEqual(transactionsViewModel.transactions[2].description,"Salaire")
            
            XCTAssertEqual(transactionsViewModel.transactions[3].amount,-200.5)
            XCTAssertEqual(transactionsViewModel.transactions[3].description,"Auchan")
            
            XCTAssertEqual(transactionsViewModel.transactions[4].amount,10.65)
            XCTAssertEqual(transactionsViewModel.transactions[4].description,"Remboursement")
            
            XCTAssertEqual(transactionsViewModel.transactions[5].amount,-30)
            XCTAssertEqual(transactionsViewModel.transactions[5].description,"Netflix")
            
        }
    }
    
    
}
