import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ngobeacon/NGO_WIKI/ngo_wiki_model.dart';

class NGOWikiService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // Get wiki data for an NGO
  Future<NGOWiki?> getWikiByNgoId(String ngoId) async {
    try {
      print("Getting wiki data for NGO ID: $ngoId");

      // Fetch wiki data
      final wikiResponse = await _supabaseClient
          .from('ngowiki')
          .select()
          .eq('ngo_id', ngoId)
          .maybeSingle();

      if (wikiResponse == null) {
        print("No wiki found for NGO ID: $ngoId");
        return null;
      }

      print("Wiki data found: ${wikiResponse['wiki_id']}");

      // Create wiki object
      NGOWiki wiki = NGOWiki.fromJson(wikiResponse);

      // Fetch members data
      final membersResponse = await _supabaseClient
          .from('wiki_ngomembers')
          .select()
          .eq('wiki_id', wiki.wikiId!);

      print("Found ${membersResponse.length} members for wiki");

      // Add members to wiki object
      List<NGOWikiMember> members = membersResponse
          .map<NGOWikiMember>((member) => NGOWikiMember.fromJson(member))
          .toList();

      return NGOWiki(
        wikiId: wiki.wikiId,
        ngo_id: wiki.ngo_id,
        establishedDate: wiki.establishedDate,
        vision: wiki.vision,
        mission: wiki.mission,
        members: members,
      );
    } catch (e) {
      print('Error fetching NGO Wiki: $e');
      return null;
    }
  }

  Future<NGOWiki?> saveWiki(NGOWiki wiki) async {
    try {
      print("Starting saveWiki for NGO ID: ${wiki.ngo_id}");

      // First check if a wiki exists for this NGO
      final existingWikiResponse = await _supabaseClient
          .from('ngowiki')
          .select()
          .eq('ngo_id', wiki.ngo_id);

      String? wikiId;

      // If we found existing wiki(ies)
      if (existingWikiResponse.isNotEmpty) {
        // Get the first one (there should only be one per NGO)
        final existingWiki = existingWikiResponse.first;
        wikiId = existingWiki['wiki_id'] as String;
        print("Updating existing wiki with ID: $wikiId for NGO ID: ${wiki.ngo_id}");

        await _supabaseClient
            .from('ngowiki')
            .update({
          'established_date': wiki.establishedDate.toIso8601String().split('T')[0],
          'vision': wiki.vision,
          'mission': wiki.mission,
        })
            .eq('ngo_id', wiki.ngo_id);

        print("Wiki updated successfully");
      }
      // Otherwise, create new wiki
      else {
        print("Creating new wiki record for NGO ID: ${wiki.ngo_id}");

        final insertResult = await _supabaseClient
            .from('ngowiki')
            .insert({
          'ngo_id': wiki.ngo_id,
          'established_date': wiki.establishedDate.toIso8601String().split('T')[0],
          'vision': wiki.vision,
          'mission': wiki.mission,
        })
            .select()
            .single();  // This can stay single as we're inserting one record

        wikiId = insertResult['wiki_id'] as String;
        print("New wiki created with ID: $wikiId");
      }

      // Rest of your member handling code remains the same...
      if (wikiId != null) {
        // Delete old members
        print("Deleting old member records for wiki ID: $wikiId");
        await _supabaseClient
            .from('wiki_ngomembers')
            .delete()
            .eq('wiki_id', wikiId);

        print("Old members deleted");

        // Insert new members
        if (wiki.members.isNotEmpty) {
          print("Inserting ${wiki.members.length} members");
          List<Map<String, dynamic>> membersToInsert = wiki.members
              .map((member) => {
            'wiki_id': wikiId,
            'name': member.name,
            'designation': member.designation,
          })
              .toList();

          await _supabaseClient
              .from('wiki_ngomembers')
              .insert(membersToInsert);
          print("Members inserted successfully");
        }

        return await getWikiByNgoId(wiki.ngo_id);
      }

      return null;
    } catch (e) {
      print('Error saving NGO Wiki: $e');
      rethrow;
    }
  }}