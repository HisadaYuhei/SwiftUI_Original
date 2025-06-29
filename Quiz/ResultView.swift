import SwiftUI

struct ResultView: View {
    @Binding var currentScreen: Screen
    @Binding var score: Int
    
    let totalQuestions: Int
    
    var body: some View {
        ZStack {
            VStack {
                Text("Apple Quiz")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(.white))
                    .padding(.top, 20)
                
                Spacer()
                
                VStack {
                    Text("結果")
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundStyle(Color(.white))
                    Text("\(score) / \(totalQuestions) 問正解")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundStyle(Color(.white))
                    
                    //点数によるコメント
                    Text(resultMessage)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(Color(.white))
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                }
                
                Spacer()
                
                Button {
                    score = 0 // スコアをリセット
                    //currentQuestionIndexはQuizViewの@Stateなので、QuizViewが再生成される時にリセットされる
                    currentScreen = .start
                } label: {
                    Text("タイトルへ戻る")
                        .font(.system(size: 18, weight: .bold))
                        .padding(.vertical, 20)
                        .padding(.horizontal, 70)
                        .background(.white)
                        .foregroundStyle(Color(.background))
                        .clipShape(.rect(cornerRadius: 10))
                }
                
            }
            .padding()
        }
    }

    //FBコメント機能
    var resultMessage: String {
        let percentage = Double(score) / Double(totalQuestions)
        
        if percentage == 1.0 {
            return "素晴らしい！\n全問正解です！"
        } else if percentage >= 0.8 {
            return "お見事！\nあと1問で全問正解でしたね！"
        } else if percentage >= 0.5 {
            return "よくできました！\nさらに知識を深めましょう！"
        } else {
            return "ドンマイ！\nもう一度チャレンジしてみよう！"
        }
    }
}

#Preview {
    @Previewable @State var currentScreen: Screen = .result
    @Previewable @State var score: Int = 4
    ZStack {
        Color(.background)
            .ignoresSafeArea()
        ResultView(
            currentScreen: $currentScreen,
            score: $score,
            totalQuestions: 5
        )
    }
}
