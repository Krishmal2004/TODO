import 'package:flutter/material.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hi Krishmal',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Here are your tasks',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFFE0E7FF),
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00A3FF), Color(0xFF0066FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Your main task', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    const Text(
                      'Finish the TODO List App',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 3.5,
                      children: [
                        _buildTaskItem("flow chart", true),
                        _buildTaskItem("sketching", true),
                        _buildTaskItem("interview", true),
                        _buildTaskItem("design", false),
                        _buildTaskItem("prototype", false),
                        _buildTaskItem("review", false),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              _secondaryTaskItem(
                title: "Meet Jordy",
                subtitle: "@ 7.30 pm",
                actions: [
                  const Icon(Icons.chat_bubble_outline, color: Colors.blue, size: 20),
                  const SizedBox(width: 12),
                  const Icon(Icons.send, color: Colors.blue, size: 20),
                  const SizedBox(width: 12),
                  const Icon(Icons.call_outlined, color: Colors.blue, size: 20),
                ],
              ),
              _secondaryTaskItem(
                title: "Current bill 500rs",
                subtitle: "before 8.00 pm",
                actions: [
                  const Text("paywith ", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const Icon(Icons.credit_card, color: Colors.blue, size: 22),
                ],
              ),
              _secondaryTaskItem(
                title: "Movie with GF",
                subtitle: "@11 in dreams",
                actions: [
                  const Icon(Icons.send, color: Colors.blue, size: 22),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: const Icon(Icons.add, color: Colors.blue, size: 30),
      ),
    );
  }

  Widget _buildTaskItem(String title, bool isDone) {
    return Row(
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
        const SizedBox(width: 6),
        Icon(
          isDone ? Icons.check_circle : Icons.radio_button_unchecked,
          color: Colors.white,
          size: 16,
        ),
      ],
    );
  }

  Widget _secondaryTaskItem({required String title, required String subtitle, List<Widget>? actions}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          if (actions != null) Row(children: actions),
        ],
      ),
    );
  }
}