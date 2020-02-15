//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation


public struct Check<In: Point>: Point {

	public typealias Enviroment = In.Enviroment

	public func perform(start enviroment: Enviroment, next: (In.Output, In.Enviroment) throws -> ()) throws {
		try upstream.perform(start: enviroment) { input, env in
			if self.check(input, env) {
				try next(input, env)
			} else {
				throw ValidationError.notValid(message: self.message)
			}
		}
	}

	enum ValidationError: Error {
		case notValid(message: String)
	}

	public typealias Output = In.Output

	public var upstream: In
	var check: (In.Output, Enviroment) -> Bool
	var message: String

	public init(upstream: In, check: @escaping (In.Output, Enviroment) -> Bool, message: String) {
		self.upstream = upstream
		self.check = check
		self.message = message
	}
}

public extension Point {
	func check(message: String, _ f: @escaping (Self.Output, Enviroment) -> Bool) -> Check<Self> {
		return Check<Self>(upstream: self, check: f, message: message)
	}
}


