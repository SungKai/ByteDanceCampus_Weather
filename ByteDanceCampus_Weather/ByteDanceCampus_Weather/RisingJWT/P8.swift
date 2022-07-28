//
//  P8.swift
//  CupertinoJWT
//
//  Created by Ethanhuang on 2018/8/23.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public struct P8 {
    
    public var fileContent: String
    
    public init(_ str: String) {
        fileContent = str
            .replacingOccurrences(of: " ", with: "")
            .split(separator: "\n")
            .filter({ $0.hasPrefix("-----") == false })
            .joined(separator: "")
    }
    
    public init(fromP8 filePath : String) {
        self.init(String(data:try! Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource:filePath, ofType:"p8")!)), encoding: .utf8)!)
    }
    
    /// Convert PEM format .p8 file to DER-encoded ASN.1 data
    public func toASN1() throws -> ASN1 {

        guard let asn1 = Data(base64Encoded: fileContent) else {
            throw CupertinoJWTError.invalidP8
        }
        return asn1
    }
}
