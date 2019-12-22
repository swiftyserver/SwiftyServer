//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation

struct Maped<Upstream: Point, Out>: Point {
	typealias Enviroment = Upstream.Enviroment

	func perform(on request: inout Enviroment) throws -> Out {
		let outPrev = try upstream.perform(on: &request)

		return f(outPrev, request)
	}

	var upstream: Upstream
	var f: (Upstream.Output, Enviroment) -> Out



	typealias Output = Out

}


extension Point {
	func map<O>(_ f: @escaping (Self.Output, Enviroment) -> O) -> Maped<Self, O>  {
		return Maped(upstream: self, f: f)
	}
}


