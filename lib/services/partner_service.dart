import 'dart:convert';
import 'package:http/http.dart' as http;

import '../entities/common/reward.dart';
import '../entities/common/address.dart';
import '../entities/partner.dart';
import '../utils/api.dart';
import '../utils/status_codes.dart';

class PartnerService {
  
  // GET /
  Future<List<Partner>> getPartners() async {
    final response = await http.get(Uri.parse(partnersUrl));

    if (response.statusCode == ok) {
      final payload = jsonDecode(response.body);

      return (payload['data'] as List)
          .map((item) => Partner.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch partners');
    }
  }

  // GET /:id
  Future<Partner> getPartnerById(String partnerId) async {
    final response = await http.get(Uri.parse(partnerByIdUrl(partnerId)));

    if (response.statusCode == ok) {
      final payload = jsonDecode(response.body);

      return Partner.fromJson(payload['data'] as Map<String, dynamic>);
    } else {
      throw Exception('Failed to fetch partner');
    }
  }

  // GET /:id/branches
  Future<PartnerBranch> getPartnerBranches(String partnerId) async {
    final response = await http.get(Uri.parse(partnerBranchesUrl(partnerId)));

    if (response.statusCode == ok) {
      final payload = jsonDecode(response.body);

      return PartnerBranch.fromJson(payload['data']);
    } else {
      throw Exception('Failed to fetch partner branches');
    }
  }

  // GET /:id/rewards
  Future<PartnerReward> getPartnerRewards(String partnerId) async {
    final response = await http.get(Uri.parse(partnerRewardsUrl(partnerId)));

    if (response.statusCode == ok) {
      final payload = jsonDecode(response.body);


      return PartnerReward.fromJson(payload['data']);
    } else {
      throw Exception('Failed to fetch partner rewards');
    }
  }
}

class PartnerBranch {
  final String id;
  final List<Address> branches;

  const PartnerBranch(this.id, this.branches);

  factory PartnerBranch.fromJson(Map<String, dynamic> json) {
    return PartnerBranch(json['_id'],
        (json['branches'] as List).map((i) => Address.fromJson(i)).toList());
  }
}

class PartnerReward {
  final String id;
  final List<Reward> rewards;

  const PartnerReward(this.id, this.rewards);

  factory PartnerReward.fromJson(Map<String, dynamic> json) {
    return PartnerReward(json['_id'],
        (json['rewards'] as List).map((i) => Reward.fromJson(i)).toList());
  }
}
