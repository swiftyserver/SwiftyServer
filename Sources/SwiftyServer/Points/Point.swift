//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/12/19.
//

import Foundation

public protocol Point {
	associatedtype Upstream: Point = Never
	associatedtype Output = Void
	associatedtype Enviroment: RequestEnviroment

	var upstream: Upstream { get }

//	func perform(on enviroment: inout Enviroment) throws -> Output
	func perform(start enviroment: Enviroment, next: (Output, Enviroment) throws -> ()) throws
	func setup()
}


extension Point {
	public func setup() {
		upstream.setup()
	}
}

extension Never: RequestEnviroment {  }

extension Never: Point {
	public typealias Enviroment = Never

	public func perform(start: Never, next: ((), Never) throws -> ()) throws { }

	public var upstream: Never { fatalError() }
}


