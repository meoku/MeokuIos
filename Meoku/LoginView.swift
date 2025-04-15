//
//  LoginView.swift
//  Meoku
//
//  Created by yeomyeongpark on 4/14/25.
//
import SwiftUI

private let borderColor = Color.gray.opacity(0.5)
private let textColor = Color(red: 0.4, green: 0.4, blue: 0.4) // #666666
private let textFieldHeight: CGFloat = 50

struct LoginView: View {
    @State private var userId: String = ""
    @State private var password: String = ""
    @State private var keepLoggedIn: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 40)

            // 앱 로고
            Image("LoginLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 70)
            
            Spacer().frame(height: 24)

            // 아이디 및 비밀번호 입력
            TextField("아이디", text: $userId)
                .padding()
                .frame(height: textFieldHeight)
                .background(RoundedRectangle(cornerRadius: 8).stroke(borderColor))
                .padding(.horizontal)

            SecureField("비밀번호", text: $password)
                .padding()
                .frame(height: textFieldHeight)
                .background(RoundedRectangle(cornerRadius: 8).stroke(borderColor))
                .padding(.horizontal)
                .padding(.top, 4)

            // 로그인 상태 유지 체크박스
            HStack {
                Toggle(isOn: $keepLoggedIn) {
                    Text("로그인 상태 유지")
                        .foregroundColor(textColor)
                        .font(.footnote)
                }
                .toggleStyle(CheckboxToggleStyle())
                .padding(.leading)
                Spacer()
            }

            // 로그인 버튼
            Button("로그인") {
                // 로그인 액션
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.sRGB, red: 1.0, green: 0.251, blue: 0.016, opacity: 1.0))
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.horizontal)

            // 아이디 찾기 / 비밀번호 찾기 / 회원가입
            GeometryReader { geometry in
                let totalWidth = geometry.size.width * 2 / 3
                let buttonWidth = totalWidth / 3

                HStack(spacing: 0) {
                    Spacer(minLength: (geometry.size.width - totalWidth) / 2)

                    ForEach(["아이디 찾기", "비밀번호 찾기", "회원가입"].indices, id: \.self) { index in
                        Button(["아이디 찾기", "비밀번호 찾기", "회원가입"][index]) {
                            // 각 버튼 액션
                        }
                        .font(.footnote)
                        .foregroundColor(textColor)
                        .lineLimit(1)
                        .frame(width: buttonWidth)

                        if index < 2 {
                            Text("|")
                                .foregroundColor(textColor)
                        }
                    }

                    Spacer(minLength: (geometry.size.width - totalWidth) / 2)
                }
            }
            .frame(height: 20)

            Spacer().frame(height: 24) // 위 아래 요소사이에 세로간격 24만큼 띄움

            // SNS 계정 로그인 구분선
            HStack {
                Rectangle()
                    .fill(textColor)
                    .frame(height: 1)
                Text("SNS 계정 로그인")
                    .font(.footnote)
                    .foregroundColor(textColor)
                Rectangle()
                    .fill(textColor)
                    .frame(height: 1)
            }
            .padding(.horizontal)

            // 소셜 로그인 버튼들
            HStack(spacing: 20) {
                ForEach(["apple", "google", "naver", "kakao"], id: \.self) { name in
                    Button(action: {
                        // 소셜 로그인 액션
                    }) {
                    }
                }
            }

            Spacer()
        }
        .padding()
    }
}

// Checkbox 스타일
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .foregroundColor(borderColor)
            configuration.label
                .foregroundColor(textColor)
                .font(.footnote)
        }
        .onTapGesture {
            configuration.isOn.toggle()
        }
    }
}
#Preview {
    LoginView()
}
