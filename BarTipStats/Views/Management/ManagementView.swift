import SwiftUI

/// 管理页（员工+场地设置）
struct ManagementView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        EmployeeListView()
                    } label: {
                        Label {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("员工管理")
                                    .font(.body.weight(.medium))
                                Text("添加、编辑、删除工作人员")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        } icon: {
                            Image(systemName: "person.2.fill")
                                .foregroundStyle(.appAccent)
                                .font(.title3)
                        }
                    }

                    NavigationLink {
                        VenueListView()
                    } label: {
                        Label {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("场地管理")
                                    .font(.body.weight(.medium))
                                Text("添加、编辑卡座和散台位置")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        } icon: {
                            Image(systemName: "table.furniture.fill")
                                .foregroundStyle(.orange)
                                .font(.title3)
                        }
                    }
                } header: {
                    Text("基础设置")
                }

                Section {
                    HStack {
                        Label("数据存储", systemImage: "icloud.fill")
                            .foregroundStyle(.blue)
                        Spacer()
                        Text("iCloud 同步")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Label("版本", systemImage: "info.circle.fill")
                            .foregroundStyle(.gray)
                        Spacer()
                        Text("1.0.0")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("关于")
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    ManagementView()
        .preferredColorScheme(.dark)
}
