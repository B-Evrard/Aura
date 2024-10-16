//
//  MoneyTransfertViewModelTest.swift
//  Aura
//
//  Created by Bruno Evrard on 15/10/2024.
//

import XCTest

final class MoneyTransfertViewModelTest: XCTestCase {
    
    func testMoneyTransertSuccess() async {
        
        let session = MockUrlSession()
        let transfer: Transfer = .init(recipient: "bruno@gmail.com", amount: "200")
        session.data = "".data(using: .utf8)
        session.urlResponse = HTTPURLResponse(url: Action.transfer(transfer: transfer).api, statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockApiClient = MockApiClient(session: session)
        let viewModel = MoneyTransferViewModel(apiService: mockApiClient)
        
        let user = User(username: "test@aura.app", password: "bruno", token: "123456789")
        viewModel.user = user
        viewModel.recipient = "bruno@gmail.com"
        viewModel.amount = "100"
        
        await viewModel.sendMoney()
        XCTAssertEqual(viewModel.transferMessage, "Successfully transferred 100 to bruno@gmail.com")
    }
    
    func testMoneyTransertFail() async {
        
        let session = MockUrlSession()
        let transfer: Transfer = .init(recipient: "", amount: "")
        let mockApiClient = MockApiClient(session: session)
        let viewModel = MoneyTransferViewModel(apiService: mockApiClient)
        
        // Test control failure
        viewModel.recipient = ""
        viewModel.amount = ""
        await viewModel.sendMoney()
        var error: TransferError = .invalidRecipient()
        XCTAssertEqual(viewModel.transferMessage, error.message)
        
        // Test recipient invalid
        viewModel.recipient = "12121212121112121212"
        viewModel.amount = "100"
        await viewModel.sendMoney()
        XCTAssertEqual(viewModel.transferMessage, error.message)
        
        // Test recipient invalid
        viewModel.recipient = "+31604012136"
        viewModel.amount = "100"
        await viewModel.sendMoney()
        XCTAssertEqual(viewModel.transferMessage, error.message)
        
        // Test amount invalid
        viewModel.recipient = "bruno@gmail.com"
        viewModel.amount = ""
        error = .amountEmpty()
        await viewModel.sendMoney()
        XCTAssertEqual(viewModel.transferMessage, error.message)
        
        // Test amount invalid
        viewModel.amount = "qq"
        error = .invalidAmount()
        await viewModel.sendMoney()
        XCTAssertEqual(viewModel.transferMessage, error.message)
        
        // Test user empty
        viewModel.recipient = "0604012136"
        viewModel.amount = "100"
        await viewModel.sendMoney()
        XCTAssertEqual(viewModel.transferMessage, "Utilisateur deconnecté")
        
        // Test Token empty
        let user = User(username: "test@aura.app", password: "bruno", token: "")
        viewModel.user = user
        session.data = "{\"error\": true},{\"reason\": \"Unauthorized\"}".data(using: .utf8)
        session.urlResponse = HTTPURLResponse(url: Action.transfer(transfer: transfer).api, statusCode: 401, httpVersion: nil, headerFields: nil)
        let apiError: APIError = .unauthorized()
        await viewModel.sendMoney()
        
        XCTAssertEqual(viewModel.transferMessage, apiError.message)
    }
    
    func testRaz () {
        let session = MockUrlSession()
        let mockApiClient = MockApiClient(session: session)
        let viewModel = MoneyTransferViewModel(apiService: mockApiClient)
        viewModel.raz()
        XCTAssertEqual(viewModel.transferMessage, "")
        XCTAssertEqual(viewModel.recipient, "")
        XCTAssertEqual(viewModel.amount, "")
    }
    
}
