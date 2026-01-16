import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/auth_service.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final TextEditingController _taskController = TextEditingController();
  final AuthService _authService = AuthService();

  // Triggers the pop-up and calendar
  void _showAddTaskDialog(BuildContext context) {
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: const Text("Add New Task", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                decoration: const InputDecoration(hintText: "Task Name"),
              ),
              const SizedBox(height: 20),
              StatefulBuilder(
                builder: (context, setDialogState) {
                  return Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.blue),
                      TextButton(
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null) {
                            setDialogState(() => selectedDate = picked);
                          }
                        },
                        child: Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Add", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                if (_taskController.text.isNotEmpty) {
                  String dateStr = "@ ${selectedDate.day}/${selectedDate.month}";
                  await _authService.addTask(_taskController.text, dueDate: selectedDate, subtitle: dateStr);
                  _taskController.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              _buildMainTaskCard(), // Now dynamic
              const SizedBox(height: 30),
              _buildGeneralTaskList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: const Icon(Icons.add, color: Colors.blue, size: 30),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hi Krishmal', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text('Here are your tasks', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          ],
        ),
        const CircleAvatar(radius: 25, backgroundColor: Color(0xFFE0E7FF), child: Icon(Icons.person, color: Colors.white)),
      ],
    );
  }

  // The Blue Card filtering Today's Tasks
  Widget _buildMainTaskCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        gradient: const LinearGradient(colors: [Color(0xFF00A3FF), Color(0xFF0066FF)]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Today\'s Tasks', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          const Text('Daily Progress', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: _authService.getTodayTasks(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.white));
              var docs = snapshot.data!.docs;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3.5),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  var data = docs[index].data() as Map<String, dynamic>;
                  return Row(
                    children: [
                      Text(data['title'], style: const TextStyle(color: Colors.white)),
                      const SizedBox(width: 5),
                      const Icon(Icons.check_circle, color: Colors.white, size: 14),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralTaskList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _authService.getTasks(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        return Column(
          children: snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(data['subtitle'] ?? "", style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _authService.deleteTask(doc.id),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}