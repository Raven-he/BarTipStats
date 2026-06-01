import SwiftUI

/// 周期选择器（日/周/月）
struct PeriodSelector: View {
    @Binding var selection: StatPeriod

    var body: some View {
        Picker("周期", selection: $selection) {
            ForEach(StatPeriod.allCases, id: \.self) { period in
                Text(period.rawValue)
                    .tag(period)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
}

#Preview {
    PeriodSelector(selection: .constant(.day))
        .preferredColorScheme(.dark)
}
