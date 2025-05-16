import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sync_provider.dart';
import '../widgets/loading_widget.dart';

class SyncView extends StatelessWidget {
  const SyncView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sync = context.watch<SyncProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Sincronização')),
      body: Center(
        child: sync.syncing
            ? const LoadingWidget()
            : ElevatedButton(
                onPressed: () => sync.sync(),
                child: const Text('Sincronizar Agora'),
              ),
      ),
    );
  }
}