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