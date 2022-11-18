import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'adsetting_viewmodel.dart';


List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (ctx) =>AdSettingViewModel() ),
];