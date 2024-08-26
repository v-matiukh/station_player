//
//  Network.swift
//  station-player
//
//  Created by Volodymyr Matiukh on 24.08.2024.
//

import Foundation
import Combine

protocol Requestable {
    func fetchStations() async -> Result<[Station], NetworkError>
}

enum NetworkError: Error, Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
            switch (lhs, rhs) {
            case (.invalidURL, .invalidURL):
                return true
            case (.requestFailed(let lhsError), .requestFailed(let rhsError)):
                return lhsError.localizedDescription == rhsError.localizedDescription
            case (.decodingError(let lhsError), .decodingError(let rhsError)):
                return lhsError.localizedDescription == rhsError.localizedDescription
            case (.unknown, .unknown):
                return true
            default:
                return false
            }
        }
    
    case invalidURL
    case requestFailed(Error)
    case decodingError(Error)
    case unknown
    var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "The URL is invalid. Please check and try again."
            case .requestFailed:
                return "The network request failed. Please check your connection."
            case .decodingError(let error):
                return "Failed to decode the data: \(error.localizedDescription)"
            case .unknown:
                return "Something wrong. Please contact our support"
            }
        }
}

enum Constants {
    enum URL: String {
        case baseURL = "https://s3-us-west-1.amazonaws.com/cdn-web.tunein.com"
    }
}

class NetworkService: Requestable {
    
    var cancellables = Set<AnyCancellable>()
    private let baseURL: String
    
    enum RequestPath: String {
        case stations = "/stations.json"
    }
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    private func urlForRequest(path: RequestPath) throws -> URL {
        guard let url = URL(string: baseURL + path.rawValue) else {
            throw NetworkError.invalidURL
        }
        return url
    }
    
    func fetchStations() async -> Result<[Station], NetworkError> {
        
        do {
            
            let url = try urlForRequest(path: .stations)
            // Perform the network request
            let (data, response) = try await URLSession.shared.data(from:url)
            
            // Check the HTTP response status
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return .failure(.unknown)
            }
            
            // Decode the JSON data into the Station array
            let stationsResponse = try JSONDecoder().decode(StationResponse.self, from: data)
            return .success(stationsResponse.data)
        } catch let networkError as NetworkError {
            return .failure(networkError)
        } catch let decodingError as DecodingError {
            print(decodingError)
            return .failure(.decodingError(decodingError))
        } catch {
            return .failure(.requestFailed(error))
        }
    }
}
