import SwiftUI

struct QuizView: View {
    @Binding var currentScreen: Screen
    @Binding var score: Int
    @Binding var totalQuestions: Int
    
    // ここにクイズの問題と選択肢、正解を定義します
    let quizItems: [QuizItem] = [
        QuizItem(question: "iPhoneを開発している企業はどこ？", options: ["Google", "Apple", "Samsung"], correctAnswerIndex: 1),
        QuizItem(question: "Appleの共同創業者は誰？（一人選んでください）", options: ["ビル・ゲイツ", "スティーブ・ウォズニアック", "ラリー・ペイジ"], correctAnswerIndex: 1),
        QuizItem(question: "最初のMacintoshが発表された年は？", options: ["1976年", "1984年", "1998年"], correctAnswerIndex: 1),
        QuizItem(question: "Appleの本社があるカリフォルニア州の都市は？", options: ["サンフランシスコ", "パロアルト", "クパチーノ"], correctAnswerIndex: 2),
        QuizItem(question: "SwiftUIが最初に発表されたWWDCの年は？", options: ["2017", "2019", "2021"], correctAnswerIndex: 1)
    ]
    
    @State private var currentQuestionIndex = 0
    @State private var isCorrect: Bool = false
    @State private var isShowingFeedback = false
    @State private var timeRemaining: Int = 10
    @State private var timer: Timer? = nil

    
    var currentQuestion: QuizItem {
        quizItems[currentQuestionIndex]
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text("Apple Quiz")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(.white))
                    .padding(.top, 20)
                
                Spacer()
                
                // Question Text
                Text(currentQuestion.question)
                    .font(.system(size:22,weight:.medium))
                    .foregroundStyle(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .frame(minHeight:100,alignment: .center)
                
                Spacer()
                
                //残り時間
                HStack{
                    Text("残り時間：")
                        .font(.system(size:30,weight:.medium))
                        .foregroundStyle(Color.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .frame(minHeight:100,alignment: .center)

                    Text("\(timeRemaining)")
                        .font(.system(size: 50, weight: .medium))
                        .foregroundStyle(timeRemaining <= 3 ? Color.red : Color.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .frame(minHeight: 100, alignment: .center)

                    
                    Text("秒")
                        .font(.system(size:30,weight:.medium))
                        .foregroundStyle(Color.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .frame(minHeight:100,alignment: .center)
                }
                
                // Feedback Message Area
                Text(isCorrect ? "正解！" : "不正解... 正解は「\(currentQuestion.options[currentQuestion.correctAnswerIndex])」")
                    .font(.headline)
                    .padding(10)
                    .background(.thinMaterial)
                    .foregroundStyle(Color(isCorrect ? .green : .red))
                    .clipShape(.rect(cornerRadius: 10))
                    .opacity(isShowingFeedback ? 1 : 0)
                
                Spacer()
                
                
                // Answer Options
                VStack(spacing: 16) {
                    ForEach(0..<currentQuestion.options.count, id: \.self) { index in
                        Button {
                            answerTapped(index: index)
                        } label: {
                            Text(currentQuestion.options[index])
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(Color(.background))
                                .frame(maxWidth: .infinity, minHeight: 70)
                                .background(.white)
                                .clipShape(.rect(cornerRadius: 10))
                        }
                        .disabled(isShowingFeedback)
                    }
                }
                
            }
            .padding()
        }
        .onAppear {
            totalQuestions = quizItems.count
            startTimer()
        }
    }
    // ボタンがタップされたときの処理
    func answerTapped(index: Int) {
        timer?.invalidate()
        isShowingFeedback = true

        if index == currentQuestion.correctAnswerIndex {
            isCorrect = true
            score += 1
        } else {
            isCorrect = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isShowingFeedback = false

            if currentQuestionIndex < quizItems.count - 1 {
                currentQuestionIndex += 1
                startTimer() // 次の問題用タイマー開始
            } else {
                currentScreen = .result
            }
        }
    }

    
    func startTimer() {
        timer?.invalidate()  // 既存のタイマー停止
        timeRemaining = 10
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                answerTapped(index: -1) // -1は「時間切れ」の特別処理に使う
            }
        }
    }

    
}

// MARK: - Preview
#Preview {
    @Previewable @State var currentScreen: Screen = .quiz
    @Previewable @State var score: Int = 0
    @Previewable @State var totalQuestions: Int = 5
    ZStack {
        Color(.background)
            .ignoresSafeArea()
        QuizView(
            currentScreen: $currentScreen,
            score: $score,
            totalQuestions: $totalQuestions
        )
    }
}

