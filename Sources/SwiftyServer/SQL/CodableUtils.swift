//
//  File.swift
//  
//
//  Created by Muhammet Mehmet Emin Kartal on 12/31/19.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
	internal func to<T: Decodable>(object: T.Type) -> T? {
		try? JSONDecoder().decode(T.self, from: JSONSerialization.data(withJSONObject: self, options: []));
	}
}

extension Encodable {
	internal var toDictionary: [String: Any]? {
		try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self), options: []) as? [String: Any]
	}
}
