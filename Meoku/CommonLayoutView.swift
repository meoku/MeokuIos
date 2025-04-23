//
//  CommonLayoutView.swift
//  Meoku
//
//  Created by yeomyeongpark on 4/20/25.
//

import SwiftUI

struct CommonLayoutView<Content: View>: View {
    @Binding var showSidebar: Bool
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @EnvironmentObject var authViewModel: AuthViewModel
    let content: Content

    init(showSidebar: Binding<Bool>, showAlert: Binding<Bool>, alertMessage: Binding<String>, @ViewBuilder content: () -> Content) {
        self._showSidebar = showSidebar
        self._showAlert = showAlert
        self._alertMessage = alertMessage
        self.content = content()
    }

    var body: some View {
        
        NavigationStack {
            ZStack {
                content // 주요 뷰가 보여질 자리
                
                // 어두운 배경 영역
                Color.black
                    .opacity(showSidebar ? 0.3 : 0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showSidebar = false
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: showSidebar)

                // 사이드바
                HStack(spacing: 0) {
                    Spacer()

                    VStack(alignment: .leading, spacing: 20) {
                        // 로그인 버튼 (상단)
                        HStack(spacing: 0) {
                            if authViewModel.isLoggedIn {
                                HStack {
                                    Text(UserDefaults.standard.string(forKey: "nickname") ?? "일반사용자")
                                        .font(.system(size: 17, weight: .semibold))
                                    Button(action: {
                                        authViewModel.logout()
                                    }) {
                                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                                            .font(.system(size: 17))
                                    }
                                    .foregroundColor(.primary)
                                }
                            } else {
                                NavigationLink(destination: LoginView()) {
                                    HStack {
                                        Text("로그인")
                                            .font(.system(size: 17, weight: .semibold))
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 17))
                                    }
                                    .foregroundColor(.primary)
                                }
                            }
                        }
                        .padding(.top, 20)

                        // 첫 번째 구분선
                        Rectangle()
                            .fill(Color.primary.opacity(0.1))
                            .frame(height: 1)

                        // 메뉴들 (왼쪽 정렬)
                        Button("구내식당표") {
                            // TODO
                        }
                        .font(.system(size: 17))
                        .foregroundColor(.primary)

                        Button("맛집지도") {
                            alertMessage = "준비중인 서비스입니다."
                            showAlert = true
                        }
                        .font(.system(size: 17))
                        .foregroundColor(.primary)

                        Button("AI추천") {
                            alertMessage = "준비중인 서비스입니다."
                            showAlert = true
                        }
                        .font(.system(size: 17))
                        .foregroundColor(.primary)

                        // 두 번째 구분선
                        Rectangle()
                            .fill(Color.primary.opacity(0.1))
                            .frame(height: 1)

                        Spacer()

                    }
                    .frame(width: 200)
                    .padding(.top, 20)
                    .padding(.horizontal)
                    .background(Color(.systemBackground))
                    .shadow(radius: 5)
                }
                .offset(x: showSidebar ? 0 : UIScreen.main.bounds.width)
                .animation(.easeInOut(duration: 0.3), value: showSidebar)
            }
            .alert(alertMessage, isPresented: $showAlert) {
                Button("확인", role: .cancel) {}
            }
            .toolbar {
                // 네비게이션 바 좌측: 로고 / 우측: 햄버거 메뉴 버튼
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 4) {
                        Image("meokuPNG")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 19)

                        Image("MeokuLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 14)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            showSidebar.toggle()
                        }
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.primary)
                    }
                }
            }
            .toolbarBackground(Color.gray.opacity(0.05), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}
