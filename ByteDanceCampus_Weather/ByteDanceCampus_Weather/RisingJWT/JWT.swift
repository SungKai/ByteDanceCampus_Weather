//
//  JWT.swift
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/7/26.
//

import Foundation

public struct JWT: Codable {
    private struct Header: Codable {
        /// alg
        let algorithm: String = "ES256"

        /// kid
        let keyID: String
        
        /// id
        let identification: String

        enum CodingKeys: String, CodingKey {
            case algorithm = "alg"
            case keyID = "kid"
            case identification = "id"
        }
    }

    private struct Payload: Codable {
        /// iss
        public let teamID: String

        /// iat
        public let issueDate: Int

        /// exp
        public let expireDate: Int
        
        /// sub
        public let subject: String

        enum CodingKeys: String, CodingKey {
            case teamID = "iss"
            case issueDate = "iat"
            case expireDate = "exp"
            case subject = "sub"
        }
    }

    private let header: Header

    private let payload: Payload

    public init(keyID kid: String, teamID iss: String, subject sub: String, issueDate iat: Date, expireDuration: TimeInterval) {

        header = Header(keyID: kid, identification: "\(iss).\(sub)")

        let iat = Int(iat.timeIntervalSince1970.rounded())
        let exp = iat + Int(expireDuration)

        payload = Payload(teamID: iss, issueDate: iat, expireDate: exp, subject: sub)
    }

    /// Combine header and payload as digest for signing.
    public func digest() throws -> String {
        let headerString = try JSONEncoder().encode(header.self).base64EncodedURLString()
        let payloadString = try JSONEncoder().encode(payload.self).base64EncodedURLString()
        return "\(headerString).\(payloadString)"
    }

    /// Sign digest with P8(PEM) string. Use the result in your request authorization header.
    public func sign(with p8: P8) throws -> String {
        let digest = try self.digest()
        
        let signature = try p8.toASN1()
            .toECKeyData()
            .toPrivateKey()
            .es256Sign(digest: digest)

        let token = "\(digest).\(signature)"
        return token
    }
}
