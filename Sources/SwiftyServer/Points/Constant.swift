//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation


struct Constant<In: Point, Out>: Point {
	typealias Enviroment = In.Enviroment

	func perform(on request: inout Enviroment) throws -> Out {
		_ = try upstream.perform(on: &request)

		return self.value
	}


	var upstream: In
	typealias Output = Out

	var value: Out
}

extension Point {
	func constant<T>(_ value: T) -> Constant<Self, T> {
		return Constant(upstream: self, value: value)
	}
}


