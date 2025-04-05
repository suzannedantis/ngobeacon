import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import '../components/top_nav_bar.dart';
import 'package:ngobeacon/NGO_WIKI/ngo_wiki_model.dart';
import 'package:ngobeacon/NGO_WIKI/ngo_wiki_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'update_ngowiki_page.dart';

class NGOWikiPage extends StatefulWidget {
  const NGOWikiPage({super.key});

  @override
  State<NGOWikiPage> createState() => _NGOWikiPageState();
}

class _NGOWikiPageState extends State<NGOWikiPage> {
  final NGOWikiService _wikiService = NGOWikiService();
  bool _isLoading = true;
  NGOWiki? _wikiData;
  String? _ngoName;

  @override
  void initState() {
    super.initState();
    _loadNGOWikiData();
  }

  Future<void> _loadNGOWikiData() async {
    setState(() => _isLoading = true);

    try {
      final SupabaseClient _supabase = Supabase.instance.client;
      final userId = _supabase.auth.currentUser?.id;

      if (userId != null) {
        final ngoProfile = await _supabase
            .from('ngo_profile')
            .select('ngo_id, ngo_name')
            .eq('authid', userId)
            .maybeSingle();

        if (ngoProfile != null) {
          String ngoId = ngoProfile['ngo_id'] as String;
          _ngoName = ngoProfile['ngo_name'] as String;
          _wikiData = await _wikiService.getWikiByNgoId(ngoId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('NGO profile not found')),
          );
        }
      }
    } catch (e) {
      print('Error loading NGO Wiki data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(),
      bottomNavigationBar: BottomNavBar(selectedIndex: 2),
      backgroundColor: const Color(0xFF0D3C73),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateNGOWikiPage(
                wikiData: _wikiData,
                ngoName: _ngoName,
              ),
            ),
          ).then((_) => _loadNGOWikiData());
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.edit, color: Color(0xFF0D3C73)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Text(
                  _ngoName ?? 'NGO Wiki',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_wikiData == null)
                _buildNoDataView()
              else
                _buildWikiDataView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoDataView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.white,
            size: 50,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Wiki information available',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0D3C73),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateNGOWikiPage(
                    wikiData: null,
                    ngoName: _ngoName,
                  ),
                ),
              ).then((_) => _loadNGOWikiData());
            },
            child: const Text(
              'Add NGO Wiki Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWikiDataView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoSection(
          'Established Date',
          DateFormat('MMMM d, yyyy').format(_wikiData!.establishedDate),
        ),
        _buildInfoSection('Vision', _wikiData!.vision ?? 'Not provided'),
        _buildInfoSection('Mission', _wikiData!.mission ?? 'Not provided'),
        const SizedBox(height: 24),
        const Text(
          'NGO Members',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (_wikiData!.members.isEmpty)
          const Text(
            'No members added',
            style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _wikiData!.members.length,
            itemBuilder: (context, index) {
              final member = _wikiData!.members[index];
              return Card(
                color: Colors.white.withOpacity(0.1),
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          member.name[0].toUpperCase(),
                          style: TextStyle(
                            color: Color(0xFF0D3C73),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (member.designation != null &&
                                member.designation!.isNotEmpty)
                              Text(
                                member.designation!,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              content,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}