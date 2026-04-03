import SwiftUI
import UIKit

struct WelcomeView: View {

    @State private var offset: CGFloat = 0
    @State private var navigate = false
    @State private var appear = false

    var body: some View {

        NavigationStack {

            ZStack {

                //////////////////////////////////////////////////////////
                // BACKGROUND
                //////////////////////////////////////////////////////////

                LinearGradient(
                    colors: [
                        Color(red: 0.96, green: 0.86, blue: 0.78),
                        Color(red: 0.99, green: 0.93, blue: 0.88)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack {

                    //////////////////////////////////////////////////////
                    // APP TITLE
                    //////////////////////////////////////////////////////

                    Text("Layman")
                        .font(.system(size: 44,
                                      weight: .heavy,
                                      design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color.black.opacity(0.9),
                                    Color.black.opacity(0.6)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .padding(.top, 50)
                        .opacity(appear ? 1 : 0)
                        .offset(y: appear ? 0 : -25)

                    Spacer()

                    //////////////////////////////////////////////////////
                    // SLOGAN
                    //////////////////////////////////////////////////////

                    VStack(spacing: 6) {

                        Text("Business,")
                        Text("tech & startups")

                        Text("made simple")
                            .foregroundColor(
                                Color(red: 0.86, green: 0.43, blue: 0.22)
                            )
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 30,
                                  weight: .semibold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black.opacity(0.85))
                    .opacity(appear ? 1 : 0)
                    .offset(y: appear ? 0 : 25)

                    Spacer()

                    swipeButton

                    Spacer().frame(height: 50)
                }
            }

            //////////////////////////////////////////////////////////
            // NAVIGATION
            //////////////////////////////////////////////////////////

            .navigationDestination(isPresented: $navigate) {

                AuthView()
            }

            //////////////////////////////////////////////////////////
            // RESET STATE WHEN VIEW RETURNS
            //////////////////////////////////////////////////////////

            .onAppear {

                offset = 0   // ✅ fixes stuck slider after logout

                withAnimation(.easeOut(duration: 0.9)) {

                    appear = true
                }
            }
        }
    }
}

//////////////////////////////////////////////////////////////
// PREMIUM SWIPE BUTTON (FIXED RESET BEHAVIOR)
//////////////////////////////////////////////////////////////

extension WelcomeView {

    var swipeButton: some View {

        GeometryReader { geo in

            let knobSize: CGFloat = 52
            let maxOffset = geo.size.width - knobSize - 10

            ZStack(alignment: .leading) {

                //////////////////////////////////////////////////////
                // CAPSULE BACKGROUND
                //////////////////////////////////////////////////////

                RoundedRectangle(cornerRadius: 35)
                    .fill(Color(red: 0.86, green: 0.43, blue: 0.22))
                    .frame(height: 62)

                //////////////////////////////////////////////////////
                // PROGRESS FILL
                //////////////////////////////////////////////////////

                RoundedRectangle(cornerRadius: 35)
                    .fill(Color.white.opacity(0.18))
                    .frame(width: offset + knobSize,
                           height: 62)

                //////////////////////////////////////////////////////
                // LABEL
                //////////////////////////////////////////////////////

                Text("Swipe to get started")
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)

                //////////////////////////////////////////////////////
                // DRAG HANDLE
                //////////////////////////////////////////////////////

                Circle()
                    .fill(Color.white)
                    .frame(width: knobSize, height: knobSize)
                    .overlay(
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20,
                                          weight: .bold))
                            .foregroundColor(
                                Color(red: 0.86,
                                      green: 0.43,
                                      blue: 0.22)
                            )
                    )
                    .scaleEffect(offset > 0 ? 1.05 : 1.0)
                    .offset(x: offset)
                    .gesture(

                        DragGesture()

                            .onChanged { gesture in

                                if gesture.translation.width > 0 {

                                    offset = min(
                                        gesture.translation.width,
                                        maxOffset
                                    )
                                }
                            }

                            .onEnded { _ in

                                if offset > maxOffset * 0.65 {

                                    UIImpactFeedbackGenerator(
                                        style: .medium
                                    ).impactOccurred()

                                    withAnimation(.easeOut(duration: 0.25)) {

                                        offset = maxOffset
                                    }

                                    DispatchQueue.main.asyncAfter(
                                        deadline: .now() + 0.2
                                    ) {

                                        navigate = true
                                        offset = 0   // ✅ reset after navigation
                                    }

                                } else {

                                    withAnimation(
                                        .spring(
                                            response: 0.35,
                                            dampingFraction: 0.7
                                        )
                                    ) {

                                        offset = 0
                                    }
                                }
                            }
                    )
                    .padding(.leading, 5)
            }
        }
        .frame(height: 62)
        .padding(.horizontal, 30)
        .shadow(color: Color.orange.opacity(0.25),
                radius: 14,
                y: 8)
    }
}
