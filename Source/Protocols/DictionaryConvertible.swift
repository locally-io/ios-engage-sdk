//
//  DictionaryConvertible.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 15/12/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation

protocol DictionaryConvertible {
	func toDictionary() -> [AnyHashable: Any]?
	static func fromDictionary(dictionary: [AnyHashable: Any]) -> Self?
}

extension DictionaryConvertible where Self: Codable {

	func toDictionary() -> [AnyHashable: Any]? {
		guard let encoded = try? JSONEncoder().encode(self) else { return nil }
		guard let jsonObject = try? JSONSerialization.jsonObject(with: encoded, options: []) else { return nil }
		return jsonObject as? [String: AnyObject]
	}

	static func fromDictionary(dictionary: [AnyHashable: Any]) -> Self? {
		guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else { return nil }
		guard let content = try? JSONDecoder().decode(self, from: data) else { return nil }
		return content
	}
}
