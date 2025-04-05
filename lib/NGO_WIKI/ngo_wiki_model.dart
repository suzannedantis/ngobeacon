class NGOWiki {
  final String? wikiId;
  final String ngo_id;
  final DateTime establishedDate;
  final String? vision;
  final String? mission;
  final List<NGOWikiMember> members;

  NGOWiki({
    this.wikiId,
    required this.ngo_id,
    required this.establishedDate,
    this.vision,
    this.mission,
    this.members = const [],
  });

  factory NGOWiki.fromJson(Map<String, dynamic> json) {
    return NGOWiki(
      wikiId: json['wiki_id']?.toString(),
      ngo_id: json['ngo_id'] as String,
      establishedDate: DateTime.parse(json['established_date'] as String),
      vision: json['vision']?.toString(),
      mission: json['mission']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (wikiId != null) 'wiki_id': wikiId,
      'ngo_id': ngo_id,
      'established_date': establishedDate.toIso8601String().split('T')[0],
      if (vision != null) 'vision': vision,
      if (mission != null) 'mission': mission,
    };
  }
}

class NGOWikiMember {
  final String? memberId;
  final String? wikiId;
  final String name;
  final String? designation;

  NGOWikiMember({
    this.memberId,
    this.wikiId,
    required this.name,
    this.designation,
  });

  factory NGOWikiMember.fromJson(Map<String, dynamic> json) {
    return NGOWikiMember(
      memberId: json['member_id']?.toString(),
      wikiId: json['wiki_id']?.toString(),
      name: json['name'] as String,
      designation: json['designation']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (memberId != null) 'member_id': memberId,
      if (wikiId != null) 'wiki_id': wikiId,
      'name': name,
      if (designation != null) 'designation': designation,
    };
  }
}