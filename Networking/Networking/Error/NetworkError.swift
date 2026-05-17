//
//  NetworkError.swift
//  Networking
//
//  Created by user on 17.05.2026.
//

import Foundation

enum NetworkError: Error, LocalizedError{
  case transport(URLError)
  case invalidResponse
  case httpStatus(code: Int)
  case decodingFailure(Error)
  case unknown(Error)
  
  var statusCode: Int?{
	 guard case .httpStatus(let code) = self else {
		return nil
	 }
	 return code
  }
  
  var userMessage: String{
	 switch self {
	 case .transport(let urlError):
		switch urlError.code {
		case .notConnectedToInternet:
		  return "No internet connection. Check your internet connection and try again."
		  
		case .timedOut:
		  return "The request timed out. Please try again."
		
		default:
		  return "A network error occured. Please try again."
		}
	 case .invalidResponse:
		return "The Server returned an invalid response"
	 case .httpStatus(let code):
		switch code{
		case 401:
		  return "You are not authorized to access this content."
		case 403:
		  return "You do not have permission to perform this action."
		case 404:
		  return "The requested resource was not found."
		case 409:
		  return "The action conflicts with existing data."
		case 429:
		  return "Too many request. Please wait a moment and try again again."
		case 500...599:
		  return "The server is having trouble right now. Please try again later."
		default:
		  return "Something went wrong. Try again"
		}
	 case .decodingFailure(let error):
		return "We received data in an unexpected format."
	 case .unknown(let error):
		return "Something went wrong. Try again"
	 }
  }
  
  var debugMessage: String{
	 switch self {
	 case .transport(let urlError):
		return "Transport Error: \(urlError.code), \(urlError.localizedDescription)"
	 case .invalidResponse:
		return "Invalid non-HTTP response"
	 case .httpStatus(let code):
		return "HTTP Error \(code)"
	 case .decodingFailure(let error):
		return "Decoding failed: \(error)"
	 case .unknown(let error):
		return "Unknown error: \(error.localizedDescription)"
	 }
  }
  
  var errorDescription: String? { userMessage }
  
}



enum NetworkErrorMapper{
  static func map(_ error: Error) -> NetworkError{
	 if let error = error as? NetworkError {
		return error
	 }else if let error = error as? URLError {
		return .transport(error)
	 }
	 return .unknown(error)
  }
  
  static func httpStatus(_ code: Int) -> NetworkError{
	 .httpStatus(code: code)
  }
  
  static func decodeFailure(_ error: Error) -> NetworkError{
	 .decodingFailure(error)
  }
}
