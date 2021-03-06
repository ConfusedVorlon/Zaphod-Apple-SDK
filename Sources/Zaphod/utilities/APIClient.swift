//
//  File.swift
//  
//
//  https://tim.engineering/break-up-third-party-networking-urlsession/
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}

struct HTTPHeader {
    let field: String
    let value: String
}

class APIRequest {
    let url: URL
    let method: HTTPMethod
    private var headers: [HTTPHeader] = []
    var body: Data?
    
    /// Standard Request
    /// - Parameters:
    ///   - method: method
    ///   - url: url
    init(method: HTTPMethod, url: URL) {
        self.method = method
        self.url = url
    }
    
    
    /// Request with json body upload
    /// - Parameters:
    ///   - method: method
    ///   - url: url
    ///   - body: json encodable body
    init<Body: Encodable>(method: HTTPMethod, url: URL, body: Body) throws {
        self.method = method
        self.url = url
        self.body = try JSONEncoder().encode(body)

        add(header: HTTPHeader(field: "Content-type", value: "application/json"))
    }

    func add(header: HTTPHeader) {
        headers.append(header)
    }
    
    /// Http Auth header
    /// - Parameter token: password
    func authorise(token: String) {
        add(header: HTTPHeader(field: "Authorization", value: token))
    }

    fileprivate var urlRequest: URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = body

        headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }

        return urlRequest
    }
}

enum APIError: Error {
    case invalidURL
    case requestFailed(networkError: Error?)
    case decodingFailure
    case statusNotOK(code: Int)
    case noDataInResponse
}

struct APIClient<ResponseType> where ResponseType: Decodable {
    typealias APIClientCompletion<Body> = (Result<Body, APIError>) -> Void

    private let session = URLSession.shared

    func fetch(_ request: APIRequest, _ completion: @escaping APIClientCompletion<ResponseType>) {

        let task = session.dataTask(with: request.urlRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(networkError: error)))
                return
            }
            let statusCode = httpResponse.statusCode
            if statusCode != 200 {
                if statusCode == 401 {
                    print("Zaphod: Access denied - Please check your Zaphod Token is correct")
                }
                completion(.failure(.statusNotOK(code: statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(.noDataInResponse))
                return
            }

            guard let response: ResponseType = data.decode() else {
                completion(.failure(.decodingFailure))
                return
            }

            completion(.success(response))
        }
        task.resume()
    }

}
