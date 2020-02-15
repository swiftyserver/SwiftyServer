//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation


public struct AnyPoint<R: RequestEnviroment>: Point {
	public func perform(start enviroment: R, next: (Data, Enviroment) throws -> ()) throws {
		try fpoint(enviroment, { input, env in
			try next(input, env)
		})
	}

	public typealias Enviroment = R

	public var upstream: Never {
		fatalError()
	}

	public typealias Output = Data

	var fpoint: (Enviroment, (Data, Enviroment) throws -> ()) throws -> ()



	init<P: Point>(erase point: P) where P.Enviroment == Enviroment, P.Output == Data {
		self.fpoint = point.perform(start:next:)
	}
}

//struct HTTPPoint {
//	var point: (inout HTTPEnviroment) throws -> Data
//}

public extension Point where Output == Data {
	func eraseToAnyType() -> AnyPoint<Self.Enviroment> {
		return AnyPoint(erase: self)
	}
}


//extension Point where Output == Data, Self.Enviroment: HTTPEnviroment {
//	func httpResponce() -> HTTPPoint {
//
//		let env = HTTPEnviroment.init(request: HTTPRequest(path: "", type: "", body: nil, cookies: [:], headers: [:]))
//		self.perform(on: &env)
//
//		return HTTPPoint(point: self.perform as! (inout HTTPEnviroment) throws -> Data)
//	}
//}
