//
//  NetworkLogger.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 27/05/22.
//

import Foundation

class NetworkLogger {
  
  static func logRequest(request: URLRequest) {
#if DEBUG
    var requestDebugLog = "\n==REQUEST===============================================\n"
    requestDebugLog += "🎯🎯🎯 URL: \(request.url?.absoluteString ?? "")\n"
    requestDebugLog += "-----------------------------------------------------------\n"
    requestDebugLog += "⚒⚒⚒ HTTP METHOD: \(request.httpMethod ?? "")\n"
    requestDebugLog += "-----------------------------------------------------------\n"
    requestDebugLog += "📝📝📝 HEADERS: \(request.allHTTPHeaderFields ?? [:])\n"
    requestDebugLog += "-----------------------------------------------------------\n"
    print(requestDebugLog)
#endif
  }
  
  static func logResponse(_ response: URLResponse?, _ data: Data?) {
#if DEBUG
    var responseDebugLog = "\n==RESPONSE==============================================\n"
    responseDebugLog += "🎯🎯🎯 URL: \(response?.url?.absoluteString ?? "")\n"
    responseDebugLog += "-----------------------------------------------------------\n"
    responseDebugLog += "✅✅✅ STATUS CODE: \((response as? HTTPURLResponse)?.statusCode ?? -1)\n"
    responseDebugLog += "-----------------------------------------------------------\n"
    responseDebugLog += "📝📝📝 HEADERS: \((response as? HTTPURLResponse)?.allHeaderFields as? [String: String] ?? [:])\n"
    responseDebugLog += "-----------------------------------------------------------\n"
    
    if let dataObj = data {
      do {
        let json = try JSONSerialization.jsonObject(with: dataObj, options: .mutableContainers)
        let prettyPrintedData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        responseDebugLog += "📎📎📎 RESPONSE DATA: \n\(String(bytes: prettyPrintedData, encoding: .utf8) ?? "")"
      } catch {
        responseDebugLog += "📎📎📎 RESPONSE DATA: \n\(String(data: dataObj, encoding: .utf8) ?? "")"
      }
      responseDebugLog += "\n"
    }
    responseDebugLog += "===========================================================\n"
    print(responseDebugLog)
#endif
  }
  
  static func logResponseError(_ response: URLResponse?, _ data: Data?) {
#if DEBUG
    var responseDebugLog = "\n==RESPONSE==============================================\n"
    responseDebugLog += "🎯🎯🎯 URL: \(response?.url?.absoluteString ?? "")\n"
    responseDebugLog += "-----------------------------------------------------------\n"
    responseDebugLog += "⚠️⚠️⚠️ STATUS CODE: \((response as? HTTPURLResponse)?.statusCode ?? -1)\n"
    responseDebugLog += "-----------------------------------------------------------\n"
    responseDebugLog += "📒📒📒 HEADERS: \((response as? HTTPURLResponse)?.allHeaderFields as? [String: String] ?? [:])\n"
    responseDebugLog += "-----------------------------------------------------------\n"
    
    if let dataObj = data {
      do {
        let json = try JSONSerialization.jsonObject(with: dataObj, options: .mutableContainers)
        let prettyPrintedData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        responseDebugLog += "📎📎📎 🧨🧨🧨 RESPONSE ERROR: \n\(String(bytes: prettyPrintedData, encoding: .utf8) ?? "")"
      } catch {
        responseDebugLog += "📎📎📎  🧨🧨🧨 RESPONSE ERROR: \n\(String(data: dataObj, encoding: .utf8) ?? "")"
      }
      responseDebugLog += "\n"
    }
    
    responseDebugLog += "===========================================================\n"
    print(responseDebugLog)
#endif
  }
}
