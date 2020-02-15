//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation

public struct Maped<Upstream: Point, Out>: Point {
	public func perform(start enviroment: Enviroment, next: (Out, Upstream.Enviroment) throws -> ()) throws {
		try upstream.perform(start: enviroment, next: { (prevOut, prevEnviroment) in
			try next(f(prevOut, prevEnviroment), prevEnviroment)
		})
	}

	public typealias Enviroment = Upstream.Enviroment

	public var upstream: Upstream
	var f: (Upstream.Output, Enviroment) -> Out



	public typealias Output = Out

}


public extension Point {
	func map<O>(_ f: @escaping (Self.Output, Enviroment) -> O) -> Maped<Self, O>  {
		return Maped(upstream: self, f: f)
	}
}


