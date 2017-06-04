import XCTest
@testable import SaltSwift

class SaltSwiftTests: XCTestCase {
   
    func testExample() {
        let password = "thisIsARandomPass"
        
        // a new user registers
        let registerUser = SaltSwift.init(pass: password)
        let salt = registerUser.salt
        let saltedPass = registerUser.saltedPass
        
        // now he logs in to his account
        let userData = SaltSwift.init(saltedPass: saltedPass, salt: salt)
        let result = userData.match(password)
            
        XCTAssert(result == true)
            
        let falseResult = userData.match("randomPass")
        XCTAssert(falseResult == false)
    }

    func testPassword() {
        
        let noLowerCase = "ASBFSDFSDF"
        XCTAssertThrowsError(try SaltSwift.validPassword(noLowerCase, options: [.containsLowerCase]))
            
        let noUpperCase = "dfasdfjlfaskfjsldf"
        XCTAssert(try SaltSwift.validPassword(noUpperCase, options: [.containsLowerCase]))
        XCTAssertThrowsError(try SaltSwift.validPassword(noUpperCase, options: [.containsPunctuations]))
        XCTAssertThrowsError(try SaltSwift.validPassword(noUpperCase, options: [.containsCapitol]))
        XCTAssertThrowsError(try SaltSwift.validPassword(noUpperCase, options: [.containsNumbers]))
            
        let shortPass = "23"
        XCTAssertThrowsError(try SaltSwift.validPassword(shortPass, options: [.digits(5)]))
        
        let goodPassword = "fdsfshSADFSDF@#$122"
        XCTAssert(try SaltSwift.validPassword(goodPassword, options: [.containsCapitol, .containsNumbers, .containsPunctuations, .digits(6)]))
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
