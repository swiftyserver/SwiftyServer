//
//  File 3.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation


struct SQLActionPoint<In: Point>: Point where In.Output: SQLAction, In.Enviroment: DatabaseEnviroment {
	typealias Enviroment = In.Enviroment


	func perform(on request: inout Enviroment) throws -> In.Output {
		let outPrev = try upstream.perform(on: &request)



		print("Perform \(outPrev)")
		return outPrev
	}


	typealias Output = In.Output
	var upstream: In
}


struct SQLViewPoint<In: Point>: Point where In.Output: SQLView, In.Enviroment: DatabaseEnviroment{
	typealias Enviroment = In.Enviroment

	func perform(on request: inout Enviroment) throws -> In.Output.Result {

		let outPrev = try upstream.perform(on: &request)

		print("Perform \(outPrev)")

		return try JSONDecoder().decode(In.Output.Result.self, from: Data())
	}

	var upstream: In
	typealias Output = In.Output.Result
}

struct SQLArrayViewPoint<In: Point, O>: Point where In: SQLView, In.Result == Array<O>, In.Enviroment: DatabaseEnviroment {
	typealias Enviroment = In.Enviroment


	func perform(on request: inout Enviroment) throws -> In.Result {

		let outPrev = try upstream.perform(on: &request)

		print("Perform \(outPrev)")

		return try JSONDecoder().decode(In.Result.self, from: Data())
	}

	var upstream: In
	typealias Output = In.Result
}


extension Point where Output: SQLAction, Enviroment: DatabaseEnviroment {
	func query() -> SQLActionPoint<Self> {
		return SQLActionPoint(upstream: self)
	}
}


extension Point where Output: SQLView, Enviroment: DatabaseEnviroment {
	func getQuery() -> SQLViewPoint<Self> {
		return SQLViewPoint(upstream: self)
	}

	func getAll<E>() -> SQLArrayViewPoint<Self, E> where Output.Result == Array<E> {
		return SQLArrayViewPoint(upstream: self)
	}
}


extension Point where Output: SQLView, Output.Result == Array<Any>, Enviroment: DatabaseEnviroment {
	func get() -> SQLViewPoint<Self> {
		return SQLViewPoint(upstream: self)
	}
}
