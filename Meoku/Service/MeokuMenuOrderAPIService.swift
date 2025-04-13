//
//  MeokuMenuOrderAPIService.swift
//  Meoku
//
//  Created by yeomyeongpark on 4/13/25.
//

import Foundation

class MeokuMenuOrderAPIService: ObservableObject {
    @Published var mealOrders: [MealOrder] = []
    
    func fetchMealOrder(for date: Date) {
        // Date를 "yyyy-MM-dd" 형태의 문자열로 변환
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date) // 받은 날짜기준 해당주의 월요일로 조회
        
        // API 요청할 URL 생성
        guard let url = URL(string: "https://port-0-meokuserver-1cupyg2klv9emciy.sel5.cloudtype.app/api/v1/mealOrder/findThisWeekMealOrder") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["requestDate": dateString]
        request.httpBody = try? JSONEncoder().encode(body)

        //요청 전 한번 비우기
        mealOrders = []
        // URLSession을 사용하여 비동기 네트워크 요청을 수행
        URLSession.shared.dataTask(with: request) { data, _, _ in
            
            guard let data = data else {
                return
            }

            // JSON 데이터를 Swift의 구조체로 변환해주는 디코더 생성
            let decoder = JSONDecoder()

            // 서버에서 받은 날짜 형식에 맞게 디코더의 날짜 디코딩 전략 설정
            // ISO 8601 형식("2025-04-05T00:00:00.000+09:00")에 맞춰 설정
            decoder.dateDecodingStrategy = .iso8601

            do {
                let decoded = try decoder.decode(MealOrderGroup.self, from: data)
                DispatchQueue.main.async {
                    self.mealOrders = decoded.responseBody.sorted { $0.mealOrder < $1.mealOrder }
                }
            } catch {
                
                print("디코딩 오류: \(error)")
            }
        }.resume() // dataTask는 기본적으로 멈춘 상태이므로 반드시 resume()을 호출해야 실행됨
    }
}
