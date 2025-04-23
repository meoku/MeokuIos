//
//  Untitled.swift
//  Meoku
//
//  Created by yeomyeongpark on 4/17/25.
//
import Foundation

class AuthViewModel: ObservableObject {
    @Published var userId: String = ""
    @Published var password: String = ""
    @Published var nickName: String? = nil
    @Published var isLoggedIn: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var loginError: String?

    //로그인상태 체크, 만약 리프레시토큰도 만료가 아직 안됐으면 재갱신
    func checkLoginStatusAndRefreshTokens(){
        if let accessToken = UserDefaults.standard.string(forKey: "access_token"), !isExpired(accessToken) {
            isLoggedIn = true
        } else if let refreshToken = UserDefaults.standard.string(forKey: "refresh_token"), !isExpired(refreshToken) {
            refreshAccessToken { success in
                DispatchQueue.main.async {
                    self.isLoggedIn = success
                }
            }
        } else { //엑세스, 리프레시 모두 만료거나 없을때
            isLoggedIn = false
            nickName = nil
        }
    }
    
    // 엑세스토큰 만료 확인
    func isExpired(_ jwt: String) -> Bool {
        let segments = jwt.split(separator: ".")
        guard segments.count == 3 else { return true }

        let payloadSegment = segments[1]
        
        // Base64 디코딩
        var base64 = String(payloadSegment)
        base64 = base64.padding(toLength: ((base64.count+3)/4)*4, withPad: "=", startingAt: 0)
        
        guard let data = Data(base64Encoded: base64),
              let payload = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let exp = payload["exp"] as? TimeInterval else {
            return true
        }

        let expDate = Date(timeIntervalSince1970: exp)
        return Date() >= expDate
    }
    // 로그인
    func login(completion: (() -> Void)? = nil) {
        isLoading = true
        loginError = nil

        AuthService.shared.login(id: userId, password: password) { [weak self] result in
            //print(self?.userId ?? "no user id")
            //print(self?.password ?? "no password")
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    UserDefaults.standard.set(response.access_token, forKey: "access_token")
                    UserDefaults.standard.set(response.refresh_token, forKey: "refresh_token")
//                    UserDefaults.standard.set(self?.keepLoggedIn, forKey: "keepLoggedIn") // 상태 유지 여부 저장
                    self?.nickName = response.nickname
                    completion?()
                case .failure(let error):
                    print(error)
                    self?.loginError = error.localizedDescription
                }
            }
        }
    }
    
    // 로그아웃
    func logout() {
        UserDefaults.standard.removeObject(forKey: "access_token")
        UserDefaults.standard.removeObject(forKey: "refresh_token")
        nickName = nil
        isLoggedIn = false
    }
    
    @Published var isRefreshing: Bool = false
    @Published var refreshError: String?
    // 리프레시토큰으로 트큰 갱신
    func refreshAccessToken(completion: ((Bool) -> Void)? = nil) {
        isRefreshing = true
        refreshError = nil
        
        AuthService.shared.refreshAccessToken { [weak self] result in
            DispatchQueue.main.async {
                self?.isRefreshing = false
                switch result {
                case .success(let response):
                    UserDefaults.standard.set(response.access_token, forKey: "access_token")
                    UserDefaults.standard.set(response.refresh_token, forKey: "refresh_token")
                case .failure(let error):
                    self?.refreshError = error.localizedDescription
                }
            }
        }
    }
}
