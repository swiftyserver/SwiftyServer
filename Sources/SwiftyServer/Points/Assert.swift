//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/22/19.
//

import Foundation


public struct Assert<In: Point>: Point where In.Enviroment: ErrorHandlingEnviroment {

	public typealias Enviroment = In.Enviroment

	public func perform(start enviroment: Enviroment, next: (In.Output, In.Enviroment) throws -> ()) throws {
		try upstream.perform(start: enviroment) { input, env in
			if self.check(input, env) {
				try next(input, env)
			} else {
				throw self.error
			}
		}
	}

	enum ValidationError: Error {
		case notValid(message: String)
	}

	public typealias Output = In.Output

	public var upstream: In
	var check: (In.Output, Enviroment) -> Bool
	var error: Enviroment.ErrorType
}

public extension Point where Enviroment: ErrorHandlingEnviroment {
	func assert(_ error: Enviroment.ErrorType, _ f: @escaping (Self.Output, Enviroment) -> Bool) -> Assert<Self> {
		return Assert<Self>(upstream: self, check: f, error: error)
	}
}

