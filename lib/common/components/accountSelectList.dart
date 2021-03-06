import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/common/components/addressIcon.dart';
import 'package:polka_wallet/store/account.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/format.dart';

class AccountSelectList extends StatelessWidget {
  AccountSelectList(this.list);

  final List<AccountData> list;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: list.map((i) {
        String address = i.address;
        if (i.pubKey != null) {
          address = globalAppStore.account.pubKeyAddressMap[i.pubKey];
        }
        return ListTile(
          leading: AddressIcon(address, pubKey: i.pubKey),
          title: Text(i.name),
          subtitle: Text(Fmt.address(address)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => Navigator.of(context).pop(i),
        );
      }).toList(),
    );
  }
}
