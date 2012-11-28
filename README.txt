.. contents::

Introduction
============

This content type bundles all collective.local.* packages.

It adds a workspace content type where the new WorkspaceManager user role
can manage a groupware :
- inviting new users (to the workspace only) - from collective.local.adduser
- creating groups - from collective.local.adduser - from collective.local.addgroup

Workspace container have a "Members" tab to show all group members - from collective.local.userlisting -,
and an "Emailing" tab to send emails to workspace members - from collective.local.sendto.

Installation
============

Just add the egg to your buildout, and install the module.

You NEED to go to Security page at the root of plone site,
and set the privileges the workspace manager gets by default.

The product only gives ::

    - Sharing page: Delegate roles
    - Manage users
    - Add groups