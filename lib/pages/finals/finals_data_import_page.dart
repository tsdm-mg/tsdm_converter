import 'package:flutter/material.dart';
import 'package:tsdm_converter/models/common/models.dart';
import 'package:tsdm_converter/models/stages/ending/preliminary/models.dart';

/// 用于导入初始数据的页面
///
/// 在初赛前
///
/// * 导入所有角色的历史晋级数据
/// * 导入初赛分组
class FinalsDataImportPage extends StatefulWidget {
  /// Constructor.
  const FinalsDataImportPage({required this.onImported, super.key});

  /// Callback when date imported.
  final void Function(EndingPreliminaryGroups groups) onImported;

  @override
  State<FinalsDataImportPage> createState() => _FinalsDataImportPageState();
}

class _FinalsDataImportPageState extends State<FinalsDataImportPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  var _characters = EndingPreliminaryGroups.empty;

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
            children: [
              // A组
              _PreliminaryGroup(
                onSaved: (characters) => setState(() {
                  _characters = _characters.copyWith(groupA: characters);
                  widget.onImported(_characters);
                }),
                key: const ValueKey('groupA'),
              ),

              // B组
              _PreliminaryGroup(
                onSaved: (characters) => setState(() {
                  _characters = _characters.copyWith(groupB: characters);
                  widget.onImported(_characters);
                }),
                key: const ValueKey('groupB'),
              ),

              // C组
              _PreliminaryGroup(
                onSaved: (characters) => setState(() {
                  _characters = _characters.copyWith(groupC: characters);
                  widget.onImported(_characters);
                }),
                key: const ValueKey('groupC'),
              ),

              // D组
              _PreliminaryGroup(
                onSaved: (characters) => setState(() {
                  _characters = _characters.copyWith(groupD: characters);
                  widget.onImported(_characters);
                }),
                key: const ValueKey('groupD'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 初赛的一个分组
class _PreliminaryGroup extends StatefulWidget {
  const _PreliminaryGroup({required this.onSaved, super.key});

  /// Callback when date imported.
  final void Function(Set<Character> characters) onSaved;

  @override
  State<_PreliminaryGroup> createState() => _PreliminaryGroupState();
}

class _PreliminaryGroupState extends State<_PreliminaryGroup>
    with AutomaticKeepAliveClientMixin {
  final _inputFormKey = GlobalKey<FormState>();
  final _promoteFormKey = GlobalKey<FormState>();
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
                key: _inputFormKey,
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
            ElevatedButton(
              child: const Text('整理'),
              onPressed: () {
                debugPrint('checking input form');
                if (!_inputFormKey.currentState!.validate()) {
                  return;
                }
                _updateData(_dataController.text.trim());
                debugPrint('passed input form check');
                debugPrint('checking promotion form');
                if (!_promoteFormKey.currentState!.validate()) {
                  return;
                }
                debugPrint('passed promotion form check');
                debugPrint('save all data');

                _promoteFormKey.currentState!.save();
                // Convert to characters.
                debugPrint('>>> data: $_data');
                widget.onSaved(_data.toSet());
              },
            ),
          ],
        ),
        Expanded(
          child: Form(
            key: _promoteFormKey,
            child: ListView.builder(
              itemCount: _data.length,
              itemExtent: 80,
              itemBuilder: (_, index) => _PreliminaryCharacterInfo(
                character: _data[index].name,
                bangumi: _data[index].bangumi,
                onFinalsUpdate: (int seasonFinals) {
                  _data[index] = _data[index].copyWith(
                    promoteStatus: _data[index]
                        .promoteStatus
                        .copyWith(seasonFinals: seasonFinals),
                  );
                },
                onRepechageUpdate: (int seasonRepechage) {
                  _data[index] = _data[index].copyWith(
                    promoteStatus: _data[index]
                        .promoteStatus
                        .copyWith(seasonRepechage: seasonRepechage),
                  );
                },
              ),
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
    required this.onFinalsUpdate,
    required this.onRepechageUpdate,
  }) : super(key: ValueKey('$character@$bangumi'));

  final String character;

  final String bangumi;

  final void Function(int seasonFinals) onFinalsUpdate;
  final void Function(int seasonRepechage) onRepechageUpdate;

  @override
  State<_PreliminaryCharacterInfo> createState() =>
      _PreliminaryCharacterInfoState();
}

class _PreliminaryCharacterInfoState extends State<_PreliminaryCharacterInfo> {
  // final _formKey = GlobalKey<FormState>();
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
    return Row(
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
            onSaved: (v) => widget.onFinalsUpdate(int.parse(v!)),
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
            onSaved: (v) => widget.onRepechageUpdate(int.parse(v!)),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
