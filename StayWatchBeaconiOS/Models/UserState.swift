//
//  User.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/06/21.
//

import Foundation
import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var id: Int
    var name: String
    var uuid: String
    var email: String
    var role: Int
    var communityId: Int
    var communituName: String
}

//import SwiftUI
//import Combine
//
//struct User: Codable {
//
//}
//
//final class UserState: ObservableObject {
//    @Published var user: User?
//    @Published var isRegisteredEmail: Bool?
//    @Published var statusCode: Int?
//    @Published var community: Community?
//    private var cancellables = Set<AnyCancellable>()
//
//    init() {
//        observeUserState()
//    }
//
//    func observeUserState() {
//        UserStateStore.shared.userStatePublisher
//            .sink { [weak self] user in
//                self?.user = user
//                self?.checkRegisteredEmail()
//            }
//            .store(in: &cancellables)
//    }
//
//    func checkRegisteredEmail() {
//        guard let user = user else { return }
//
//        user.getIdToken(completion: { [weak self] token, error in
//            guard let self = self else { return }
//
//            if let error = error {
//                print("Failed to get token: \(error.localizedDescription)")
//                self.isRegisteredEmail = false
//                return
//            }
//
//            guard let token = token else {
//                print("Token is nil")
//                self.isRegisteredEmail = false
//                return
//            }
//
//            let headers = ["Authorization": "Bearer \(token)"]
//            let url = URL(string: "https://go-staywatch.kajilab.tk/api/v1/check")
//
//            URLSession.shared.dataTaskPublisher(for: url)
//                .map(\.data)
//                .decode(type: AxiosResponse<User>.self, decoder: JSONDecoder())
//                .receive(on: DispatchQueue.main)
//                .sink { completion in
//                    switch completion {
//                    case .finished:
//                        break
//                    case .failure(let error):
//                        if let statusCode = (error as? URLError)?.errorUserInfo["HTTPStatusCode"] as? Int {
//                            self.statusCode = statusCode
//                        }
//                        self.isRegisteredEmail = false
//                    }
//                } receiveValue: { response in
//                    self.isRegisteredEmail = true
//                    self.setUserRole(response.data.role)
//                    self.statusCode = response.status
//                    self.setCommunity(Community(communityId: response.data.communityId, communityName: response.data.communityName))
//                }
//                .store(in: &self.cancellables)
//        })
//    }
//}
