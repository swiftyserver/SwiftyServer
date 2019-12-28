//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/12/19.
//

import Foundation

protocol Point {
	associatedtype Upstream: Point = Never
	associatedtype Output = Void
	associatedtype Enviroment: RequestEnviroment

	var upstream: Upstream { get }

	func perform(on enviroment: inout Enviroment) throws -> Output
//	func performNew(on enviroment: inout Enviroment, callback: () -> Output) throws
}

extension Never: RequestEnviroment { }

extension Never: Point {
	typealias Enviroment = Never

	func perform(on request: inout Enviroment) { }

	var upstream: Never { fatalError() }
}


