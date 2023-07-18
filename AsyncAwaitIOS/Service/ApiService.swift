//
//  ApiService.swift
//  AsyncAwaitIOS
//
//  Created by Rezaul Islam on 17/7/23.
//

import Foundation
import UIKit

struct APIService {
    let urlString: String = "https://digicomapi.diatomicsoft.com"
    
    func getJSON<T: Decodable>(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                               keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                               endPoint:String
    ) async throws -> T {
        guard
            let url = URL(string: urlString+endPoint)
        else {
            throw APIError.invalidURL
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode <= 299
            else {
                 
                throw APIError.invalidResponseStatus
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                
                return decodedData
            } catch {
                throw APIError.decodingError(error.localizedDescription)
            }
        } catch {
            throw APIError.dataTaskError(error.localizedDescription)
        }
    }
    
    func uploadMultipartFormData<T: Codable>(object: T, image: UIImage, keyForImage: String) async throws {
        let mirror = Mirror(reflecting: object)
        
        var formDataFields = [(String, String)]()
        
        for (label, value) in mirror.children {
            if let label = label, let value = value as? String {
                formDataFields.append((label, value))
            }
        }
        
        guard !formDataFields.isEmpty else {
            throw APIError.invalidFormData
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw APIError.corruptData
        }
        
        let boundary = UUID().uuidString
        let contentType = "multipart/form-data; boundary=\(boundary)"
        
        guard let url = URL(string: urlString+"/api/career/add") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Generate a unique filename for the image
         let uniqueFilename = "\(UUID().uuidString).jpg"
        
        // Append image data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(keyForImage)\"; filename=\"\(uniqueFilename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Append other form data fields
        for (key, value) in formDataFields {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append(value.data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Close the multipart form data body
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // Process the response data
            
        } catch let error {
            throw APIError.dataTaskError(error.localizedDescription)
        }
    }

    
    
}





enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponseStatus
    case dataTaskError(String)
    case corruptData
    case decodingError(String)
    case invalidFormData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("The endpoint URL is invalid", comment: "")
        case .invalidResponseStatus:
            return NSLocalizedString("The API failed to issue a valid response.", comment: "")
        case .dataTaskError(let string):
            return string
        case .corruptData:
            return NSLocalizedString("The data provided appears to be corrupt", comment: "")
        case .invalidFormData:
            return NSLocalizedString("invalid form data", comment: "")
        case .decodingError(let string):
            return string
        }
    }
}
