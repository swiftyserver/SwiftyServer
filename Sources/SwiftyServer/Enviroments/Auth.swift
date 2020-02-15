//
//  File 4.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation

public protocol Identifiable {
	associatedtype Identifier

	var id: Identifier { get }
}

public protocol AuthEnviroment: DatabaseEnviroment {
	associatedtype User: Identifiable
	associatedtype Credential: Codable

	var currentUser: User? { get set }

	func auth(with: Credential) -> User
}


public struct AuthPoint<In: Point>: Point where In.Enviroment: AuthEnviroment {
	public typealias Enviroment = In.Enviroment

	public func perform(start enviroment: Enviroment, next: (In.Output, In.Enviroment) throws -> ()) throws {
		try upstream.perform(start: enviroment, next: { (input, env) in
			var newEnv = env

			if let credentials = env[keyPath: self.keyPath] {
				newEnv.currentUser = newEnv.auth(with: credentials)
			}
			try next(input, newEnv)

		})
	}

	public var upstream: In

	var keyPath: KeyPath<Enviroment, Enviroment.Credential?>

	public typealias Output = In.Output
}

public extension Point where Enviroment: AuthEnviroment {
	func auth(from: KeyPath<Enviroment, Enviroment.Credential?>) -> AuthPoint<Self> {
		return AuthPoint(upstream: self, keyPath: from)
	}
}
