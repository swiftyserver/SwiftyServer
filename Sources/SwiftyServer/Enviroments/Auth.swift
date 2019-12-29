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

	public func perform(on request: inout Enviroment) throws -> In.Output {
		let outPrev = try upstream.perform(on: &request)
		if let credentials = request[keyPath: self.keyPath] {
			request.currentUser = request.auth(with: credentials)
		}
		return outPrev
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
