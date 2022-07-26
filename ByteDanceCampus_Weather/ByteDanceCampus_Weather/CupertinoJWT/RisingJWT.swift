//
//  RisingJWT.swift
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/7/26.
//

import Foundation

@objcMembers public class RisingJWT: NSObject {
    
    static let keyID = "DQ362YMNMP"
    
    static let teamID = "95VT929YHJ"
    
    static let p8 =
        "MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgdRMW0yufoVHXusdi" +
        "eRltXqbLxhj/g5YbObuISXC3YGmgCgYIKoZIzj0DAQehRANCAAQ0WVRkkxr4oxoz" +
        "vyW802+XuIW7BYzicNPU1Xltsn0SE7+UBeZ8WWAeWoufxpU4xyKJGeVcBQ+qncei" +
        "K1qA+XSH"
    
    @objc public class var token: String? {
        get {
            let jwt = JWT(keyID: keyID, teamID: teamID, issueDate: Date(), expireDuration: 60 * 60)
            
            let token = try? jwt.sign(with: p8)
            
            return token
        }
    }
}
