import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet_delights/models/cake_model.dart';
import 'package:sweet_delights/providers/cake_provider.dart';
import 'package:sweet_delights/utils/currency_formatter.dart';
import 'add_or_edit_cake_page.dart';

class ManageCakesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cakeProvider = Provider.of<CakeProvider>(context);
    final cakes = cakeProvider.cakes;

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Cakes'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddOrEditCakePage()),
          );
        },
      ),
      body: ListView.builder(
        itemCount: cakes.length,
        itemBuilder: (context, index) {
          final cake = cakes[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(cake.image),
            ),
            title: Text(cake.name),
            subtitle: Text(formatRupiah(cake.price)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddOrEditCakePage(cake: cake),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await cakeProvider.deleteCake(cake.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${cake.name} deleted')),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
