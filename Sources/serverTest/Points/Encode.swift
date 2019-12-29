//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation


struct Encode<In: Point>: Point where In.Output: Encodable {
	typealias Enviroment = In.Enviroment

	func perform(on request: inout Enviroment) throws -> Data {
		let outPrev = try upstream.perform(on: &request)


		let encoder = JSONEncoder()

		return try encoder.encode(outPrev)
	}


	var upstream: In
	typealias Output = Data
}

struct Response<In: Point>: Point where In.Output == String {
	typealias Enviroment = In.Enviroment

	func perform(on request: inout Enviroment) throws -> Data {
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

	var upstream: In
	typealias Output = Data
}


extension Point where Output == String, Enviroment: HTTPEnviroment {
	@discardableResult
	func response() -> AnyPoint<Enviroment> {
		let p = Response(upstream: self).eraseToAnyType()
		Enviroment.Server.endPoints.add(returns: "String", point: p)
		return p
	}
}

extension Point where Output: Encodable, Enviroment: HTTPEnviroment {
	@discardableResult
	func json() -> AnyPoint<Enviroment> {
		let p = Encode(upstream: self).eraseToAnyType()
		Enviroment.Server.endPoints.add(returns: "\(Output.self)", point: p)
		return p
	}
}
