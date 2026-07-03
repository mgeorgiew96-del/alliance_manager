# Alliance Manager - Permission System

Version: 0.1

---

# Overview

Alliance Manager uses a permission-based authorization system.

The application should NEVER check a user's role directly.

Instead of:

```dart
if (user.role == "R4")
```

Always use:

```dart
if (user.hasPermission(Permission.approveAccount))
```

Roles are simply collections of permissions.

---

# Platform Permissions

## platform.manage

Manage platform settings.

Platform Owner only.

---

## platform.createRealm

Create new realms.

Platform Owner only.

---

## platform.editRealm

Edit realm information.

Platform Owner only.

---

## platform.deleteRealm

Delete realms.

Platform Owner only.

---

## platform.createAlliance

Create new alliances.

Platform Owner only.

---

## platform.editAlliance

Edit any alliance.

Platform Owner only.

---

## platform.deleteAlliance

Delete any alliance.

Platform Owner only.

---

## platform.assignFirstR5

Assign the first R5 of an alliance.

Platform Owner only.

---

## platform.manageSubscriptions

Future subscription management.

Platform Owner only.

---

# Alliance Permissions

## alliance.manage

Manage alliance settings.

Owner, R5, R4

---

## alliance.transferOwnership

Transfer R5 ownership.

Platform Owner, R5

---

## alliance.delete

Delete alliance.

Platform Owner, R5

---

## alliance.viewReports

View alliance reports.

R4+

---

# Member Management

## member.create

Create player accounts.

R4+

---

## member.edit

Edit any member.

R4+

---

## member.delete

Remove member from alliance.

R5+

---

## member.promote

Promote members.

R4+

Restrictions:

Cannot promote above your own rank.

---

## member.demote

Demote members.

R4+

Restrictions:

Cannot demote R5.

---

## member.changeRank

Change member ranks.

R4+

---

# Account Requests

## request.view

View pending requests.

R4+

---

## request.approve

Approve requests.

R4+

---

## request.reject

Reject requests.

R4+

---

## request.generateCredentials

Generate:

- AM ID
- Temporary password

R4+

---

# Statistics

## statistics.view

View alliance statistics.

Everyone.

---

## statistics.export

Export reports.

R4+

---

# Progress

## progress.editOwn

Edit own progress.

Everyone.

---

## progress.editAll

Edit every member's progress.

R4+

---

## progress.verify

Verify submitted progress.

R4+

---

# Beast

## beast.editOwn

Edit own Beast.

Everyone.

---

## beast.editAll

Edit all Beast data.

R4+

---

# Equipment

## equipment.editOwn

Edit own Equipment.

Everyone.

---

## equipment.editAll

Edit all Equipment.

R4+

---

# Titan

## titan.editOwn

Edit own Titan.

Everyone.

---

## titan.editAll

Edit all Titan data.

R4+

---

# Mystic

## mystic.editOwn

Edit own Mystic.

Everyone.

---

## mystic.editAll

Edit all Mystic data.

R4+

---

# High Tech

## highTech.editOwn

Edit own High Tech.

Everyone.

---

## highTech.editAll

Edit all High Tech.

R4+

---

# Decorations

## decorations.editOwn

Edit own Decorations.

Everyone.

---

## decorations.editAll

Edit all Decorations.

R4+

---

# Notifications

## notification.send

Send alliance notifications.

R4+

---

## notification.manage

Manage notification templates.

R5+

---

# Administration

## admin.viewLogs

View audit logs.

Platform Owner

---

## admin.overridePermissions

Override permissions.

Platform Owner

---

## Future Permissions

The permission system is designed so new permissions can be added without changing existing code.

New roles should be created by assigning permission sets instead of changing application logic.