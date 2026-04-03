import SwiftUI
import Supabase

struct AuthView: View {

    @EnvironmentObject var authVM: AuthViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var isLogin = true
    @State private var navigateGuest = false
    @State private var errorMessage = ""

    var body: some View {

        NavigationStack {

            ZStack {

                Color(red: 0.98, green: 0.95, blue: 0.90)
                    .ignoresSafeArea()

                VStack(spacing: 24) {

                    Spacer()

                    ////////////////////////////////////////////////////
                    // TITLE
                    ////////////////////////////////////////////////////

                    Text(isLogin ? "Welcome back" : "Create account")
                        .font(.system(size: 32, weight: .bold))

                    ////////////////////////////////////////////////////
                    // EMAIL FIELD
                    ////////////////////////////////////////////////////

                    TextField("Email", text: $email)
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.horizontal)

                    ////////////////////////////////////////////////////
                    // PASSWORD FIELD
                    ////////////////////////////////////////////////////

                    SecureField("Password", text: $password)
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.horizontal)

                    ////////////////////////////////////////////////////
                    // ERROR MESSAGE
                    ////////////////////////////////////////////////////

                    if !errorMessage.isEmpty {

                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }

                    ////////////////////////////////////////////////////
                    // LOGIN / SIGNUP BUTTON
                    ////////////////////////////////////////////////////

                    Button {

                        Task {
                            await handleAuth()
                        }

                    } label: {

                        Text(isLogin ? "Login" : "Sign Up")
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .clipShape(Capsule())
                            .padding(.horizontal)
                    }

                    ////////////////////////////////////////////////////
                    // SWITCH LOGIN MODE
                    ////////////////////////////////////////////////////

                    Button {

                        isLogin.toggle()

                    } label: {

                        Text(
                            isLogin
                            ? "Don't have an account? Sign up"
                            : "Already have an account? Login"
                        )
                        .font(.footnote)
                        .foregroundColor(.black)
                    }

                    Spacer()

                    ////////////////////////////////////////////////////
                    // CONTINUE WITHOUT LOGIN
                    ////////////////////////////////////////////////////

                    Button {

                        navigateGuest = true

                    } label: {

                        Text("Continue without login")
                            .padding()
                            .background(.white)
                            .clipShape(Capsule())
                    }

                    Spacer().frame(height: 40)
                }
            }

            ////////////////////////////////////////////////////
            // GUEST NAVIGATION
            ////////////////////////////////////////////////////

            .navigationDestination(isPresented: $navigateGuest) {

                MainTabView()
            }
        }
    }
}

//////////////////////////////////////////////////////////////
// AUTH LOGIC
//////////////////////////////////////////////////////////////

extension AuthView {

    func handleAuth() async {

        do {

            if isLogin {

                ////////////////////////////////////////////////////
                // LOGIN USER
                ////////////////////////////////////////////////////

                _ = try await SupabaseManager.shared.client.auth.signIn(
                    email: email,
                    password: password
                )

            } else {

                ////////////////////////////////////////////////////
                // SIGNUP USER
                ////////////////////////////////////////////////////

                let response = try await SupabaseManager.shared.client.auth.signUp(
                    email: email,
                    password: password
                )

                ////////////////////////////////////////////////////
                // CREATE PROFILE ENTRY
                ////////////////////////////////////////////////////

                try await SupabaseManager.shared.client
                    .from("profiles")
                    .insert([
                        "id": response.user.id.uuidString,
                        "email": email,
                        "streak": "0"
                    ])
                    .execute()
            }

            ////////////////////////////////////////////////////
            // UPDATE GLOBAL AUTH STATE
            ////////////////////////////////////////////////////

            authVM.isLoggedIn = true

        } catch {

            errorMessage = error.localizedDescription
        }
    }
}
