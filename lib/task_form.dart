import 'package:flutter/material.dart';
import 'package:lich_hom_nay/calendar_widget.dart';

class DateTimeField extends StatefulWidget {
  const DateTimeField({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DateTimeFieldState();
  }
}

class _DateTimeFieldState extends State<DateTimeField> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDateTime;

  Future<void> _pickDateTime() async {
    final TextEditingController _controller = TextEditingController();
    DateTime? _selectedDateTime;

    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: _selectedDateTime != null
          ? TimeOfDay.fromDateTime(_selectedDateTime!)
          : TimeOfDay.now(),
    );

    if (time == null) return;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      _selectedDateTime = dateTime;
      _controller.text =
          "${dateTime.day.toString().padLeft(2, '0')}/"
          "${dateTime.month.toString().padLeft(2, '0')}/"
          "${dateTime.year} "
          "${time.hour.toString().padLeft(2, '0')}:"
          "${time.minute.toString().padLeft(2, '0')}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      onTap: _pickDateTime,
      decoration: const InputDecoration(
        labelText: "Chọn ngày & giờ",
        suffixIcon: Icon(Icons.calendar_today),
      ),
      validator: (v) => v == null || v.isEmpty ? "Chọn ngày giờ" : null,
    );
  }
}

class TaskForm extends StatefulWidget {
  const TaskForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TaskFormState();
  }
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(12),
          color: backgoundColor,
          child: Form(
            child: Column(
              children: [
                const Text(
                  "Thêm công việc trong ngày ewew",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: "Tên công việc"),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Không được trống" : null,
                ),
                const SizedBox(height: 20),
                const DateTimeField(),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context, _nameCtrl.text);
                    }
                  },
                  child: const Text("Lưu"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
