typedef DeleteCloudData = Future<bool> Function(String uid);
typedef DeleteAuthAccount = Future<bool> Function();
typedef RevokeCloudConsent = Future<void> Function();

enum CloudAccountDeletionResult {
  success,
  cloudCleanupFailed,
  authDeletionFailed,
}

class CloudAccountDeletionService {
  const CloudAccountDeletionService();

  Future<CloudAccountDeletionResult> deleteAccount({
    required String uid,
    required DeleteCloudData deleteCloudData,
    required DeleteAuthAccount deleteAuthAccount,
    required RevokeCloudConsent revokeConsent,
  }) async {
    final cloudDeleted = await deleteCloudData(uid);
    if (!cloudDeleted) {
      return CloudAccountDeletionResult.cloudCleanupFailed;
    }

    final deleted = await deleteAuthAccount();
    if (!deleted) {
      return CloudAccountDeletionResult.authDeletionFailed;
    }

    await revokeConsent();

    return CloudAccountDeletionResult.success;
  }
}