//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/21/19.
//

import Foundation



public struct DynamicGetPath<PType> {
	let path: String
	var parameters: [String: GetKeyPathStorage<PType>]
}

enum GetKeyPathStorage<Root> {
	case int(KeyPath<Root, Int>)

	case string(KeyPath<Root, String>)

	case uuid(KeyPath<Root, UUID>)
}

extension AnyKeyPath {
    /// Returns key path represented as a string
    var asString: String? {
        return _kvcKeyPathString?.description
    }
}


extension DynamicGetPath: ExpressibleByStringInterpolation {

	public struct StringInterpolation: StringInterpolationProtocol {
		var parts: [String]

		var parameters: [String: GetKeyPathStorage<PType>]

		public init(literalCapacity: Int, interpolationCount: Int) {
			self.parts = []
			self.parameters = [:]
			self.parts.reserveCapacity(2*interpolationCount+1)
		}

		mutating public func appendLiteral(_ literal: String) {
			parts.append(literal)
		}

		mutating public func appendInterpolation(_ keypath: KeyPath<PType, Int>) {
			let s = ":param_\(keypath.hashValue)"

			parts.append(s)
			self.parameters[s] = .int(keypath)
		}

		mutating public func appendInterpolation(_ keypath: KeyPath<PType, String>) {
			let s = ":param_\(keypath.hashValue)"

			parts.append(s)
			self.parameters[s] = .string(keypath)
		}

		mutating public func appendInterpolation(_ keypath: KeyPath<PType, UUID>) {
			let s = ":param_\(keypath.hashValue)"

			parts.append(s)
			self.parameters[s] = .uuid(keypath)
		}

	}

	public init(stringInterpolation: StringInterpolation) {
		self.parameters = stringInterpolation.parameters
		self.path = stringInterpolation.parts.joined(separator: "")
	}

}

extension DynamicGetPath: ExpressibleByStringLiteral {
	public init(stringLiteral value: String) {
		self.path = value
		self.parameters = [:]
	}
}
