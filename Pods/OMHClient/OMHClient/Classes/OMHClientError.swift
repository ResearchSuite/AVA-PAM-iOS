//
//  OMHClientError.swift
//  Pods
//
//  Created by James Kizer on 1/7/17.
//
//

import UIKit

public enum OMHClientError: Error {
    
    //our errors
    
    case serverError(error: String, errorDescription: String)
    
    //credentials failure : signIn
    case credentialsFailure(descrition: String)
    //invalid access token: postSample
    case invalidAccessToken
    //invalid refresh token: refreshAccessToken
    case invalidRefreshToken
    
    //we've already uploaded a datapoint with this id
    //server returns a 409
    case dataPointConflict
    
    //server returns a 502
    case badGatewayError
    
    //invalid response for signIn / refreshAccessToken 
    //e.g., expected field missing in json
    case malformedResponse(responseBody: Any)
    
    //other errors to watch out for
    
    //unreachable
    //convert into our own
    case unreachableError(underlyingError: NSError?)
    
    //others
    case otherError(underlyingError: NSError?)
    
    //If datapoint fails json serialization
    case invalidDatapoint
    
}

extension OMHClientError {
    
    /// The `underlyingError` associated with the error.
    public var underlyingError: NSError? {
        switch self {
        case .unreachableError(let error):
            return error
        case .otherError(let error):
            return error
        default:
            return nil
        }
    }
    
    public var malformedResponseBody: Any? {
        switch self {
        case .malformedResponse(let responseBody):
            return responseBody
        default:
            return nil
        }
    }

}
