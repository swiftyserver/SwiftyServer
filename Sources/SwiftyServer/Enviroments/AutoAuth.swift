//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/28/19.
//

import Foundation



public protocol AutoAuthEnviroment: AuthEnviroment {
	static var AuthPath: KeyPath<Self, Credential?> { get }
}


public extension Point where Enviroment: AutoAuthEnviroment {
	func auth() -> AuthPoint<Self> {
		return AuthPoint(upstream: self, keyPath: Enviroment.AuthPath)
	}
}
