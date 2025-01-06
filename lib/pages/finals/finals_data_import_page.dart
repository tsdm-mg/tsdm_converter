import 'package:flutter/material.dart';
import 'package:tsdm_converter/models/common/models.dart';

/// 用于导入初始数据的页面
///
/// 在初赛前
///
/// * 导入所有角色的历史晋级数据
/// * 导入初赛分组
class FinalsDataImportPage extends StatefulWidget {
  /// Constructor.
  const FinalsDataImportPage({super.key});

  @override
  State<FinalsDataImportPage> createState() => _FinalsDataImportPageState();
}

class _FinalsDataImportPageState extends State<FinalsDataImportPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'A组'),
            Tab(text: 'B组'),
            Tab(text: 'C组'),
            Tab(text: 'D组'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              _PreliminaryGroup(key: ValueKey('groupA')),
              _PreliminaryGroup(key: ValueKey('groupB')),
              _PreliminaryGroup(key: ValueKey('groupC')),
              _PreliminaryGroup(key: ValueKey('groupD')),
            ],
          ),
        ),
      ],
    );
  }
}

/// 初赛的一个分组
class _PreliminaryGroup extends StatefulWidget {
  const _PreliminaryGroup({super.key});

  @override
  State<_PreliminaryGroup> createState() => _PreliminaryGroupState();
}

class _PreliminaryGroupState extends State<_PreliminaryGroup>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dataController;

  /// Map of {角色 : 作品}
  var _data = <Character>[];

  void _updateData(String rawData) {
    setState(() {
      _data = rawData.split('\n').map((e) {
        final idx = e.indexOf('@');
        return Character(
          name: e.substring(0, idx).trim(),
          bangumi: e.substring(idx + 1).trim(),
          promoteStatus: PromoteStatus.empty(),
        );
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _dataController = TextEditingController();
  }

  @override
  void dispose() {
    _dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      spacing: 4,
      children: [
        Row(
          spacing: 4,
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextFormField(
                    controller: _dataController,
                    decoration: const InputDecoration(
                      labelText: '分组数据',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    maxLines: 4,
                    minLines: 4,
                    validator: (v) {
                      if (v == null) {
                        return '每行的格式应为 角色@作品';
                      }
                      if (v.split('\n').any(
                            (e) =>
                                // 不含 @
                                !e.contains('@') ||
                                // 仅含一个 @ 且为最后一个字符
                                (e.allMatches('@').length == 1 &&
                                    e.lastIndexOf('@') == e.length - 1),
                          )) {
                        return '每行的格式应为 角色@作品';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            Column(
              spacing: 12,
              children: [
                ElevatedButton(
                  child: const Text('整理'),
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    _updateData(_dataController.text.trim());
                  },
                ),
                ElevatedButton(
                  child: const Text('打印'),
                  onPressed: () async => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Data'),
                      content: SingleChildScrollView(
                        child:
                            Text(_data.map((e) => e.toString()).join('\n\n')),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _data.length,
            itemExtent: 80,
            itemBuilder: (_, index) => _PreliminaryCharacterInfo(
              character: _data[index].name,
              bangumi: _data[index].bangumi,
              onUpdate: (int seasonFinals, int seasonRepechage) {
                _data[index] = _data[index].copyWith(
                  promoteStatus: _data[index].promoteStatus.copyWith(
                        seasonFinals: seasonFinals,
                        seasonRepechage: seasonRepechage,
                      ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/// 每行的角色
class _PreliminaryCharacterInfo extends StatefulWidget {
  // Assigning non-const value key
  // ignore: prefer_const_constructor_declarations
  _PreliminaryCharacterInfo({
    required this.character,
    required this.bangumi,
    required this.onUpdate,
  }) : super(key: ValueKey('$character@$bangumi'));

  final String character;

  final String bangumi;

  final void Function(int seasonFinals, int seasonRepechage) onUpdate;

  @override
  State<_PreliminaryCharacterInfo> createState() =>
      _PreliminaryCharacterInfoState();
}

class _PreliminaryCharacterInfoState extends State<_PreliminaryCharacterInfo> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _finalsController;
  late TextEditingController _repechageController;

  @override
  void initState() {
    super.initState();
    _finalsController = TextEditingController(text: '0');
    _repechageController = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _finalsController.dispose();
    _repechageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: ListTile(
              title: Text(widget.character),
              subtitle: Text(widget.bangumi),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 140),
            child: TextFormField(
              controller: _finalsController,
              decoration: const InputDecoration(
                labelText: '季节赛决赛票数',
              ),
              validator: (v) {
                if (v == null) {
                  return '无效的票数';
                }
                final vv = int.tryParse(v);
                if (vv == null || vv < 0) {
                  return '无效的票数';
                }
                return null;
              },
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 140),
            child: TextFormField(
              controller: _repechageController,
              decoration: const InputDecoration(
                labelText: '季节赛复活赛票数',
              ),
              validator: (v) {
                if (v == null) {
                  return '无效的票数';
                }
                final vv = int.tryParse(v);
                if (vv == null || vv < 0) {
                  return '无效的票数';
                }
                return null;
              },
            ),
          ),
          TextButton(
            child: const Text('更新'),
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              widget.onUpdate(
                int.parse(_finalsController.text),
                int.parse(_repechageController.text),
              );
            },
          ),
        ],
      ),
    );
  }
}
