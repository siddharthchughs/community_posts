import 'package:flutter_test/flutter_test.dart';
import 'package:community_board/src/auth/datasources/supabase_auth_remote_datasource.dart';

void main() {
  group('Supabase auth error mapping', () {
    test('maps rate-limit errors to a friendly signup message', () {
      const message = 'rate limit exceeded';

      final result = resolveSupabaseAuthErrorMessage(message, forSignup: true);

      expect(
        result,
        'Too many signup attempts. Please wait a few minutes or use another email address.',
      );
    });

    test('leaves unrelated auth errors unchanged', () {
      const message = 'invalid login credentials';

      final result = resolveSupabaseAuthErrorMessage(message, forSignup: false);

      expect(result, message);
    });
  });
}
