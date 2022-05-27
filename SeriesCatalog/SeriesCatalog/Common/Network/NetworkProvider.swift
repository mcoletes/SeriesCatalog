//
//  NetworkProvider.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 27/05/22.
//

import Foundation
import Combine

typealias Publisher<T: Decodable> = AnyPublisher<T, ServiceError>

protocol NetworkProviderProtocol {
  func fetch<T: Decodable>(provider: URLRequestProtocol) async throws -> T
}

class NetworkProvider: NetworkProviderProtocol {
  
  // MARK: - Properties
  private let configuration: URLSessionConfiguration = {
    let config = URLSessionConfiguration.default
    config.httpAdditionalHeaders = ["Content-Type": "application/json"]
    
    return config
  }()
  
  private func getResponseError(response: URLResponse) -> ServiceError? {
    guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
      return .requestFailed(error: "No status code")
    }
    guard isSuccess(statusCode) else {
      return .responseUnsuccessful(statusCode: statusCode)
    }
    
    return nil
  }
  
  private func isSuccess(_ statusCode: Int) -> Bool {
    return 200..<300 ~= statusCode
  }
  
  func fetch<T: Decodable>(provider: URLRequestProtocol) async throws -> T {
    let data = try await request(provider: provider)
    do {
      return try JSONDecoder().decode(T.self, from: data)
    }
    catch let error {
      throw ServiceError.jsonParsingFailure(error: String(describing: error))
    }
  }
  
  @discardableResult
  private func request(provider: URLRequestProtocol) async throws -> Data {
    guard let request = provider.asURLRequest() else { throw ServiceError.invalidRequest }
    
    NetworkLogger.logRequest(request: request)
    
    let session = URLSession(configuration: configuration)
    
    do {
      let (data, response) = try await session.data(for: request, delegate: nil)
      NetworkLogger.logResponse(response, data)
      
      if let errorParsed = self.getResponseError(response: response) {
        NetworkLogger.logResponseError(response, data)
        throw errorParsed
      }
      return data
    } catch let error as ServiceError {
      throw error
    } catch {
      throw ServiceError.requestFailed(error: String(describing: error))
    }
  }
}
