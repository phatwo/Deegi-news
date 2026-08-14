import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'network_test_service.dart';
import 'dio_client.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  const baseUrl = 'https://kfalejxynnnrthnsghpj.supabase.co';
  const publishableKey = 'sb_publishable_m7HeNFxcTne1DYyieUDYQg_9eWT_HuZ';

  return DioClient(
    baseUrl: baseUrl,
    publishableKey: publishableKey,
    supabase: Supabase.instance.client,
  );
});

final dioProvider = Provider((ref) {
  return ref.watch(dioClientProvider).dio;
});

final networkTestServiceProvider = Provider<NetworkTestService>((ref) {
  return NetworkTestService(
    ref.watch(dioProvider),
  );
});