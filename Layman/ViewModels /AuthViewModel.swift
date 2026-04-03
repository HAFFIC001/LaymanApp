//
//  AuthViewModel.swift
//  Layman
//
//  Created by Aryan Gupta on 03/04/26.
//

import Foundation
import Supabase

@MainActor
class AuthViewModel: ObservableObject {

    @Published var isLoggedIn: Bool = false

    init() {

        Task {

            await checkSession()
        }
    }

    //////////////////////////////////////////////////////////
    // CHECK SESSION
    //////////////////////////////////////////////////////////

    func checkSession() async {

        do {

            _ = try await SupabaseManager.shared.client.auth.session

            isLoggedIn = true

        } catch {

            isLoggedIn = false
        }
    }

    //////////////////////////////////////////////////////////
    // SIGN OUT
    //////////////////////////////////////////////////////////

    func signOut() async {

        do {

            try await SupabaseManager.shared.client.auth.signOut()

            isLoggedIn = false

        } catch {

            print("Sign out failed:", error.localizedDescription)
        }
    }
}
