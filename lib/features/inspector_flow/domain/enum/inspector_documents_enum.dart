import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';

enum ReviewStatus { pending, approved, rejected }

ReviewStatus deriveReviewStatus(AuthUser user) {
  final documents = user.documents ?? [];

  final hasRejectedDocs = documents.any((d) => d.adminApproval == 2);
  final hasPendingDocs = documents.any((d) => d.adminApproval == 0);
  final allDocsApproved =
      documents.isNotEmpty && documents.every((d) => d.adminApproval == 1);

  if (user.certificateApproved == 2 || hasRejectedDocs) {
    return ReviewStatus.rejected;
  }

  if (user.certificateApproved != 1 ||
      user.docxOk != true ||
      hasPendingDocs ||
      !allDocsApproved) {
    return ReviewStatus.pending;
  }

  return ReviewStatus.approved;
}
