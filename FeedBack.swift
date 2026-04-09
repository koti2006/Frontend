import SwiftUI
import Combine


struct FeedbackView: View {
    // Rating card
    @State private var starRating: Int = 0

    // Scale card
    @State private var scaleSelection: Int? = nil

    // Text feedback card
    @State private var thumbsUp: Bool? = nil
    
    @State private var textFeedback: String = ""

    // Submission state
    @State private var sendingStar = false
    @State private var sendingScale = false
    @State private var sendingText = false

    // Toast / status
    @State private var toastMessage: String? = nil

    // Keyboard responder for real-time UI adjustments (renamed)
    @ObservedObject private var keyboard = FeedbackKeyboardResponder()

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue, Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // top tiny label
                HStack {
                    Text("")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        // Title + divider
                        VStack(spacing: 8) {
                            Text("Feed Back")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding(.top, 10)
                            Divider()
                        }

                        // --- Star Rating Card ---
                        CardView {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Rate Our App!")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Button(action: { resetStar() }) {
                                        Image(systemName: "")
                                            .foregroundColor(.gray)
                                    }
                                }

                                Text("Help us improve our tool to best suit your needs by rating us here!")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .fixedSize(horizontal: false, vertical: true)

                                HStack(spacing: 12) {
                                    ForEach(1...5, id: \.self) { i in
                                        Image(systemName: starRating >= i ? "star.fill" : "star")
                                            .resizable()
                                            .frame(width: 28, height: 28)
                                            .foregroundColor(starRating >= i ? Color.orange : Color.gray)
                                            .onTapGesture {
                                                starTapped(i)
                                            }
                                    }
                                    Spacer()
                                }

