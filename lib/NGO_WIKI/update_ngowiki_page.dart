import 'package:flutter/material.dart';
import 'package:ngobeacon/NGO_WIKI/ngowiki_page.dart';
import '../components/bottom_nav_bar.dart';
import '../components/top_nav_bar.dart';
import 'package:ngobeacon/NGO_WIKI/ngo_wiki_model.dart';
import 'package:ngobeacon/NGO_WIKI/ngo_wiki_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class UpdateNGOWikiPage extends StatefulWidget {
  final NGOWiki? wikiData;
  final String? ngoName;

  const UpdateNGOWikiPage({
    Key? key,
    this.wikiData,
    this.ngoName,
  }) : super(key: key);

  @override
  State<UpdateNGOWikiPage> createState() => _UpdateNGOWikiPageState();
}

class _UpdateNGOWikiPageState extends State<UpdateNGOWikiPage> {
  final NGOWikiService _wikiService = NGOWikiService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isSaving = false;

  // Text controllers
  final TextEditingController _establishedDateController = TextEditingController();
  final TextEditingController _visionController = TextEditingController();
  final TextEditingController _missionController = TextEditingController();
  List<TextEditingController> _nameControllers = [TextEditingController()];
  List<TextEditingController> _designationControllers = [TextEditingController()];

  // NGO ID
  String? _ngoId;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    if (widget.wikiData != null) {
      _populateFields(widget.wikiData!);
      _ngoId = widget.wikiData!.ngo_id;
      setState(() => _isLoading = false);
    } else {
      _loadNGOWikiData();
    }
  }

  Future<void> _loadNGOWikiData() async {
    setState(() => _isLoading = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final ngoProfile = await Supabase.instance.client
            .from('ngo_profile')
            .select('ngo_id')
            .eq('authid', user.id)
            .maybeSingle();

        if (ngoProfile != null) {
          _ngoId = ngoProfile['ngo_id'] as String;
          final wikiData = await _wikiService.getWikiByNgoId(_ngoId!);
          if (wikiData != null) {
            _populateFields(wikiData);
          } else {
            _establishedDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _populateFields(NGOWiki wiki) {
    _establishedDateController.text = DateFormat('yyyy-MM-dd').format(wiki.establishedDate);
    _visionController.text = wiki.vision ?? '';
    _missionController.text = wiki.mission ?? '';

    // Clear existing controllers
    _nameControllers.forEach((c) => c.dispose());
    _designationControllers.forEach((c) => c.dispose());

    // Initialize with existing members or one empty field
    _nameControllers = wiki.members.isNotEmpty
        ? wiki.members.map((m) => TextEditingController(text: m.name)).toList()
        : [TextEditingController()];

    _designationControllers = wiki.members.isNotEmpty
        ? wiki.members.map((m) => TextEditingController(text: m.designation ?? '')).toList()
        : [TextEditingController()];
  }

  void _addMemberField() {
    setState(() {
      _nameControllers.add(TextEditingController());
      _designationControllers.add(TextEditingController());
    });
  }

  void _removeMemberField(int index) {
    if (_nameControllers.length > 1) {
      setState(() {
        _nameControllers[index].dispose();
        _designationControllers[index].dispose();
        _nameControllers.removeAt(index);
        _designationControllers.removeAt(index);
      });
    }
  }

  Future<void> _saveWikiData() async {
    if (!_formKey.currentState!.validate() || _ngoId == null) return;

    setState(() => _isSaving = true);

    try {
      final members = <NGOWikiMember>[];
      for (int i = 0; i < _nameControllers.length; i++) {
        if (_nameControllers[i].text.isNotEmpty) {
          members.add(NGOWikiMember(
            name: _nameControllers[i].text,
            designation: _designationControllers[i].text.isNotEmpty
                ? _designationControllers[i].text
                : null,
          ));
        }
      }

      final wikiToSave = NGOWiki(
        wikiId: widget.wikiData?.wikiId,
        ngo_id: _ngoId!,
        establishedDate: DateTime.parse(_establishedDateController.text),
        vision: _visionController.text.isNotEmpty ? _visionController.text : null,
        mission: _missionController.text.isNotEmpty ? _missionController.text : null,
        members: members,
      );

      final savedWiki = await _wikiService.saveWiki(wikiToSave);

      if (savedWiki != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NGOWikiPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 2),
      backgroundColor: const Color(0xFF0D3C73),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateField(),
              const SizedBox(height: 16),
              _buildTextField(_visionController, 'Vision', maxLines: 3),
              const SizedBox(height: 16),
              _buildTextField(_missionController, 'Mission', maxLines: 3),
              const SizedBox(height: 24),
              _buildMembersSection(),
              const SizedBox(height: 24),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Established Date',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _establishedDateController,
          readOnly: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.white),
          ),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _establishedDateController.text.isNotEmpty
                  ? DateTime.parse(_establishedDateController.text)
                  : DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              _establishedDateController.text = DateFormat('yyyy-MM-dd').format(date);
            }
          },
          validator: (value) => value?.isEmpty ?? true ? 'Required field' : null,
        ),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        int maxLines = 1,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMembersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NGO Members',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _nameControllers.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: Colors.white.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _buildTextField(
                      _nameControllers[index],
                      'Member Name ${index + 1}',
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      _designationControllers[index],
                      'Designation',
                    ),
                    if (_nameControllers.length > 1)
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () => _removeMemberField(index),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add Member'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF0D3C73),
          ),
          onPressed: _addMemberField,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _isSaving ? null : _saveWikiData,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF0D3C73),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isSaving
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Color(0xFF0D3C73),
            strokeWidth: 3,
          ),
        )
            : const Text(
          'Save Changes',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _establishedDateController.dispose();
    _visionController.dispose();
    _missionController.dispose();
    for (var c in _nameControllers) c.dispose();
    for (var c in _designationControllers) c.dispose();
    super.dispose();
  }
}