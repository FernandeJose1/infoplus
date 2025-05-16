import 'package:flutter/material.dart';
import '../models/job.dart';

class JobForm extends StatefulWidget {
  final void Function(Job job) onSubmit;

  const JobForm({super.key, required this.onSubmit});

  @override
  State<JobForm> createState() => _JobFormState();
}

class _JobFormState extends State<JobForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _provinceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Título'),
            validator: (value) => value!.isEmpty ? 'Obrigatório' : null,
          ),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(labelText: 'Local'),
          ),
          TextFormField(
            controller: _provinceController,
            decoration: const InputDecoration(labelText: 'Província'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSubmit(
                  Job(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: _titleController.text,
                    location: _locationController.text,
                    province: _provinceController.text,
                  ),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}