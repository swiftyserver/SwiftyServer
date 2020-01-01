//
//  File 3.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation


public struct SQLActionPoint<In: Point>: Point where In.Output: SQLAction, In.Enviroment: DatabaseEnviroment {
	public typealias Enviroment = In.Enviroment


	public func perform(on request: inout Enviroment) throws -> In.Output {
		let outPrev = try upstream.perform(on: &request)


		try Enviroment.connection.perform(action: outPrev)
		

		print("Perform \(outPrev)")


		return outPrev
	}


	public typealias Output = In.Output
	public var upstream: In
}


public struct SQLViewPoint<In: Point>: Point where In.Output: SQLView, In.Enviroment: DatabaseEnviroment{
	public typealias Enviroment = In.Enviroment

	public func perform(on request: inout Enviroment) throws -> In.Output.Result {

		let outPrev = try upstream.perform(on: &request)

		print("Perform \(outPrev)")

		return try JSONDecoder().decode(In.Output.Result.self, from: Data())
	}

	public var upstream: In
	public typealias Output = In.Output.Result
}

public struct SQLArrayViewPoint<In: Point, O>: Point where In: SQLView, In.Result == Array<O>, In.Enviroment: DatabaseEnviroment {
	public typealias Enviroment = In.Enviroment


	public func perform(on request: inout Enviroment) throws -> In.Result {

		let outPrev = try upstream.perform(on: &request)

		print("Perform \(outPrev)")

		return try JSONDecoder().decode(In.Result.self, from: Data())
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

	func getAll<E>() -> SQLArrayViewPoint<Self, E> where Output.Result == Array<E> {
		return SQLArrayViewPoint(upstream: self)
	}
}


public extension Point where Output: SQLView, Output.Result == Array<Any>, Enviroment: DatabaseEnviroment {
	func get() -> SQLViewPoint<Self> {
		return SQLViewPoint(upstream: self)
	}
}
