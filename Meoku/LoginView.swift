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
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode // 이전 화면으로 돌아가기

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
//            TextField("아이디", text: $authViewModel.userId)
//                .padding()
//                .frame(height: textFieldHeight)
//                .background(RoundedRectangle(cornerRadius: 8).stroke(borderColor))
//                .padding(.horizontal)
//
//            SecureField("비밀번호", text: $authViewModel.password)
//                .padding()
//                .frame(height: textFieldHeight)
//                .background(RoundedRectangle(cornerRadius: 8).stroke(borderColor))
//                .padding(.horizontal)
//                .padding(.top, -5)

            CustomTextField(text: $authViewModel.userId, placeholder: "아이디")
                .frame(height: textFieldHeight)
                .padding(.horizontal)

            CustomTextField(text: $authViewModel.password, placeholder: "비밀번호", isSecure: true)
                .frame(height: textFieldHeight)
                .padding(.horizontal)
                .padding(.top, -10)

            // 로그인 버튼
            Button(action: {
                authViewModel.login {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("로그인")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.sRGB, red: 1.0, green: 0.251, blue: 0.016, opacity: 1.0))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .contentShape(Rectangle()) // ← 배경 전체를 터치 영역으로
            }
            .padding(.horizontal)
            .disabled(authViewModel.isLoading) // 로딩 중엔 비활성화
            
            // 로딩 중일 때 표시
            if authViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }

            // 로그인 실패 시 에러 메시지 표시
            if let error = authViewModel.loginError {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            

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
                ForEach(["naver", "kakao", "apple", "google"], id: \.self) { name in
                    Button(action: {
                        // 소셜 로그인 액션
                    }) {
                        Image("slogin\(name)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 50) // 버튼 높이는 원하는 크기로 조정 가능
                    }
                }
            }
            .padding(.top, 8)
            

            Spacer()
        }
        .padding()
        .background(Color.lightGrayBackground)
    }
        
}

// 그냥 textview로 입력 받으면 아이폰 키보드 나타날때 렉걸리고 경고메시지남
struct CustomTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool = false

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.isSecureTextEntry = isSecure
        textField.placeholder = placeholder
        textField.delegate = context.coordinator
        textField.borderStyle = .roundedRect
        
        // 보조 입력 뷰 제거!
        textField.inputAssistantItem.leadingBarButtonGroups = []
        textField.inputAssistantItem.trailingBarButtonGroups = []

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>

        init(_ text: Binding<String>) {
            self.text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text.wrappedValue = textField.text ?? ""
        }
    }
}
    
#Preview {
    @StateObject var authViewModel = AuthViewModel()
    LoginView()
        .environmentObject(authViewModel)
}
