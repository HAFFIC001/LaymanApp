import Foundation

class AIService {

    //////////////////////////////////////////////////////////
    // INSERT YOUR GEMINI API KEY HERE
    //////////////////////////////////////////////////////////

    private let apiKey = "AIzaSyCvoMRF0dPAkijEfym9rDneSTfFIaYZVd8"


    //////////////////////////////////////////////////////////
    // CORE GEMINI REQUEST FUNCTION
    //////////////////////////////////////////////////////////

    private func callGemini(prompt: String) async -> String {

        guard let endpoint = URL(
            string:
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=\(apiKey)"
        ) else {
            return "Invalid Gemini URL."
        }

        let body: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ]
        ]

        guard let jsonData =
            try? JSONSerialization.data(withJSONObject: body)
        else {
            return "Failed to encode request."
        }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        do {

            let (data, response) =
                try await URLSession.shared.data(for: request)

            guard let http =
                response as? HTTPURLResponse,
                  http.statusCode == 200 else {

                print("Gemini request failed")
                return "No response available."
            }

            let decoded =
                try JSONSerialization.jsonObject(with: data)
                as? [String: Any]

            if let candidates =
                decoded?["candidates"] as? [[String: Any]],
               let content =
                candidates.first?["content"] as? [String: Any],
               let parts =
                content["parts"] as? [[String: Any]],
               let text =
                parts.first?["text"] as? String {

                return text.trimmingCharacters(in: .whitespacesAndNewlines)
            }

        } catch {

            print("Gemini error:", error.localizedDescription)
        }

        return "No response available."
    }


    //////////////////////////////////////////////////////////
    // GENERATE 3 ARTICLE SUMMARIES
    //////////////////////////////////////////////////////////

    func generateSummaries(title: String,
                           url: String) async -> [String] {

        let prompt = """
        Explain this news headline in exactly 3 short beginner-friendly points.

        Headline:
        \(title)

        Link:
        \(url)

        Rules:
        - exactly 3 bullet points
        - each under 18 words
        - no numbering
        - no symbols
        """

        let response = await callGemini(prompt: prompt)

        let cleaned = response
            .replacingOccurrences(of: "•", with: "")
            .replacingOccurrences(of: "-", with: "")

        let lines = cleaned
            .components(separatedBy: "\n")
            .filter {
                !$0.trimmingCharacters(in: .whitespaces).isEmpty
            }

        if lines.count >= 3 {

            return Array(lines.prefix(3))
        }

        // fallback if Gemini returns fewer lines

        return [
            "This article explains the main development happening right now.",
            "It highlights why the situation matters in business or technology.",
            "It also suggests what could happen next."
        ]
    }


    //////////////////////////////////////////////////////////
    // GENERATE SMART QUESTION SUGGESTIONS
    //////////////////////////////////////////////////////////

    func generateQuestions(title: String) async -> [String] {

        let prompt = """
        Generate exactly 3 beginner-level questions about this headline:

        \(title)

        Keep each question under 10 words.
        """

        let response = await callGemini(prompt: prompt)

        let lines = response
            .components(separatedBy: "\n")
            .filter {
                !$0.trimmingCharacters(in: .whitespaces).isEmpty
            }

        if lines.count >= 3 {

            return Array(lines.prefix(3))
        }

        return [
            "What does this news mean?",
            "Why is this important?",
            "What happens next?"
        ]
    }


    //////////////////////////////////////////////////////////
    // ASK LAYMAN RESPONSE
    //////////////////////////////////////////////////////////

    func askLayman(question: String,
                   context: String) async -> String {

        let prompt = """
        Answer clearly for a beginner in 2 short sentences.

        Context:
        \(context)

        Question:
        \(question)
        """

        let response = await callGemini(prompt: prompt)

        return response.isEmpty
        ? "I couldn't find a clear answer yet. Try another question."
        : response
    }


    //////////////////////////////////////////////////////////
    // CHAT QUESTION RESPONSE (FALLBACK MODE)
    //////////////////////////////////////////////////////////

    func askQuestion(question: String,
                     title: String) async -> String {

        let prompt = """
        Explain simply for a beginner.

        Headline:
        \(title)

        Question:
        \(question)

        Answer briefly.
        """

        let response = await callGemini(prompt: prompt)

        return response.isEmpty
        ? "I couldn't generate an answer right now."
        : response
    }
}
