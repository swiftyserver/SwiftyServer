//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation


struct AnyPoint<R: RequestEnviroment>: Point {
	typealias Enviroment = R

	var upstream: Never {
		fatalError()
	}

	typealias Output = Data

	var fpoint: (inout Enviroment) throws -> Data


	func perform(on request: inout Enviroment) throws -> Data {
		return try fpoint(&request)
	}

	init<P: Point>(point: P) where P.Enviroment == Enviroment, P.Output == Data {
		self.fpoint = point.perform
	}
}

extension Point where Output == Data {
	func eraseToAnyType() -> AnyPoint<Self.Enviroment> {
		return AnyPoint(point: self)
	}
}
