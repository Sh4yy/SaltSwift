import CryptoSwift
import Foundation

class SaltSwift {
    
    var saltedPass : String
    var salt : String
    
    static var generateSalt : String {
        return UUID().uuidString
    }
    
    enum Algorithms {
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

    static func salt(password : String, salt : String? = nil, algorithm : Algorithms)
            -> (saltedPass : String, salt : String) {
            let salt = salt ?? generateSalt
            let combination = password + salt
            
            let bytes = Array(combination.utf8)
            let combinationData = Data(bytes : bytes)
           
            let hashedString = algorithm.hash(combinationData)
            return (hashedString, salt)
    }
    
    init(saltedPass : String, salt : String) {
        self.salt = salt
        self.saltedPass = saltedPass
    }
    
    convenience init(pass : String)  {
        let result =  SaltSwift.salt(password: pass, algorithm: .SHA256)
        self.init(saltedPass: result.saltedPass, salt: result.salt)
    }
    
    func match(_ password : String, algorithm : Algorithms = .SHA256)  -> Bool {
        let newSaltedPass =  SaltSwift.salt(password: password, salt: salt, algorithm: algorithm).saltedPass
        return newSaltedPass == saltedPass
    }
    
}

extension SaltSwift {
    
    static func validPassword(_ password : String) -> Bool {
        
    }
    
    
}
