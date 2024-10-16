//
//  AuthentificationViewModelTest.swift
//  AuraUITests
//
//  Created by Bruno Evrard on 08/10/2024.
//

import XCTest

final class AuthentificationViewModelTest: XCTestCase {
    
    func testControl() async {
        
        let session = MockUrlSession()
        session.data = "{\"token\": \"fakeToken123\"}".data(using: .utf8)
        session.urlResponse = HTTPURLResponse(url: Action.auth.api, statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockApiClient = MockApiClient(session: session)
        
        let viewModel = AuthenticationViewModel(apiService: mockApiClient) { user in
            XCTAssertEqual(user.token, "fakeToken123")
        }
        
        // username empty
        viewModel.username = ""
        viewModel.password = "test"
        await viewModel.login()
        var error: LoginError = .mailEmpty()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.messageAlert, error.message)
        
        // mail invalid
        viewModel.username = "adressemail"
        await viewModel.login()
        error = .invalidFormatMail()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.messageAlert, error.message)
        
        // Password Empty
        viewModel.username = "test@test.com"
        viewModel.password = ""
        await viewModel.login()
        error = .passwordEmpty()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.messageAlert, error.message)
    }
    
    
    func testLoginSuccess() async  {
        
        let session = MockUrlSession()
        session.data = "{\"token\": \"fakeToken123\"}".data(using: .utf8)
        session.urlResponse = HTTPURLResponse(url: Action.auth.api, statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockApiClient = MockApiClient(session: session)
        
        let viewModel = AuthenticationViewModel(apiService: mockApiClient) { user in
            XCTAssertEqual(user.token, "fakeToken123")
        }
        
        // authentication success
        viewModel.username = "test@aura.app"
        viewModel.password = "test123"
        await viewModel.login()
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertEqual(viewModel.messageAlert, "")
        
    }
    
    func testLoginFailed() async {
        
        let session = MockUrlSession()
        session.data = "{\"token\": \"fakeToken123\"}".data(using: .utf8)
        session.urlResponse = HTTPURLResponse(url: Action.auth.api, statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockApiClient = MockApiClient(session: session)
        
        let viewModel = AuthenticationViewModel(apiService: mockApiClient) { user in
            XCTAssertEqual(user.token, "fakeToken123")
        }
        
        viewModel.username = "test@aura.appa"
        viewModel.password = "test123"
        
        // invalid json
        session.data = "invalid Json".data(using: .utf8)
        var apiError = APIError.genericError()
        await viewModel.login()
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.messageAlert, apiError.message)
        
        
        // authentication failed
        session.data = "{\"error\": true},{\"reason\": \"Bad Request\"}".data(using: .utf8)
        session.urlResponse = HTTPURLResponse(url: Action.auth.api, statusCode: 400, httpVersion: nil, headerFields: nil)
        await viewModel.login()
        apiError = APIError.authenticationFailed()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.messageAlert, apiError.message)
    }
    
}






