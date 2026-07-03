# Alliance Manager - Project Specification

Version: 0.1
Status: In Development

---

# Project Vision

Alliance Manager is a companion application for War and Order alliances.

The application helps alliance leaders and members manage:

- Members
- Progress
- Statistics
- Activity
- Upgrades
- Rankings
- Reports
- Alliance organization

The first supported alliance is APX in Realm 1360.

The system must be designed to support unlimited realms and alliances in the future.

---

# Core Principles

- Modern architecture
- Scalable database
- Clean code
- Reusable UI components
- Role-based permissions
- Mobile-first design
- Firebase backend
- Easy to maintain
- Easy to expand

---

# Identity Rules

## AM ID

Every player receives a permanent Alliance Manager ID.

Format:

AM-REALM-NUMBER

Examples:

AM-1360-001

AM-1360-157

AM-1360-1024

Rules:

- Realm is part of the AM ID.
- Alliance is NOT part of the AM ID.
- Players may change alliances.
- Players cannot change realms.
- AM ID never changes.

---

# Login

Members log in using:

- AM ID
- Password

Members DO NOT use email.

Email is reserved only for Platform Owner account recovery.

---

# Account Request Flow

If a player does not have an account:

1. Open Alliance Manager
2. Select Create Account
3. Enter:
   - Player Name
   - Realm
   - Alliance Name
4. Submit request
5. R4/R5 receive notification
6. R4/R5 approve or reject
7. If approved:
   - AM ID is generated
   - Temporary password is generated
8. Player logs in
9. Player is forced to change password

---

# Realm & Alliance Rules

Alliance identity is:

Realm + Alliance Name

Example:

Realm 1360

Alliance APX

Rules:

- Multiple realms may have an alliance with the same name.
- A realm cannot contain two alliances with the same name.
- Players may move between alliances.
- Players always remain in their original realm.

---

# User Roles

There are two categories of roles.

## Platform Roles

### Platform Owner

The Platform Owner can:

- Manage the entire platform
- Create realms
- Create alliances
- Assign the first R5
- Recover owner accounts
- Manage subscriptions
- Access every alliance
- Override permissions when necessary

---

## Alliance Roles

### R5 (Alliance Leader)

The Alliance Leader can:

- Fully manage the alliance
- Approve account requests
- Create player accounts
- Generate temporary passwords
- Promote and demote members
- Remove members
- Manage alliance settings
- View all reports
- Perform every R4 action
- Transfer R5 ownership
- Delete the alliance

---

### R4 (Deputy)

The Deputy can:

- Approve account requests
- Create player accounts
- Generate temporary passwords
- Edit member information
- Promote and demote members (except R5)
- Manage alliance settings
- View reports
- Manage most alliance operations

Restrictions:

- Cannot transfer R5 ownership
- Cannot delete the alliance

---

### R3

Officer role.

Permissions are assigned through the permission system.

---

### R2

Elite member.

Permissions are assigned through the permission system.

---

### R1

Regular member.

Permissions are assigned through the permission system.

---

# Permission System

Permissions are NOT hardcoded to roles.

Roles are collections of permissions.

Example:

approveAccount

createMember

editMember

manageAlliance

deleteAlliance

transferR5

editOwnProgress

viewStatistics

The application always checks permissions instead of checking roles.

Example:

NOT

if role == R4

Instead

if user.hasPermission()

This allows future custom roles without changing the application code.

---

# Member Information

Each member contains:

- AM ID
- Player Name
- War and Order Player ID
- Realm
- Alliance
- Rank
- Castle Level
- Frontline Troop
- Backline Troop
- Status
- Overall Progress
- Created Date
- Last Login
- First Login Password Change Required

---

# Member Status

Possible statuses:

- Active
- Vacation
- Inactive
- Archived

---

# Troops

Players select:

Frontline

Backline

Available troop types:

- Infantry
- Cavalry
- Archer
- Mage

Angels are tracked separately when required.

---

# Planned Modules

Authentication

Dashboard

Members

Beast

Equipment

Artifacts

Colossus

Mystic

High Tech

Totem

Titan

Decorations

Statistics

Rankings

Reports

Notifications

Settings

---

# UI Direction

The application should follow a modern fantasy style.

Visual guidelines:

- Dark background
- Gold borders
- Blue primary buttons
- Medieval inspired accents
- Modern layouts
- Clean typography
- Reusable components

The application should feel like a premium companion app instead of a generic Flutter application.

---

# Development Rules

- Work on feature branches.
- Keep master stable.
- Merge only completed features.
- Use reusable widgets.
- Avoid duplicated code.
- Never hardcode permissions.
- Document every architectural decision.
- Prefer scalable solutions over quick fixes.