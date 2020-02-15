//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation

extension Encodable {
	func validate() -> Bool {
		return true
	}
}

public struct PostPoint<O: Decodable, R: HTTPEnviroment>: Point {
	public typealias Enviroment = R

	public func perform(start enviroment: R, next: (O, R) throws -> ()) throws {
		guard let data = enviroment.httpParameters.body else {
			throw PostError.noBodyFound
		}
		try next(try JSONDecoder().decode(O.self, from: data), enviroment)
	}

	public var upstream: Never {
		fatalError()
	}
	public func setup() {
		
	}

	enum PostError: Error {
		case noBodyFound
	}

	public typealias Output = O

	var path: String

	public init(path: String) {
		R.Server.endPoints.add(path: path, method: "POST")
		R.Server.endPoints.add(type: "\(O.Type.self)")
		self.path = path
	}
}



public struct RePostPoint<In: Point, O: Decodable>: Point where In.Enviroment: HTTPEnviroment {
	public typealias Enviroment = In.Enviroment
	public func perform(start enviroment: In.Enviroment, next: (O, In.Enviroment) throws -> ()) throws {
		try upstream.perform(start: enviroment) { (_, env) in
			guard let data = enviroment.httpParameters.body else {
				throw PostError.noBodyFound
			}
			try next(try JSONDecoder().decode(O.self, from: data), env)
		}
	}

	enum PostError: Error {
		case noBodyFound
	}

	public var upstream: In
	public typealias Output = O
}

public extension RequestEnviroment where Self: HTTPEnviroment {
	static func post<T: Decodable>(_ path: String, type: T.Type) -> PostPoint<T, Self> {
		return PostPoint(path: path)
	}
}


public extension Point where Enviroment: HTTPEnviroment {
	
	func repost<T: Decodable>(type: T.Type) -> RePostPoint<Self, T> {
		return RePostPoint(upstream: self)
	}
}
