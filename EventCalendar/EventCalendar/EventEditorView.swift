//
//  EventEditorView.swift
//  EventCalendar
//
//  Created by Регина on 01.11.2026.
//

import SwiftUI

struct EventEditorView: View {
    @ObservedObject var vm: CalendarState
    @Environment(\.dismiss) private var dismiss

    let event: CalendarEvent?

    @State private var title: String
    @State private var startDate: Date
    @State private var endDate: Date

    init(vm: CalendarState, event: CalendarEvent? = nil) {
        self.vm = vm
        self.event = event

        let dayStart = Calendar.current.date(
            bySettingHour: 9,
            minute: 0,
            second: 0,
            of: vm.date
        ) ?? vm.date

        let start = event?.startDate ?? dayStart

        let end = event?.endDate
            ?? Calendar.current.date(
                byAdding: .hour,
                value: 1,
                to: start
            )
            ?? start

        _title = State(initialValue: event?.title ?? "")
        _startDate = State(initialValue: start)
        _endDate = State(initialValue: end)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Событие") {
                    TextField("Название события", text: $title)
                }

                Section("Дата и время") {
                    DatePicker(
                        "Начало",
                        selection: $startDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )

                    DatePicker(
                        "Окончание",
                        selection: $endDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }

                if let error = vm.errorText {
                    Section {
                        Text(error)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(event == nil ? "Новое событие" : "Редактирование")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        save()
                    }
                }
            }
            .onAppear {
                vm.errorText = nil
            }
        }
    }

    private func save() {
        let success = vm.save(
            oldEvent: event,
            title: title,
            startDate: startDate,
            endDate: endDate
        )

        if success {
            dismiss()
        }
    }
}
