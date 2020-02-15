//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation

public struct GetPoint<R: HTTPEnviroment>: Point {
	public func perform(start enviroment: R, next: ((), R) throws -> ()) throws {
		try next((), enviroment)
	}


	public typealias Enviroment = R

	public func perform(on request: inout Enviroment) -> () {
		return ()
	}

	public var upstream: Never {
		fatalError()
	}

	public var path: String

	public init(path: String) {
		R.Server.endPoints.add(path: path, method: "GET")
		self.path = path
	}
}

public struct DynamicGetPoint<P: Decodable, R: HTTPEnviroment>: Point {
	public typealias Enviroment = R

	public func perform(start enviroment: R, next: (P, R) throws -> ()) throws {
		try next(try JSONDecoder().decode(P.self, from: Data()), enviroment)
	}


	public func perform(on request: inout Enviroment) throws  -> P {
		return try JSONDecoder().decode(P.self, from: Data())
	}

	public var upstream: Never {
		fatalError()
	}

	public typealias Output = P

	var path: DynamicGetPath<P>

	public init(path: DynamicGetPath<P>) {
		self.path = path
	}
}


public extension RequestEnviroment where Self: HTTPEnviroment {
	static func get(_ path: String) -> GetPoint<Self> {
		return GetPoint(path: path)
	}

	@available(*, unavailable, message: "This feature is not yet enabled!")
	static func get<O>(_ path: DynamicGetPath<O>, type: O.Type) -> DynamicGetPoint<O, Self> {
		return DynamicGetPoint<O, Self>(path: path)
	}
}
