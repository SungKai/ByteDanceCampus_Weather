//
//  RisingJWT.swift
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/7/26.
//

import Foundation

@objcMembers public class RisingJWT: NSObject {
    
    struct team {
        static let keyID = "DQ362YMNMP"
        
        static let teamID = "95VT929YHJ"
        
        static let subject = "com.bytedance.ssr"
        
        static let authKeyFileName = "AuthKey_DQ362YMNMP"
    }

    var date: Date = Date()
    
    var expireDuration: TimeInterval = 60 * 60
    
    static public let shared = RisingJWT()
    
    @objc public class func token(auto: Bool) -> String? {
        let jwtShared = RisingJWT.shared
        if auto {
            let yetIss = jwtShared.date.timeIntervalSince1970.rounded()
            let nowIss = Date().timeIntervalSince1970.rounded()
            if (nowIss - yetIss >= jwtShared.expireDuration) {
                jwtShared.date = Date()
            }
        } else {
            jwtShared.date = Date()
        }
        let jwt = JWT(keyID: self.team.keyID, teamID: self.team.teamID, subject: self.team.subject, issueDate: jwtShared.date, expireDuration: jwtShared.expireDuration)
        
        let token = try? jwt.sign(with: P8(fromP8: self.team.authKeyFileName))
        
        return token
    }
}
