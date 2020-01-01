

public struct SQLString<PType> {
	let sqlData: String
	let params: [PartialKeyPath<PType>]
}

extension SQLString: ExpressibleByStringLiteral {
	public init(stringLiteral value: String) {
		self.sqlData = value
		self.params = []
	}
}

public struct SQLStatement {
	var sql: String
	var values: [Any]
}

extension SQLString: CustomStringConvertible {
	public var description: String {
		return "SQL<\(params.count) Parameters>\(self.sqlData)"
	}
}

extension SQLString: ExpressibleByStringInterpolation {
	public struct StringInterpolation: StringInterpolationProtocol {
		var parts: [String]

		var parameters: [PartialKeyPath<PType>]

		public init(literalCapacity: Int, interpolationCount: Int) {
			self.parts = []
			self.parameters = []
			self.parts.reserveCapacity(2*interpolationCount+1)
		}

		mutating public func appendLiteral(_ literal: String) {
			self.parts.append(literal)
		}

		mutating public func appendInterpolation(_ keypath: PartialKeyPath<PType>) {
			self.parts.append("?")
			self.parameters.append(keypath)
		}

	}

	public init(stringInterpolation: StringInterpolation) {
		self.sqlData = stringInterpolation.parts.joined()
		self.params = stringInterpolation.parameters
	}

	func generateStatement(from container: PType) -> SQLStatement {
		var values: [Any] = []
		values.reserveCapacity(params.count)

		for i in params {
			values.append(container[keyPath: i])
		}

		return SQLStatement(sql: self.sqlData, values: values)
	}
}

public protocol SQLAction {
	static var SQLString: SQLString<Self> { get }
}

public extension SQLAction {
	var statement: SQLStatement {
		return Self.SQLString.generateStatement(from: self)
	}
}


public extension HTTPEnviroment where Self: DatabaseEnviroment {
	static func simpleActionPost<A: SQLAction>(path: String, action: A.Type) -> SQLActionPoint<PostPoint<A, Self>> where A: Decodable  {
		Self.post(path, type: A.self).query()
	}
}

public protocol SQLView {
	static var SQLString: SQLString<Self> { get }
	associatedtype Result: Decodable
}

public extension SQLView {
	var statement: SQLStatement {
		return Self.SQLString.generateStatement(from: self)
	}
}
