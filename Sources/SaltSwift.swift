import CryptoSwift
import Foundation

public class SaltSwift {
    
    var saltedPass : String
    var salt : String
    
    public static var generateSalt : String {
        return UUID().uuidString
    }
    
    public enum Algorithms {
        case MD5
        case SHA1
        case SHA256
        case SHA512
        
        func hash(_ pass : Data) -> String {
            switch self {
            case .MD5    : return pass.md5().toHexString()
            case .SHA1   : return pass.sha1().toHexString()
            case .SHA256 : return pass.sha256().toHexString()
            case .SHA512 : return pass.sha512().toHexString()
            }
        }
        
    }

    public static func salt(password : String, salt : String? = nil, algorithm : Algorithms)
            -> (saltedPass : String, salt : String) {
            let salt = salt ?? generateSalt
            let combination = password + salt
            
            let bytes = Array(combination.utf8)
            let combinationData = Data(bytes : bytes)
           
            let hashedString = algorithm.hash(combinationData)
            return (hashedString, salt)
    }
    
    public init(saltedPass : String, salt : String) {
        self.salt = salt
        self.saltedPass = saltedPass
    }
    
    public convenience init(pass : String)  {
        let result =  SaltSwift.salt(password: pass, algorithm: .SHA256)
        self.init(saltedPass: result.saltedPass, salt: result.salt)
    }
    
    public func match(_ password : String, algorithm : Algorithms = .SHA256)  -> Bool {
        let newSaltedPass =  SaltSwift.salt(password: password, salt: salt, algorithm: algorithm).saltedPass
        return newSaltedPass == saltedPass
    }
    
}

extension SaltSwift {
    
    public enum passOptions {
        case digits(Int)
        case containsCapitol
        case containsNumbers
        case containsPunctuations
        case containsLowerCase
        case regex(String)
    }
    
    public enum passError : Error {
        case smallPassword
        case needsCapitol
        case needsNumbers
        case needsLowerCase
        case needsPunctuations
        case doesNotConformToRegex
    }
    
    public static func validPassword(_ password : String, options : [passOptions]) throws -> Bool {
        
        for option in options {
            switch option {
            case .containsCapitol :
                if !password.isMatching(expression: ".*[A-Z]+.*")
                { throw passError.needsCapitol }
            case .containsNumbers:
                if !password.isMatching(expression: ".*[0-9]+.*")
                { throw passError.needsNumbers }
            case .containsPunctuations:
                if !password.isMatching(expression: ".*[!&^%$#@()/]+.*")
                { throw passError.needsPunctuations }
            case .containsLowerCase:
                if !password.isMatching(expression: ".*[a-z]+.*")
                { throw passError.needsLowerCase }
            case .regex(let regex):
                if !password.isMatching(expression: regex)
                { throw passError.doesNotConformToRegex }
            case .digits(let digits):
                if (password.characters.count < digits)
                { throw passError.smallPassword }
            }
        }
        
        return true
        
    }
    
    
}

extension String {
    
    public func isMatching(expression: String, count : Int = 1) -> Bool {
        let regex = try! NSRegularExpression(pattern: expression)
        return regex.numberOfMatches(in: self, range: NSRange(location: 0, length: characters.count)) > (count - 1)
    }
    
}















