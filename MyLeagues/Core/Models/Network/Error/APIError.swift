//
//  APIError.swift
//  MyLeagues
//
//  Created by Guillaume Audinet on 28/07/2023.
//

import Foundation

public enum APIError: Error {
    case unexpectedAPIResponse
    case requestFailure
    
    public var localizedDescription: String {
        switch self {
            case .unexpectedAPIResponse:
                return "Réponse serveur inattendue"
            case .requestFailure:
                return "La requête a échouée"
        }
    }
}
