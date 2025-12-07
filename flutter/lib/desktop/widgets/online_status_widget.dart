import 'package:flutter/material.dart';
import 'package:flutter_hbb/common.dart';
import 'package:flutter_hbb/models/server_model.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class OnlineStatusWidget extends StatefulWidget {
  final VoidCallback? onSvcStatusChanged;

  const OnlineStatusWidget({Key? key, this.onSvcStatusChanged}) : super(key: key);

  @override
  State<OnlineStatusWidget> createState() => _OnlineStatusWidgetState();
}

class _OnlineStatusWidgetState extends State<OnlineStatusWidget> {
  int? _lastStatus;

  @override
  Widget build(BuildContext context) {
    return Consumer<ServerModel>(
      builder: (context, serverModel, child) {
        if (_lastStatus != serverModel.connectStatus) {
            _lastStatus = serverModel.connectStatus;
            if (widget.onSvcStatusChanged != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                    widget.onSvcStatusChanged!();
                });
            }
        }

        Color color;
        String text;
        Widget icon;

        if (serverModel.connectStatus == -1) {
           color = Colors.redAccent;
           text = translate('not_ready_status');
           icon = Icon(Icons.circle, color: color, size: 10);
        } else if (serverModel.connectStatus == 0) {
           color = Colors.orangeAccent;
           text = translate('connecting_status');
           icon = SizedBox(
             width: 10, 
             height: 10, 
             child: CircularProgressIndicator(strokeWidth: 2, color: color)
           );
        } else {
           color = Colors.green;
           text = translate('Ready');
           icon = Icon(Icons.circle, color: color, size: 10);
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
             icon.marginOnly(right: 6),
             Text(text, style: TextStyle(color: color, fontSize: 12)),
          ],
        );
      },
    );
  }
}
