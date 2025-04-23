//
//  MeokuAuthService.swift
//  Meoku
//
//  Created by yeomyeongpark on 4/16/25.
//
import Foundation

// 예시: 저장된 access_token을 사용하는 방법
// let token = UserDefaults.standard.string(forKey: "access_token")

//전역변수로써 다른 서비스 코드에서도 사용 가능
let BASE_URL = "https://port-0-meokuserver-1cupyg2klv9emciy.sel5.cloudtype.app"
//let BASE_URL = "http://localhost:8080"

class AuthService {
    static let shared = AuthService()

    func login(id: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        // URL 생성이 실패할 경우 함수 실행을 중단하고 nil 처리 대신 안전하게 빠져나가기 위한 guard문 사용
        // guard let은 옵셔널을 안전하게 풀기 위한 Swift의 문법으로, 조건이 false이면 else 블록을 실행하며 함수 종료
        guard let url = URL(string: "\(BASE_URL)/api/v1/auth/login") else {
            return
        }

        // URLRequest 객체 생성 및 설정 (POST 방식, 헤더 설정)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // 요청 본문에 보낼 로그인 정보 생성
        let body = LoginRequest(id: id, password: password)

        // Codable 구조체를 JSON 데이터로 인코딩하여 HTTP Body에 설정
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }

        // 비동기 네트워크 요청 시작
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data", code: -1)))
                }
                return
            }

            do {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                   let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                   let jsonString = String(data: prettyData, encoding: .utf8) {
                    print("💬 로그인 응답 JSON:\n\(jsonString)")
                }
                
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(loginResponse))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    func refreshAccessToken(completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        guard let refreshToken = UserDefaults.standard.string(forKey: "refresh_token") else {
            completion(.failure(NSError(domain: "Invalid refresh token", code: -1)))
            return
        }
        
        guard let url = URL(string: "\(BASE_URL)/api/v1/auth/refreshAccessToken") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        // URLRequest 객체 생성 및 설정 (POST 방식, 헤더 설정)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")

        // 비동기 네트워크 요청 시작
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data", code: -1)))
                }
                return
            }

            do {
                let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
