from AccessControl.SecurityManagement import (
    getSecurityManager, setSecurityManager, newSecurityManager)
from zope.component import adapts
from zope.site.hooks import getSite
from zope.i18nmessageid.message import MessageFactory

from Products.CMFCore.utils import getToolByName

from plone.stringinterp.adapters import BaseSubstitution,\
    MailAddressSubstitution
from plone.stringinterp.interfaces import IStringSubstitution
from plone.stringinterp.adapters import MemberEmailSubstitution,\
    _recursiveGetMembersFromIds

from collective.local.workspace import api, CLWMessageFactory as _


PMF = MessageFactory('plone')

class WorkspaceTitleSubstitution(BaseSubstitution):
    adapts(IStringSubstitution)

    category = PMF(u'All Content')
    description = _(u'Workspace title')

    def safe_call(self):
        workspace = api.get_workspace(self.context)
        if workspace:
            return workspace.title_or_id()
        else:
            return ""


class WorkspaceManagerEmailSubstitution(MailAddressSubstitution):

    category = PMF(u'E-Mail Addresses')
    description = _(u'Workspace managers')

    def safe_call(self):
        return self.getEmailsForRole('WorkspaceManager')


class AllowedMemberEmailSubstitution(MemberEmailSubstitution):

    category = PMF(u'E-Mail Addresses')
    description = _(u'Members who have access to the content')

    def getEmailsForRole(self, role):

        portal = getSite()
        acl_users = getToolByName(portal, 'acl_users')

        # get a set of ids of members with the global role
        ids = set([p[0] for p in acl_users.portal_role_manager.listAssignedPrincipals(role)])

        # union with set of ids of members with the local role
#        ids |= set([id for id, irole
#                       in acl_users._getAllLocalRoles(self.context).items()
#                       if role in irole])

        # get members from group or member ids
        members = _recursiveGetMembersFromIds(portal, ids)

        # get only allowed members
        allowed_members = []
        old_sm = getSecurityManager()
        try:
            for m in members:
                # m is a MemberData instance,
                # it doesn't have an allowed method on it,
                # so checkPermission doesn't properly work.
                # PloneUser have this method.
                user = acl_users.getUserById(m.getId())
                newSecurityManager(None, user)
                sm = getSecurityManager()
                if sm.checkPermission('View', self.context):
                    allowed_members.append(m)
        finally:
            setSecurityManager(old_sm)

        # get emails
        return u', '.join(self.getPropsForMembers(allowed_members, 'email'))