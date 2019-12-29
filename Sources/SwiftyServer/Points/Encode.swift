//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation


public struct Encode<In: Point>: Point where In.Output: Encodable {
	public typealias Enviroment = In.Enviroment

	public func perform(on request: inout Enviroment) throws -> Data {
		let outPrev = try upstream.perform(on: &request)


		let encoder = JSONEncoder()

		return try encoder.encode(outPrev)
	}


	public var upstream: In
	public typealias Output = Data
}

public struct Response<In: Point>: Point where In.Output == String {
	public typealias Enviroment = In.Enviroment

	public func perform(on request: inout Enviroment) throws -> Data {
		let outPrev = try upstream.perform(on: &request)

		if let data = outPrev.data(using: .utf8) {
			return data
		} else {
			throw ResponseError.textEncodingError
		}
	}


	enum ResponseError: Error {
		case textEncodingError
	}

	public var upstream: In
	public typealias Output = Data
}


public extension Point where Output == String, Enviroment: HTTPEnviroment {
	@discardableResult
	func response() -> AnyPoint<Enviroment> {
		let p = Response(upstream: self).eraseToAnyType()
		Enviroment.Server.endPoints.add(returns: "String", point: p)
		return p
	}
}

public extension Point where Output: Encodable, Enviroment: HTTPEnviroment {
	@discardableResult
	func json() -> AnyPoint<Enviroment> {
		let p = Encode(upstream: self).eraseToAnyType()
		Enviroment.Server.endPoints.add(returns: "\(Output.self)", point: p)
		return p
	}
}
