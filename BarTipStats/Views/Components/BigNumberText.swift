import SwiftUI

/// 大号数字金额显示组件
struct BigNumberText: View {
    let value: Double
    var font: Font = .system(size: 48, weight: .black, design: .monospaced)
    var color: Color = .tipAmount

    var body: some View {
        Text(value.currencyFormat)
            .font(font)
            .foregroundStyle(color)
            .monospacedDigit()
            .contentTransition(.numericText())
            .minimumScaleFactor(0.5)
            .lineLimit(1)
    }
}

/// 中号数字显示（用于统计卡片等）
struct MediumNumberText: View {
    let value: Double
    var color: Color = .primary

    var body: some View {
        Text(value.currencyFormat)
            .font(.system(size: 28, weight: .bold, design: .monospaced))
            .foregroundStyle(color)
            .monospacedDigit()
            .contentTransition(.numericText())
            .lineLimit(1)
    }
}

#Preview {
    VStack {
        BigNumberText(value: 8888)
        MediumNumberText(value: 1234)
    }
    .preferredColorScheme(.dark)
    .padding()
}
