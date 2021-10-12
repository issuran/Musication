//
//  ServiceError.swift
//  Musication
//
//  Created by Tiago Oliveira on 12/10/21.
//

import Foundation

public enum ServiceError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameters encoding failed."
    case missingURL = "URL is nil."
    case notPossibleRetrieve = "Could not retrieve data."
    case parseError = "Parse error."
}
