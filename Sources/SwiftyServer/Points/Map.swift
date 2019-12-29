//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation

public struct Maped<Upstream: Point, Out>: Point {
	public typealias Enviroment = Upstream.Enviroment

	public func perform(on request: inout Enviroment) throws -> Out {
		let outPrev = try upstream.perform(on: &request)

		return f(outPrev, request)
	}

	public var upstream: Upstream
	var f: (Upstream.Output, Enviroment) -> Out



	public typealias Output = Out

}


public extension Point {
	func map<O>(_ f: @escaping (Self.Output, Enviroment) -> O) -> Maped<Self, O>  {
		return Maped(upstream: self, f: f)
	}
}