                                HStack(spacing: 12) {
                                    Button(action: { cancelStar() }) {
                                        Text("Cancel")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                                    }

                                    Button(action: { submitStar() }) {
                                        if sendingStar {
                                            ProgressView().frame(maxWidth: .infinity).padding(.vertical, 10)
                                        } else {
                                            Text("Submit")
                                                .foregroundColor(.white)
                                                .fontWeight(.semibold)
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 10)
                                        }
                                    }
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.purple))
                                    .disabled(sendingStar || starRating == 0)
                                    .foregroundColor(.white)
                                }
                            }
                        }

                        // --- Numeric Scale Card ---
                        CardView {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Share your feedback")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Button(action: { scaleSelection = nil }) {
                                        Image(systemName: "")
                                            .foregroundColor(.gray)
                                    }
                                }

                                Text("I find this editor fast and easy to use: 1-strongly disagree & 5-strongly agree")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .fixedSize(horizontal: false, vertical: true)

                                HStack(spacing: 12) {
                                    ForEach(1...5, id: \.self) { i in
                                        Button(action: { scaleSelection = i }) {
                                            Text("\(i)")
                                                .fontWeight(.semibold)
                                                .frame(width: 42, height: 42)
                                                .background(RoundedRectangle(cornerRadius: 12).fill(scaleSelection == i ? Color.black : Color(.systemGray6)))
                                                .foregroundColor(scaleSelection == i ? .white : .black)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    Spacer()
                                }

                                HStack(spacing: 12) {
                                    Button(action: { cancelScale() }) {
                                        Text("Cancel")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                                    }

                                    Button(action: { submitScale() }) {
                                        if sendingScale {
                                            ProgressView().frame(maxWidth: .infinity).padding(.vertical, 10)
                                        } else {
                                            Text("Submit")
                                                .foregroundColor(.white)
                                                .fontWeight(.semibold)
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 10)
                                        }
                                    }
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.purple))
                                    .disabled(sendingScale || scaleSelection == nil)
                                }
                            }
                        }

                        // --- Text Feedback Card ---
                        CardView {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Share your feedback")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Button(action: { clearTextFeedback() }) {
                                        Image(systemName: "")
                                            .foregroundColor(.gray)
                                    }
                                }

                                Text("How was working in the Editor today?")
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                // Thumbs row
                                HStack(spacing: 12) {
                                    Button(action: { thumbsUp = true }) {
                                        HStack {
                                            Image(systemName: "hand.thumbsup.fill")
                                            Text("Good")
                                        }
                                        .padding(8)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(thumbsUp == true ? Color(.systemGray5) : Color(.systemGray6)))
                                    }
                                    Button(action: { thumbsUp = false }) {
                                        HStack {
                                            Image(systemName: "hand.thumbsdown.fill")
                                            Text("Bad")
                                        }
                                        .padding(8)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(thumbsUp == false ? Color(.systemGray5) : Color(.systemGray6)))
                                    }
                                    Spacer()
                                }

                                // TextEditor (real-time with system keyboard)
                                TextEditor(text: $textFeedback)
                                    .frame(minHeight: 100, maxHeight: 160)
                                    .padding(8)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                                    .overlay(
                                        Group {
                                            if textFeedback.isEmpty {
                                                Text("Add feedback")
                                                    .foregroundColor(.gray)
                                                    .padding(12)
                                                    .allowsHitTesting(false)
                                            } else { EmptyView() }
                                        }, alignment: .topLeading
                                    )

                                HStack(spacing: 12) {
                                    Button(action: { cancelText() }) {
                                        Text("Cancel")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                                    }

                                    Button(action: { submitText() }) {
                                        if sendingText {
                                            ProgressView().frame(maxWidth: .infinity).padding(.vertical, 10)
                                        } else {
                                            Text("Submit")
                                                .foregroundColor(.white)
                                                .fontWeight(.semibold)
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 10)
                                        }
                                    }
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.purple))
                                    .disabled(sendingText || (thumbsUp == nil && textFeedback.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty))
                                }
                            }
                        }

                        Spacer(minLength: 30)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal, 12)
                    .padding(.top, 6)
                    .padding(.bottom, max(20, keyboard.currentHeight))
                } // ScrollView
            } // VStack

            // Toast
            if let msg = toastMessage {
                VStack {
                    Spacer()
                    Text(msg)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 18)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.85)))
                        .foregroundColor(.white)
                        .padding(.bottom, 40)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .zIndex(5)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation { toastMessage = nil }
                    }
                }
            }
        } // ZStack
        .animation(.easeInOut, value: starRating)
    }

    // MARK: - Actions (simulate real-time submissions)
    private func starTapped(_ i: Int) {
        starRating = i
    }

    private func resetStar() {
        starRating = 0
    }

    private func cancelStar() {
        resetStar()
        toastMessage = "Rating cancelled"
    }

    private func submitStar() {
        guard starRating > 0 else { return }
        sendingStar = true
        toastMessage = "Submitting rating..."
        // simulate network
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            sendingStar = false
            toastMessage = "Rating submitted: \(starRating) ★"
        }
    }

    private func cancelScale() {
        scaleSelection = nil
        toastMessage = "Scale cancelled"
    }

    private func submitScale() {
        guard let v = scaleSelection else { return }
        sendingScale = true
        toastMessage = "Submitting feedback..."
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            sendingScale = false
            toastMessage = "You selected \(v)"
        }
    }

    private func clearTextFeedback() {
        thumbsUp = nil
        textFeedback = ""
    }

    private func cancelText() {
        clearTextFeedback()
        toastMessage = "Feedback cancelled"
    }

    private func submitText() {
        sendingText = true
        toastMessage = "Sending feedback..."
        let currentThumb = thumbsUp
        let currentText = textFeedback.trimmingCharacters(in: .whitespacesAndNewlines)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            sendingText = false
            // clear after success
            thumbsUp = nil
            textFeedback = ""
            toastMessage = "Feedback submitted"
            // In a real app you'd call your API here and handle errors / realtime acknowledgement
            // For demo we just simulate success
            print("Submitted feedback -> thumbs: \(String(describing: currentThumb)), text: \(currentText)")
        }
    }
}

// -----------------------------
// Small Card container for consistent style
// -----------------------------
fileprivate struct CardView<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View {
        VStack { content }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black.opacity(0.04)))
            .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 4)
    }
}

// -----------------------------
// Keyboard responder (renamed to avoid conflict)
// -----------------------------
final class FeedbackKeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    private var cancellables = Set<AnyCancellable>()
    init() {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0.height }

        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }

        Publishers.Merge(willShow, willHide)
            .receive(on: RunLoop.main)
            .assign(to: \.currentHeight, on: self)
            .store(in: &cancellables)
    }
}

// -----------------------------
// Preview
// -----------------------------
struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
            .previewDevice("iPhone 15 Pro")
    }
}

