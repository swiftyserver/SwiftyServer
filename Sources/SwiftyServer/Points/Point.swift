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

	func perform(on enviroment: inout Enviroment) throws -> Output
}

extension Never: RequestEnviroment {


}

extension Never: Point {
	public typealias Enviroment = Never

	public func perform(on request: inout Enviroment) { }

	public var upstream: Never { fatalError() }
}


