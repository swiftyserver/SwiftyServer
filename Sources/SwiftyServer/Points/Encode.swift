//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation


public struct Encode<In: Point>: Point where In.Output: Encodable {

	public typealias Enviroment = In.Enviroment


	public func perform(start enviroment: In.Enviroment, next: (Data, In.Enviroment) throws -> ()) throws {
		try upstream.perform(start: enviroment, next: { input, env in
			try next(JSONEncoder().encode(input), env)
		})
	}

	public var upstream: In
	public typealias Output = Data
}

public struct Response<In: Point>: Point where In.Output == String {
	public typealias Enviroment = In.Enviroment

	public func perform(start enviroment: In.Enviroment, next: (Data, In.Enviroment) throws -> ()) throws {
		try upstream.perform(start: enviroment, next: { input, env in
			if let data = input.data(using: .utf8) {
				try next(data, env)
			} else {
				throw ResponseError.textEncodingError
			}
		})
	}


	enum ResponseError: Error {
		case textEncodingError
	}

	public var upstream: In
	public typealias Output = Data
}


public extension Point where Output == String, Enviroment: HTTPEnviroment {
//	@discardableResult
	func response() {
		let p = Response(upstream: self).eraseToAnyType()
		Enviroment.Server.endPoints.add(returns: "String", point: p)
		self.setup()
//		return p
	}
}

public extension Point where Output: Encodable, Enviroment: HTTPEnviroment {
//	@discardableResult
	func json() {
		let p = Encode(upstream: self).eraseToAnyType()
		Enviroment.Server.endPoints.add(returns: "\(Output.self)", point: p)
//		return p
		self.setup()
	}
}
