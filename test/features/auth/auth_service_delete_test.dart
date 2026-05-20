import 'package:flutter_test/flutter_test.dart';
import 'package:math_lingo/core/services/cloud_account_deletion_service.dart';

void main() {
  const service = CloudAccountDeletionService();

  test('fshin Firestore para Auth dhe revokon consent pas suksesit', () async {
    final operations = <String>[];

    final result = await service.deleteAccount(
      uid: 'parent-1',
      deleteCloudData: (uid) async {
        operations.add('cloud:$uid');
        return true;
      },
      deleteAuthAccount: () async {
        operations.add('auth');
        return true;
      },
      revokeConsent: () async => operations.add('revoke'),
    );

    expect(result, CloudAccountDeletionResult.success);
    expect(operations, ['cloud:parent-1', 'auth', 'revoke']);
  });

  test('nuk vazhdon te Auth kur pastrimi i cloud deshton', () async {
    final operations = <String>[];

    final result = await service.deleteAccount(
      uid: 'parent-2',
      deleteCloudData: (uid) async {
        operations.add('cloud:$uid');
        return false;
      },
      deleteAuthAccount: () async {
        operations.add('auth');
        return true;
      },
      revokeConsent: () async => operations.add('revoke'),
    );

    expect(result, CloudAccountDeletionResult.cloudCleanupFailed);
    expect(operations, ['cloud:parent-2']);
  });

  test('nuk revokon consent kur fshirja e Auth deshton', () async {
    final operations = <String>[];

    final result = await service.deleteAccount(
      uid: 'parent-3',
      deleteCloudData: (uid) async {
        operations.add('cloud:$uid');
        return true;
      },
      deleteAuthAccount: () async {
        operations.add('auth');
        return false;
      },
      revokeConsent: () async => operations.add('revoke'),
    );

    expect(result, CloudAccountDeletionResult.authDeletionFailed);
    expect(operations, ['cloud:parent-3', 'auth']);
  });
}