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


    static var allTests = [
        ("testExample", testExample),
    ]
}
