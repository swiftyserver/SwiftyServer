//
//  File 3.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation


public struct SQLActionPoint<In: Point>: Point where In.Output: SQLAction, In.Enviroment: DatabaseEnviroment {
	public typealias Enviroment = In.Enviroment


	public func perform(start enviroment: In.Enviroment, next: (In.Output, In.Enviroment) throws -> ()) throws {
		try upstream.perform(start: enviroment) { (input, env) in
			try Enviroment.connection.perform(action: input, callback: {
				try next(input, env)
			})
		}
	}

	public func setup() {
		print("Setup")
	}

	public typealias Output = In.Output
	public var upstream: In
}


public struct SQLViewPoint<In: Point>: Point where In.Output: SQLView, In.Enviroment: DatabaseEnviroment{
	public typealias Enviroment = In.Enviroment

	public func perform(start enviroment: In.Enviroment, next: (In.Output.Result, In.Enviroment) throws -> ()) throws {
		try upstream.perform(start: enviroment) { (input, env) in

			try next(JSONDecoder().decode(In.Output.Result.self, from: Data()), env)

		}
	}
	public var upstream: In
	public typealias Output = In.Output.Result
}

public struct SQLArrayViewPoint<In: Point, O>: Point where In: SQLView, In.Result == [O], In.Enviroment: DatabaseEnviroment {
	public typealias Enviroment = In.Enviroment


	public func perform(start enviroment: In.Enviroment, next: ([O], In.Enviroment) throws -> ()) throws {
		try upstream.perform(start: enviroment) { (input, env) in
			try next(JSONDecoder().decode([O].self, from: Data()), env)
		}
	}
	public var upstream: In
	public typealias Output = In.Result
}


public extension Point where Output: SQLAction, Enviroment: DatabaseEnviroment {
	func query() -> SQLActionPoint<Self> {
		return SQLActionPoint(upstream: self)
	}
}


public extension Point where Output: SQLView, Enviroment: DatabaseEnviroment {
	func getQuery() -> SQLViewPoint<Self> {
		return SQLViewPoint(upstream: self)
	}

	func getAll<E>() -> SQLArrayViewPoint<Self, E> where Output.Result == [E] {
		return SQLArrayViewPoint(upstream: self)
	}
}


public extension Point where Output: SQLView, Output.Result == Array<Any>, Enviroment: DatabaseEnviroment {
	func get() -> SQLViewPoint<Self> {
		return SQLViewPoint(upstream: self)
	}
}
