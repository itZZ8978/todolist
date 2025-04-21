//
//  ContentView.swift
//  todolist
//
//  Created by 잇쬬 on 4/18/25.
//

import SwiftUI

struct TaskItem: Identifiable {
    var id = UUID()
    var text: String
    var isCompleted: Bool
}

struct ContentView: View {
    @State private var newTask: String = ""
    @State private var tasks: [TaskItem] = []
    @State private var showingAlert: Bool = false
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("오늘의 할 일")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.blue)
                
                Spacer()
                
                Text(dateFormatter.string(from: Date()))
                    .font(.body)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            Divider()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .background(Color.gray.opacity(0.5))
                .shadow(color: Color.gray.opacity(0.3), radius: 2, x: 0, y: 2)
            
            List {
                ForEach($tasks, id: \.id) { $task in
                    HStack {
                        Button(action: {
                                task.isCompleted.toggle()
                        }) {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted ? .gray : .blue)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Text(task.text)
                            .strikethrough(task.isCompleted, color: .gray)
                            .foregroundColor(task.isCompleted ? .gray : .primary)
                        
                        Spacer()
                        
                        Button(action: {
                            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                tasks.remove(at: index)
                            }
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.black)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    showingAlert = true
                }) {
                    Image(systemName: "plus.square.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                }
                .padding()
                .alert("할 일 추가", isPresented: $showingAlert, actions: {
                    TextField("할 일을 입력하세요", text: $newTask)
                    Button("추가", action: {
                        if !newTask.isEmpty {
                            tasks.append(TaskItem(text: newTask, isCompleted: false))
                            newTask = ""
                        }
                    })
                    Button("취소", role: .cancel, action: {
                        newTask = ""
                    })
                })
            }
        }
    }
}
