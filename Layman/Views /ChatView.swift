import SwiftUI

struct ChatView: View {

    let article: Article

    @State private var question = ""
    @State private var messages: [(String, Bool)] = []
    @State private var suggestions: [String] = []
    @State private var isLoading = false

    let aiService = AIService()

    var body: some View {

        VStack(spacing: 12) {

            header

            messagesView

            suggestionChips

            inputBar
        }
        .padding()
        .background(AppColors.background)
        .presentationDetents([.medium, .large])

        //////////////////////////////////////////////////////////
        // LOAD SMART SUGGESTIONS
        //////////////////////////////////////////////////////////

        .task {

            suggestions = await aiService.generateQuestions(
                title: article.title
            )

            if suggestions.isEmpty {

                suggestions = fallbackSuggestions()
            }
        }
    }
}

//////////////////////////////////////////////////////////////
// HEADER
//////////////////////////////////////////////////////////////

extension ChatView {

    var header: some View {

        HStack(spacing: 10) {

            Circle()
                .fill(Color.orange)
                .frame(width: 28, height: 28)

            Text("Hi, I'm Layman! Ask anything about this news.")
                .font(.system(size: 14, weight: .medium))

            Spacer()
        }
    }
}

//////////////////////////////////////////////////////////////
// MESSAGE VIEW (AUTO SCROLL + LOADER)
//////////////////////////////////////////////////////////////

extension ChatView {

    var messagesView: some View {

        ScrollViewReader { proxy in

            ScrollView {

                VStack(alignment: .leading, spacing: 10) {

                    ForEach(messages.indices, id: \.self) { index in

                        if messages[index].1 {

                            HStack {

                                Spacer()

                                Text(messages[index].0)
                                    .padding(10)
                                    .background(Color.orange.opacity(0.85))
                                    .foregroundColor(.white)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 12)
                                    )
                                    .id(index)
                            }

                        } else {

                            HStack {

                                Text(messages[index].0)
                                    .padding(10)
                                    .background(Color.white)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 12)
                                    )
                                    .id(index)

                                Spacer()
                            }
                        }
                    }

                    ////////////////////////////////////////////////////
                    // LOADING INDICATOR
                    ////////////////////////////////////////////////////

                    if isLoading {

                        HStack {

                            ProgressView()

                            Text("Thinking...")
                                .font(.caption)

                            Spacer()
                        }
                    }
                }
                .onChange(of: messages.count) { _ in

                    withAnimation {

                        proxy.scrollTo(messages.count - 1)
                    }
                }
            }
        }
    }
}

//////////////////////////////////////////////////////////////
// SUGGESTION CHIPS
//////////////////////////////////////////////////////////////

extension ChatView {

    var suggestionChips: some View {

        VStack(alignment: .leading, spacing: 8) {

            if !suggestions.isEmpty {

                Text("Question Suggestions")
                    .font(.caption)

                ScrollView(.horizontal, showsIndicators: false) {

                    HStack {

                        ForEach(suggestions, id: \.self) {

                            chip($0)
                        }
                    }
                }
            }
        }
    }

    func chip(_ text: String) -> some View {

        Button {

            ask(text)

        } label: {

            Text(text)
                .font(.caption)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.orange.opacity(0.9))
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
    }
}

//////////////////////////////////////////////////////////////
// INPUT BAR
//////////////////////////////////////////////////////////////

extension ChatView {

    var inputBar: some View {

        HStack {

            TextField(
                "Type your question...",
                text: $question
            )
            .padding(10)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Button {

                ask(question)

            } label: {

                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 26))
                    .foregroundColor(.orange)
            }
        }
    }
}

//////////////////////////////////////////////////////////////
// ASK LAYMAN REQUEST (FIXED CORE LOGIC)
//////////////////////////////////////////////////////////////

extension ChatView {

    func ask(_ text: String) {

        guard !text.isEmpty else { return }

        messages.append((text, true))
        question = ""
        isLoading = true

        Task {

            let reply = await aiService.askLayman(
                question: text,
                context: article.title
            )

            if reply.isEmpty {

                messages.append((
                    "I couldn't find a clear answer yet. Try another question 🙂",
                    false
                ))

            } else {

                messages.append((reply, false))
            }

            isLoading = false
        }
    }
}

//////////////////////////////////////////////////////////////
// FALLBACK QUESTIONS
//////////////////////////////////////////////////////////////

extension ChatView {

    func fallbackSuggestions() -> [String] {

        [

            "What is this article about?",
            "Why does this matter?",
            "What happens next?"
        ]
    }
}
