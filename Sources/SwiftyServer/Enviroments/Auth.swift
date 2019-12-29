//
//  File 4.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation

protocol Identifiable {
	associatedtype Identifier

	var id: Identifier { get }
}

protocol AuthEnviroment: DatabaseEnviroment {
	associatedtype User: Identifiable
	associatedtype Credential: Codable

	var currentUser: User? { get set }

	func auth(with: Credential) -> User
}


struct AuthPoint<In: Point>: Point where In.Enviroment: AuthEnviroment {
	typealias Enviroment = In.Enviroment

	func perform(on request: inout Enviroment) throws -> In.Output {
		let outPrev = try upstream.perform(on: &request)
		if let credentials = request[keyPath: self.keyPath] {
			request.currentUser = request.auth(with: credentials)
		}
		return outPrev
	}

	var upstream: In

	var keyPath: KeyPath<Enviroment, Enviroment.Credential?>

	typealias Output = In.Output
}

extension Point where Enviroment: AuthEnviroment {
	func auth(from: KeyPath<Enviroment, Enviroment.Credential?>) -> AuthPoint<Self> {
		return AuthPoint(upstream: self, keyPath: from)
	}
}
