# Alliance Manager - Firestore Database Design

Version: 0.1

---

# Goal

Design a Firestore structure that supports:

- Multiple realms
- Multiple alliances
- Members changing alliances
- Permission-based access
- Progress tracking
- Rankings
- Reports
- Notifications
- Future platform growth

---

# Core Rule

A member belongs to a realm permanently.

A member may change alliance.

Therefore, progress data belongs to the member, not the alliance.

---
# Decisions

## Member Permissions

Member permissions can be managed in the app by:

- Platform Owner
- R5
- R4

Permissions should be stored so the app and Firestore security rules can verify them.

---

## Alliance Rank Limits

Each alliance can have up to 100 members.

Rank limits:

```text
R5: 1
R4: up to 11
R3: up to 20
R2: up to 29
R1: remaining members up to 100 total

# Main Collections

```text
realms
alliances
members
accountRequests
notifications
reports
auditLogs
platformSettings