//
//  User.swift
//  SOLIDvai
//
//  Created by Bof on 14/02/23.
//

import Foundation


struct UserInput
{
    // diferencas entre struct e classe:
    // struct -> estrutura de dados que guarda valores brutos
    // classe -> struct que tem uma referencia
    
    var username: String?
    var password: String?
}

struct AuthResponse: Codable
{
    
    var accessToken: String?
    var refreshToken: String?
    var expirationDate: String?
    var username: String?

}

struct User
{
    var id: String?
    var firstName: String?
    var lastName: String?

}

protocol AuthRequester
{
    
    func requestAuth(userInput: UserInput) async -> AuthResponse?
    
}

protocol UserRequest
{
    func getAllUsers() -> [User]
}

class AuthManager: AuthRequester
{
    // singleton exemplo
    static let shared = AuthManager()
    
    private init() {} // garante q so pode instanciar dentro de si mesma
    
    func requestAuth(userInput: UserInput) async -> AuthResponse? {
        guard var urlComponents = URLComponents(string: "https://6cf4-150-161-70-2.ngrok.io/") else {return nil}
        urlComponents.path = "/login"
        urlComponents.queryItems = [
            URLQueryItem(name: "username", value: userInput.username),
            URLQueryItem(name: "password", value: userInput.password)
        ]
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = urlComponents.query?.data(using: .utf8)
        
        let session = URLSession.shared
        
        do {
            let (data, _) = try await session.data(for: request)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let authResponseDecoded = try decoder.decode(AuthResponse.self, from: data)
            return authResponseDecoded
            
        } catch {
            print("Erro \(error)")
        }
        
        return nil
    }
    
}

class APICaller {
    
}
