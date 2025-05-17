import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/job_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/province_selector.dart';
import '../widgets/job_form.dart';

class JobListView extends StatefulWidget {
  const JobListView({super.key});

  @override
  State<JobListView> createState() => _JobListViewState();
}

class _JobListViewState extends State<JobListView> {
  String selectedProvince = 'Maputo';

  @override
  void initState() {
    super.initState();
    _carregarProvincia();
    Future.microtask(() {
      Navigator.pushReplacementNamed(
        context,
        '/payment',
        arguments: {
          'tipo': 'vaga',
          'valor': 3,
          'pontos': 4,
          'destino': '/jobs',
        },
      );
    });
  }

  Future<void> _carregarProvincia() async {
    final prefs = await SharedPreferences.getInstance();
    final prov = prefs.getString('provinciaSelecionada') ?? 'Maputo';
    setState(() => selectedProvince = prov);
    await context.read<JobProvider>().fetchJobs(prov);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final jobs = context.watch<JobProvider>().jobsByProvince(selectedProvince);

    return Scaffold(
      appBar: AppBar(title: const Text('Vagas')),
      body: Column(
        children: [
          ProvinceSelector(
            selected: selectedProvince,
            onChanged: (val) async {
              if (val != null) {
                setState(() => selectedProvince = val);
                await context.read<JobProvider>().fetchJobs(val);
              }
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (_, i) {
                final job = jobs[i];
                return ListTile(
                  title: Text(job.title),
                  subtitle: Text(job.location),
                  trailing: auth.isAdmin
                      ? IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => context.read<JobProvider>().deleteJob(job.id),
                        )
                      : null,
                );
              },
            ),
          ),
          if (auth.isAdmin)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: JobForm(
                onSubmit: (job) => context.read<JobProvider>().addJob(job),
              ),
            ),
        ],
      ),
    );
  }
}