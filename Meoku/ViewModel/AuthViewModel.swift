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
    @Published var keepLoggedIn: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var loginError: String?

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
                    UserDefaults.standard.set(self?.keepLoggedIn, forKey: "keepLoggedIn") // 상태 유지 여부 저장
                    self?.nickName = response.nickname
                    completion?()
                case .failure(let error):
                    print(error)
                    self?.loginError = error.localizedDescription
                }
            }
        }
    }
    
    @Published var isRefreshing: Bool = false
    @Published var refreshError: String?
    
    func refreshToken(completion: (() -> Void)? = nil) {
        isRefreshing = true
        refreshError = nil
        
        AuthService.shared.refreshAccessToken { [weak self] result in
            DispatchQueue.main.async {
                self?.isRefreshing = false
                switch result {
                case .success(let response):
                    UserDefaults.standard.set(response.access_token, forKey: "access_token")
                    UserDefaults.standard.set(response.refresh_token, forKey: "refresh_token")
                    completion?()
                case .failure(let error):
                    self?.refreshError = error.localizedDescription
                }
            }
        }
    }
}
