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


extension Point where Output: Encodable {
	@discardableResult
	func response() -> AnyPoint<Enviroment> {
		return Encode(upstream: self).eraseToAnyType()
	}
}
