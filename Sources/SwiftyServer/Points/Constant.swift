//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation


public struct Constant<In: Point, Out>: Point {
	public typealias Enviroment = In.Enviroment

	public func perform(start enviroment: In.Enviroment, next: (Out, In.Enviroment) throws -> ()) throws {
		try upstream.perform(start: enviroment) { (_, env) in
			try next(value, env)
		}
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


