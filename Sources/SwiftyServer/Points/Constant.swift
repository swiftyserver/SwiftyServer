//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation


public struct Constant<In: Point, Out>: Point {
	public typealias Enviroment = In.Enviroment

	public func perform(on request: inout Enviroment) throws -> Out {
		_ = try upstream.perform(on: &request)

		return self.value
	}


	public var upstream: In
	public typealias Output = Out

	var value: Out
}

public extension Point {
	func constant<T>(_ value: T) -> Constant<Self, T> {
		return Constant(upstream: self, value: value)
	}
}


