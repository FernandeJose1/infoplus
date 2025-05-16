import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reward_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/forms/reward_form.dart';

class RewardView extends StatelessWidget {
  const RewardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rewardProvider = context.watch<RewardProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Brindes')),
      body: ListView.builder(
        itemCount: rewardProvider.rewards.length,
        itemBuilder: (context, index) {
          final reward = rewardProvider.rewards[index];
          return ListTile(
            title: Text(reward.title),
            subtitle: Text('Pontos: ${reward.points}'),
            trailing: auth.isAdmin
                ? IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => rewardProvider.deleteReward(reward.id),
                  )
                : null,
          );
        },
      ),
      floatingActionButton: auth.isAdmin
          ? FloatingActionButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                builder: (_) => RewardForm(onSave: rewardProvider.addReward),
              ),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}