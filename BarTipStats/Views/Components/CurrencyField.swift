import SwiftUI

/// 金额输入框（纯数字键盘，$ 前缀）
struct CurrencyField: View {
    @Binding var text: String
    var onSubmit: (() -> Void)?

    var body: some View {
        HStack(spacing: 4) {
            Text("¥")
                .font(.system(size: 48, weight: .black, design: .monospaced))
                .foregroundStyle(.appAccent)
                .opacity(text.isEmpty ? 0.3 : 1)

            TextField("0", text: $text)
                .keyboardType(.decimalPad)
                .font(.system(size: 56, weight: .black, design: .monospaced))
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
                .placeholder(when: text.isEmpty) {
                    Text("0")
                        .font(.system(size: 56, weight: .black, design: .monospaced))
                        .foregroundStyle(.gray.opacity(0.4))
                }
                .onSubmit { onSubmit?() }
                .overlay(
                    // 金额实时显示预览
                    Text(text.isEmpty ? "¥0" : "¥\(text)")
                        .font(.system(size: 56, weight: .black, design: .monospaced))
                        .foregroundStyle(.clear)
                        .frame(maxWidth: .infinity, alignment: .leading)
                )
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    CurrencyField(text: .constant("500"))
        .preferredColorScheme(.dark)
        .padding()
}
