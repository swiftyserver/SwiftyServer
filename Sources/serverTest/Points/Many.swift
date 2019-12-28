//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/28/19.
//

import Foundation
//

struct ManyPoint<U: Point, P1: Point, P2: Point>: Point where P1.Enviroment == U.Enviroment, P2.Enviroment == U.Enviroment {


	func perform(on enviroment: inout Upstream.Enviroment) throws -> (P1.Output, P2.Output) {
		fatalError()
		let out = try upstream.perform(on: &enviroment)

		let p1 = in1(FixPoint(constant: out))
		let p2 = in2(FixPoint(constant: out))


		var out1: Result<P1.Output, Error>? = nil
		var out2: Result<P2.Output, Error>? = nil

//		DispatchQueue.init(label: "manypointqueue").async {
//			self.dispatch_group.enter()
//			out1 = .init(catching: { () -> P1.Output in
//				try p1.perform(on: &enviroment)
//			})
//			self.dispatch_group.leave()
//		}

//		dispatch_queue.async(group: self.dispatch_group, qos: <#T##DispatchQoS#>, flags: , execute: <#T##() -> Void#>)

//		DispatchQueue.init(label: "manypointqueue").async {
//			self.dispatch_group.enter()
//			out2 = .init(catching: { () -> P2.Output in
//				try p2.perform(on: &enviroment)
//			})
//			self.dispatch_group.leave()
//		}



		dispatch_group.wait(timeout: .distantFuture)

		if case .success(let p1) = out1 {

		}


	}

	typealias Enviroment = Upstream.Enviroment
	typealias Output = (P1.Output, P2.Output)
	typealias Upstream = U


	enum ManyError: Error {

	}

	let dispatch_group = DispatchGroup()
	let dispatch_queue = DispatchQueue.global(qos: .background)

	var upstream: U
	var in1: (FixPoint<Enviroment, U.Output>) -> (P1)
	var in2: (FixPoint<Enviroment, U.Output>) -> (P2)

}


struct FixPoint<E: RequestEnviroment, O>: Point {
	var upstream: Never { fatalError() }

	func perform(on enviroment: inout E) throws -> O {
		return self.constant
	}

	typealias Enviroment = E
	typealias Output = O

	var constant: O

//	var in1: Point
//	var in2: some Point
}

