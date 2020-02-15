//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 2/14/20.
//

import Foundation
import SwiftyServer



public struct InlineSQLPointWithOutput<In: Point, OutType: Decodable>: Point where In.Output: Encodable, In.Enviroment: DatabaseEnviroment {

	public typealias Enviroment = In.Enviroment

	public func perform(start enviroment: In.Enviroment, next: (OutType, In.Enviroment) throws -> ()) throws {
		try upstream.perform(start: enviroment) { (input, env) in
			//			try next(input, env)
		}
	}

	var sqlString: SQLString<Upstream.Output>


	public typealias Output = OutType
	public var upstream: In
}

public struct InlineSQLPoint<In: Point>: Point where In.Output: Encodable, In.Enviroment: DatabaseEnviroment {
	public typealias Enviroment = In.Enviroment

	public func perform(start enviroment: In.Enviroment, next: (In.Output, In.Enviroment) throws -> ()) throws {
		try upstream.perform(start: enviroment) { (input, env) in
			//			try next(input, env)
		}
	}
	var sqlString: SQLString<Upstream.Output>

	public typealias Output = In.Output
	public var upstream: In
}



public extension Point where Output: Codable, Enviroment: DatabaseEnviroment {
	func sql<O: Decodable>(_ string: SQLString<Self.Output>, output: O.Type) -> InlineSQLPointWithOutput<Self, O> {
		return InlineSQLPointWithOutput(sqlString: string, upstream: self)
	}
}
