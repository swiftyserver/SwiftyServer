//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation

struct GetPoint<R: HTTPEnviroment>: Point {
	typealias Enviroment = R

	func perform(on request: inout Enviroment) -> () {
		return ()
	}

	var upstream: Never {
		fatalError()
	}

	var path: String
}

struct DynamicGetPoint<P: Decodable, R: HTTPEnviroment>: Point {
	typealias Enviroment = R
	func perform(on request: inout Enviroment) throws  -> P {
		return try JSONDecoder().decode(P.self, from: Data())
	}

	var upstream: Never {
		fatalError()
	}

	typealias Output = P

	var path: DynamicGetPath<P>
}


extension RequestEnviroment where Self: HTTPEnviroment {
	static func get(_ path: String) -> GetPoint<Self> {
		return GetPoint(path: path)
	}


	static func get<O>(_ path: DynamicGetPath<O>, type: O.Type) -> DynamicGetPoint<O, Self> {
		return DynamicGetPoint<O, Self>(path: path)
	}
}
