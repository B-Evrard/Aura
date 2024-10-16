//
//  AccountDetailViewModelTest.swift
//  AuraUITests
//
//  Created by Bruno Evrard on 12/10/2024.
//

import XCTest

final class AccountDetailViewModelTest: XCTestCase {
    
    func testSuccess() async {
        
        let session = MockUrlSession()
        session.data = sampleJSON.data(using: .utf8)
        session.urlResponse = HTTPURLResponse(url: Action.account.api, statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockApiClient = MockApiClient(session: session)
        
        
        let viewModel = AccountDetailViewModel(apiService: mockApiClient)
        
        // Success
        let user = User(username: "test@aura.app", password: "bruno", token: "bruno")
        viewModel.user = user
        await viewModel.getAccount()
        
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertEqual(viewModel.account?.totalAmount, 1500)
        
        XCTAssertEqual(viewModel.recentTransactions[0].amount,-15)
        XCTAssertEqual(viewModel.recentTransactions[0].description,"Amazon")
        
        XCTAssertEqual(viewModel.recentTransactions[1].amount,-20)
        XCTAssertEqual(viewModel.recentTransactions[1].description,"Ikea")
        
        XCTAssertEqual(viewModel.recentTransactions[2].amount,2000)
        XCTAssertEqual(viewModel.recentTransactions[2].description,"Salaire")
        
        XCTAssertEqual(viewModel.allTransactions?.count,6)
    }
    
    func testSuccessNodata() async {
        
        let session = MockUrlSession()
        session.data = sampleJSONNoData.data(using: .utf8)
        session.urlResponse = HTTPURLResponse(url: Action.account.api, statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockApiClient = MockApiClient(session: session)
        
        
        let viewModel = AccountDetailViewModel(apiService: mockApiClient)
        
        // Success
        let user = User(username: "test@aura.app", password: "bruno", token: "bruno")
        viewModel.user = user
        await viewModel.getAccount()
        
        XCTAssertFalse(viewModel.showAlert)
        
    }
    
    func testFail() async {
        let session = MockUrlSession()
        let mockApiClient = MockApiClient(session: session)
        
        let viewModel = AccountDetailViewModel(apiService: mockApiClient)
        
        
        // Fail token empty
        var user = User(username: "test@aura.app", password: "bruno", token: "")
        viewModel.user = user
        session.data = "{\"error\": true},{\"reason\": \"Unauthorized\"}".data(using: .utf8)
        session.urlResponse = HTTPURLResponse(url: Action.auth.api, statusCode: 401, httpVersion: nil, headerFields: nil)
        await viewModel.getAccount()
        let error: APIError = .genericError()
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.messageAlert, error.message)
        
        // Fail token false
        user = User(username: "test@aura.app", password: "bruno", token: "dqsd")
        viewModel.user = user
        await viewModel.getAccount()
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.messageAlert, error.message)
        
        // Fail no user
        viewModel.user = nil
        await viewModel.getAccount()
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.messageAlert, error.message)
    }
    
    
    
    
    
    
}

let sampleJSON = """
        {
        "currentBalance": 1500,
        "transactions": [
          {
            "value": -15,
            "label": "Amazon"
          },
          {
            "value": -20,
            "label": "Ikea"
          },
          {
            "value": 2000,
            "label": "Salaire"
          },
          {
            "value": -200.5,
            "label": "Auchan"
          },
          {
            "value": 10.65,
            "label": "Remboursement"
          },
          {
            "value": -30,
            "label": "Netflix"
          }
        ]
        }
        """

let sampleJSONNoData = """
        {
        "currentBalance": null,
        "transactions": null
        }
        """




