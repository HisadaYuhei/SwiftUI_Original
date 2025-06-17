import SwiftUI

struct StartView: View {
    @Binding var currentScreen: Screen
    
    var body: some View {
        ZStack {            
            VStack {
                
                Spacer()
                
                Text("Apple Quiz")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(Color(.white))
                
                Spacer()
                
                Button {
                    currentScreen = .quiz
                } label: {
                    Text("START")
                        .font(.system(size: 18, weight: .bold))
                        .padding(.vertical, 20)
                        .padding(.horizontal, 70)
                        .background(.white)
                        .foregroundStyle(Color(.background))
                        .clipShape(.rect(cornerRadius: 10))
                }
                Spacer()
            }
        }
    }
}

#Preview {
    @Previewable @State var currentScreen: Screen = .start
    ZStack {
        Color(.background)
            .ignoresSafeArea()
        StartView(
            currentScreen: $currentScreen
        )
    }
}
