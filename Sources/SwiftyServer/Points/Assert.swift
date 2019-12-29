//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/22/19.
//

import Foundation


public struct Assert<In: Point>: Point where In.Enviroment: ErrorHandlingEnviroment {

	public typealias Enviroment = In.Enviroment

	public func perform(on request: inout Enviroment) throws -> In.Output {
		let outPrev = try upstream.perform(on: &request)

		if self.check(outPrev, request) {
			return outPrev
		} else {
			throw self.error
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

