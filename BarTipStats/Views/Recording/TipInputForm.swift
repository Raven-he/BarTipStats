import SwiftUI
import SwiftData

/// 小费录入表单（核心交互）
struct TipInputForm: View {
    @Environment(\.modelContext) private var context
    @State private var vm = RecordingViewModel()

    @Query(
        filter: #Predicate<Employee> { $0.isActive == true },
        sort: \Employee.sortOrder
    ) private var employees: [Employee]

    @Query(
        filter: #Predicate<Venue> { $0.isActive == true },
        sort: \Venue.sortOrder
    ) private var venues: [Venue]

    @State private var showEmployeePicker = false
    @State private var showVenuePicker = false

    var body: some View {
        VStack(spacing: 20) {
            // 金额输入
            VStack(spacing: 4) {
                Text("输入金额")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                CurrencyField(text: $vm.amountText)
                    .frame(height: 70)
            }
            .padding(.top, 8)

            // 按钮行：员工 + 场地
            HStack(spacing: 12) {
                // 员工选择按钮
                PickerButton(
                    icon: "person.fill",
                    label: vm.selectedEmployee?.name ?? "选择员工",
                    subtitle: vm.selectedEmployee?.position.displayName,
                    color: .appAccent,
                    action: { showEmployeePicker = true }
                )

                // 场地选择按钮
                PickerButton(
                    icon: "table.furniture.fill",
                    label: vm.selectedVenue?.name ?? "选择场地",
                    subtitle: nil,
                    color: .orange,
                    action: { showVenuePicker = true }
                )
            }

            // 提交按钮
            Button(action: submitTip) {
                HStack(spacing: 10) {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.title2)
                    Text("记一笔")
                        .font(.title3.weight(.bold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(vm.isValid ? Color.appAccent : Color.gray.opacity(0.3))
                .foregroundStyle(vm.isValid ? .white : .gray)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .animation(.easeInOut(duration: 0.2), value: vm.isValid)
            }
            .disabled(!vm.isValid)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.appAccent.opacity(0.15), lineWidth: 1)
        }
        .sheet(isPresented: $showEmployeePicker) {
            EmployeePickerSheet(selection: $vm.selectedEmployee)
        }
        .sheet(isPresented: $showVenuePicker) {
            VenuePickerSheet(selection: $vm.selectedVenue)
        }
        .overlay {
            // 成功动画
            if vm.showSuccess {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.appAccent)
                    Text("已记录！")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4), value: vm.showSuccess)
    }

    private func submitTip() {
        vm.submit(context: context)
    }
}

// MARK: - 选择按钮组件
struct PickerButton: View {
    let icon: String
    let label: String
    var subtitle: String? = nil
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(color)
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.subheadline.weight(.semibold))
                        .lineLimit(1)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .foregroundStyle(.white)
    }
}

#Preview {
    TipInputForm()
        .modelContainer(for: [Employee.self, Venue.self, TipRecord.self], inMemory: true)
        .preferredColorScheme(.dark)
        .padding()
}
