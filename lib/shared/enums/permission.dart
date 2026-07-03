enum Permission {
  platformManage,
  platformCreateRealm,
  platformEditRealm,
  platformDeleteRealm,
  platformCreateAlliance,
  platformEditAlliance,
  platformDeleteAlliance,
  platformAssignFirstR5,
  platformManageSubscriptions,

  allianceManage,
  allianceTransferOwnership,
  allianceDelete,
  allianceViewReports,

  memberCreate,
  memberEdit,
  memberDelete,
  memberPromote,
  memberDemote,
  memberChangeRank,

  requestView,
  requestApprove,
  requestReject,
  requestGenerateCredentials,

  statisticsView,
  statisticsExport,

  progressEditOwn,
  progressEditAll,
  progressVerify,

  beastEditOwn,
  beastEditAll,

  equipmentEditOwn,
  equipmentEditAll,

  titanEditOwn,
  titanEditAll,

  mysticEditOwn,
  mysticEditAll,

  highTechEditOwn,
  highTechEditAll,

  decorationsEditOwn,
  decorationsEditAll,

  notificationSend,
  notificationManage,

  adminViewLogs,
  adminOverridePermissions,
}