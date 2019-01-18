//
//  AuthorizedService.swift
//  EngageSDK
//
//  Created by Eduardo Dias on 14/10/18.
//  Copyright © 2018 Locally. All rights reserved.
//

import Foundation
import PromiseKit

/// This protocol defines GET and POST authorized operations
protocol AuthorizedService: NetworkService {
	static func getAuthorized<Data: Decodable>(url: String) -> Promise<Data>
	static func postAuthorized<RequestData: Encodable, ResultData: Decodable>(url: String, requestData: RequestData) -> Promise<ResultData>
}

extension AuthorizedService {

	/// Creates an authorized header
	static var authorizedHeader: Promise<[String: String]> {
		return firstly {
			AuthenticationManager.accessToken()
		}.map { accessToken in
			["Authorization": "Bearer \(accessToken)"]
		}
	}

	/// Performs an authorized GET network operation
	///
	/// - Parameter url: A string representing the end-point URL
	/// - Returns: A decodable data requested by the client
	static func getAuthorized<Data: Decodable>(url: String) -> Promise<Data> {
		return authorizedHeader.then { authorizedHeader -> Promise<Data> in
			GET(url: url, headers: authorizedHeader)
		}
	}

	/// Performs an authorized POST network operation
	///
	/// - Parameters:
	///   - url: A string representing the end-point URL
	///   - requestData: An encodable data passed by the client
	/// - Returns: A decodable data requested by the client
	static func postAuthorized<RequestData: Encodable, ResultData: Decodable>(url: String, requestData: RequestData) -> Promise<ResultData> {
		return authorizedHeader.then { authorizedHeader -> Promise<ResultData> in
			POST(url: url, requestData: requestData, headers: authorizedHeader)
		}
	}
}
