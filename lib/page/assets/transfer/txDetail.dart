import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/common/components/JumpToBrowserLink.dart';
import 'package:polka_wallet/store/assets.dart';
import 'package:polka_wallet/utils/UI.dart';
import 'package:polka_wallet/utils/format.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class TxDetail extends StatelessWidget {
  TxDetail({
    this.success,
    this.networkName,
    this.action,
    this.eventId,
    this.hash,
    this.block,
    this.info,
  });

  final bool success;
  final String networkName;
  final String action;
  final String eventId;
  final String hash;
  final BlockData block;
  final List<DetailInfoItem> info;

  List<Widget> _buildListView(BuildContext context) {
    final Map<String, String> dic = I18n.of(context).assets;
    Widget buildLabel(String name) {
      return Container(
          padding: EdgeInsets.only(left: 8),
          width: 80,
          child: Text(name, style: Theme.of(context).textTheme.display4));
    }

    var list = <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(32),
            child: success
                ? Image.asset('assets/images/assets/success.png')
                : Image.asset('assets/images/staking/error.png'),
          ),
          Text(
            '$action ${success ? dic['success'] : dic['fail']}',
            style: Theme.of(context).textTheme.display3,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 32),
            child: Text(block != null
                ? block.time.toString().split('.')[0]
                : 'datetime'),
          ),
        ],
      ),
      Divider(),
    ];
    info.forEach((i) {
      list.add(ListTile(
        leading: buildLabel(i.label),
        title: Text(i.title),
        subtitle: i.subtitle != null ? Text(i.subtitle) : null,
        trailing: i.address != null
            ? IconButton(
                icon: Image.asset('assets/images/public/copy.png'),
                onPressed: () => UI.copyAndNotify(context, i.address),
              )
            : null,
      ));
    });
    list.addAll(<Widget>[
      ListTile(
        leading: buildLabel(dic['event']),
        title: Text(eventId),
      ),
      block != null
          ? ListTile(
              leading: buildLabel(dic['block']),
              title: Text('#${block.id}'),
            )
          : Container(),
      block != null
          ? ListTile(
              leading: buildLabel(dic['hash']),
              title: Text(Fmt.address(block.hash)),
            )
          : Container(),
      Padding(
        padding: EdgeInsets.only(top: 8, bottom: 32),
        child: JumpToBrowserLink(
          'https://polkascan.io/pre/${networkName.toLowerCase()}/transaction/0x$hash',
          text: dic['polkascan'],
        ),
      )
    ]);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${I18n.of(context).assets['detail']}'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(children: _buildListView(context)),
      ),
    );
  }
}

class DetailInfoItem {
  DetailInfoItem({this.label, this.title, this.subtitle, this.address});
  final String label;
  final String title;
  final String subtitle;
  final String address;
}
